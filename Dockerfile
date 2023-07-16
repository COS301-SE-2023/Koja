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

# Copy the .env file into the Docker image
COPY .env .env

# Document that the service listens on port 8080
EXPOSE 8080

# Start the built spring boot project when the Docker container is started
# You need to replace app.jar with your actual jar name.
# For example, if your jar file is named myapp.jar, the line should look like this: ENTRYPOINT ["java", "-jar", "/app/myapp.jar"]
ENTRYPOINT ["java", "-jar", "/app/koja-0.0.1-SNAPSHOT.jar"]

# To run the Docker container, use the following command:
# docker build -t koja-image .