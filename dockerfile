# Specifies a parent image
FROM golang:1.23-bullseye

# Creates an app directory to hold your app’s source code
WORKDIR /app

# Copies everything from your root directory into /app
COPY . .

# Installs Go dependencies
RUN go mod download

# Builds your app with optional configuration
RUN CGO_ENABLED=0 GOOS=linux go build -o app .

# Tells Docker which network port your container listens on
EXPOSE 5005

# Specifies the executable command that runs when the container starts
CMD [ “./app ]