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

# Build the spring boot project without running tests or linter
RUN ./gradlew build -x test -x check

# Start another stage to reduce the final image size
FROM openjdk:17

WORKDIR /app

# Copy only the built jar file from the first stage
COPY --from=builder /home/gradle/project/build/libs/*.jar app.jar

# Copy the .env file into the Docker image
COPY .env .env

# Document that the service listens on port 8080
EXPOSE 8080

# Start the built spring boot project when the Docker container is started
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
