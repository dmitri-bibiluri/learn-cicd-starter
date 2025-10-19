# Stage 1: Build the Go binary
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -v -o /app/notely .

# Stage 2: Create the final, lightweight image
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/notely .
EXPOSE 8080
CMD ["./notely"]