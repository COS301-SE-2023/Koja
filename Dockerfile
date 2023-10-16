# Use an official Gradle image as a parent image
FROM gradle:latest as builder

# Set the working directory in the Docker image
WORKDIR /home/gradle/project

# Copy the gradle file to the Docker image
COPY build.gradle.kts ./

# Generate the Gradle Wrapper
RUN gradle wrapper

# Copy the rest of the project files to the Docker image
COPY . .

# Install dos2unix and convert gradlew to Unix-style line endings
RUN apt-get update && apt-get install -y dos2unix && dos2unix gradlew && chmod +x gradlew

# Build the spring boot project without running tests or linter
RUN ls -la && ./gradlew build -x test -x check

# Start another stage to reduce the final image size
FROM openjdk:17

WORKDIR /app
# Copy only the built jar file from the first stage
COPY --from=builder /home/gradle/project/build/libs/ /app/

# Create .env file based on the environment variables of the environment where the Dockerfile is being built
RUN echo "koja_server_address=$koja_server_address" >> .env && \
    echo "koja_server_port=$koja_server_port" >> .env


# Start the built spring boot project when the Docker container is started
CMD ["java", "-jar", "/app/Koja-0.0.1-SNAPSHOT.jar"]
