# Build stage
FROM golang:1.22.5-alpine3.20 AS build

WORKDIR /build

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o parcel .

# Final stage
FROM alpine:latest

WORKDIR /app

COPY --from=build /build/parcel .
COPY tracker.db .

ENTRYPOINT ["/app/parcel"]