import http from 'k6/http';
import { check } from 'k6';

export const options = {
  vus: 20,
  duration: '60s',
  summaryTrendStats: ['p(50)', 'p(95)', 'p(99)', 'avg', 'min', 'max'],
};

export default function () {
  const res = http.get(`${__ENV.TARGET_URL}/ping`);
  check(res, { 'status 200': (r) => r.status === 200 });
}

export function handleSummary(data) {
  const proxy = __ENV.PROXY || 'unknown';
  const m = data.metrics;
  const failedRate = m.http_req_failed ? m.http_req_failed.values.rate : 0;
  const checkFails = m.checks ? m.checks.values.fails : 0;
  const checkTotal = m.checks ? (m.checks.values.passes + m.checks.values.fails) : 0;
  const checkFailRate = checkTotal > 0 ? checkFails / checkTotal : 0;
  const errorRate = Math.max(failedRate, checkFailRate);
  return {
    [`/tmp/bench-${proxy}.json`]: JSON.stringify({
      rps: m.http_reqs.values.rate.toFixed(1),
      p50: m.http_req_duration.values['p(50)'].toFixed(2),
      p95: m.http_req_duration.values['p(95)'].toFixed(2),
      p99: m.http_req_duration.values['p(99)'].toFixed(2),
      errors: (errorRate * 100).toFixed(2) + '%',
    }),
  };
}
