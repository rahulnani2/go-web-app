# Containerize the GO application 
# This MultiStage-DockerFile is used to build the Image and Run the container

# Start with a Base Image
FROM golang:1.22.5 as base 

# Set the working dir inside a container 
WORKDIR /app

# Copy the go.mod file to the working directory
COPY go.mod .

# Download all the dependencies 
RUN go mod download

# Copy the source code to the Working Directory
COPY . .

# Build the application 
RUN go build -o main .

##################################################################
# Reduce the image size by using distroless image
# We will use a distroless image to run our application 

FROM gcr.io/distroless/base

# Copy the binaries from previous stage 
COPY --from=base /app/main .

#Copy the static files from previous stage 
COPY --from=base /app/static ./static

# Expose the port for the application to run 
EXPOSE 8080

# Command to run the application 
CMD ["./main"]
