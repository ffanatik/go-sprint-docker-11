# Build stage
FROM golang:1.22 AS build

WORKDIR /build

COPY . .

RUN go mod download

ENV CGO_ENABLED=0 GOOS=linux

RUN go build -o parcel .

# Final stage
FROM alpine:latest

WORKDIR /app

COPY --from=build /build/parcel .
COPY tracker.db .

ENTRYPOINT ["/app/parcel"]