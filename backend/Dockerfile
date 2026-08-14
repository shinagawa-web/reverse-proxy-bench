FROM golang:1.23-alpine AS build
WORKDIR /app
COPY go.mod .
COPY main.go .
RUN CGO_ENABLED=0 go build -o server .

FROM scratch
COPY --from=build /app/server /server
EXPOSE 8080
CMD ["/server"]
