# Use the official Golang image as the base image
FROM golang:1.23-alpine AS builder
# Set the working directory inside the container
WORKDIR /app
# Copy the Go module files
COPY go.mod go.sum ./
# Download and install Go dependencies
RUN go mod download
# Copy the rest of the application source code
COPY . .
# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o app .

# Start a new stage from scratch
FROM alpine:latest
# Set the working directory inside the container
WORKDIR /root/
RUN apk add --no-cache tzdata
# Copy the built executable from the previous stage
COPY --from=builder /app/app .
COPY --from=builder /app/lib ./lib
COPY --from=builder /app/share ./share
COPY --from=builder /app/BarcodeReaderCLI ./BarcodeReaderCLI
# Expose the port on which the application will listen
EXPOSE 5005
# Command to run the executable
CMD ["./app"]
