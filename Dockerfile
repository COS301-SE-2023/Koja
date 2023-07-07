# Use an official Ubuntu as a parent image
FROM ubuntu:latest

# Install OpenJDK
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk

# Copy local code to the container image
COPY . .

# Build the spring boot project
RUN ./gradlew build

# Start the built spring boot project
RUN ./gradlew bootRun