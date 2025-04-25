# Stage 1: Build the Go application
FROM golang:1.21 AS builder
WORKDIR /app/backend

COPY backend/go.mod backend/go.sum ./
RUN go mod download

COPY backend/ ./

RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/task-manager .

FROM alpine:latest
WORKDIR /root/

COPY --from=builder /app/task-manager .


COPY frontend ./frontend


EXPOSE 8080


ENV DB_HOST=postgres
ENV DB_USER=postgres
ENV DB_PASSWORD=postgres
ENV DB_NAME=taskdb
ENV DB_PORT=5432
ENV PORT=8080

CMD ["./task-manager"]