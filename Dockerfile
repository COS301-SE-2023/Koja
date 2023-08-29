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
RUN echo "KOJA_AWS_RDS_DATABASE_URL=$KOJA_AWS_RDS_DATABASE_URL" >> .env && \
    echo "KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME=$KOJA_AWS_RDS_DATABASE_ADMIN_USERNAME" >> .env && \
    echo "KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD=$KOJA_AWS_RDS_DATABASE_ADMIN_PASSWORD" >> .env && \
    echo "KOJA_AWS_DYNAMODB_ACCESS_KEY_ID=$KOJA_AWS_DYNAMODB_ACCESS_KEY_ID" >> .env && \
    echo "KOJA_AWS_DYNAMODB_ACCESS_KEY_SECRET=$KOJA_AWS_DYNAMODB_ACCESS_KEY_SECRET" >> .env && \
    echo "GOOGLE_CLIENT_ID=$GOOGLE_CLIENT_ID" >> .env && \
    echo "GOOGLE_CLIENT_SECRET=$GOOGLE_CLIENT_SECRET" >> .env && \
    echo "KOJA_JWT_SECRET=$KOJA_JWT_SECRET" >> .env && \
    echo "KOJA_ID_SECRET=$KOJA_AI_SECRET" >> .env && \
    echo "API_KEY=$API_KEY" >> .env && \
    echo "OPENAI_API_KEY=$OPENAI_API_KEY" >> .env

# Document that the service listens on port 8080
EXPOSE 8080

# Start the built spring boot project when the Docker container is started
ENTRYPOINT ["java", "-jar", "/app/Koja-0.0.1-SNAPSHOT.jar"]