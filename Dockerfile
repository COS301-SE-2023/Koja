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
# advanced options > container name > koja-container
# advanced options > port mapping > 8080
# advanced options > path name > localhost
# run container

# How to sign in
# run the container on docker
# http://localhost:8080/api/v1/auth/app/google/ on your browser
# 10.0.2.2
# F12, go to network tab, click on the link, copy the token
# eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJlbmNyeXB0ZWQiOiIrT09EZXlqWk1CWjV6b3I1OFRBdVZIT2x3akJvbHY1MGFkTjQ5ajdFMWMweW9TWW9zOTNHMUVWT0ord3Z2dGFLMk5XbzQyaHlFMHpqMXdFdDdOTFdnajVzWG4rbGNQaDJhL2orcW56WUJQOWt2dTRvQzRySTY1NHdxRnhRRjNEc1N0aS9yWWpuMHh3bnd0b0Y4QlQxZkg2LythcHhuRnJtMWJQdW92YS9WR3Z3Q2NOR1VhbEt5SmpNaWZpRzlCek1HQ3dUWUV3RlFudHNTWmJjODFiMDdESjNUSElNUnJ4Zk1SZnUzSkVpYzlVSGVUVjJxUXVzcXBOWG84cHZhOGpRZ3NrWEFjOWpxQVh6cDdBTXlaNi9wOWpjSFJDL2R3bitTQmtsSEhiUnhYRTg2V3ZWc1ZOMllTd1VRN1NFMmc4Rm0xcHVyZGY5bzVUQ2V1Y0s3ci9KRVYvNEZnNTYzODM3OUs3c09lNFNKdGpTTDM4K3pKci9ZOTYzM0dRQ3dVTWxmUytSWDZ5eTZIMGVmbDVVZ3RackY2bktUbW9XYUF2Y3pDaytLb3ZYVHNmaTkzZUJlTzJ5Lys1d3hPMWVuZm0rc2hWWVZhVDRQUjROZ1FxSkFISWtzQTZUU1dZT0RiMnpxWnZ0bUM1TkthSC9kSklYZkNiMWY2azlRa09VS2RpNGw1VktvdWJMVnBwQkhYdDM4a2VDcEpSVmpiWGZDYzQ0aFovMDNLR1NFalFuOEZJdXdTVm1pMjR6SnRCbkNzR3N1VFE1My9UVjd6YS9XQkZsbjd2eklnPT0iLCJleHAiOjE2ODk4ODQ4NTR9.BMx6omo8b4gAk0w4v_-f7f7A4K4Tml-SIkx6R_dnplyYptYWBwfzpoc9mLrWU9gBDez-oec5T5ZhN5bT2p0svA