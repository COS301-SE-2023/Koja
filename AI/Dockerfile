# Use an official Python runtime as a parent image
FROM --platform=linux/amd64 python:3.8-slim-buster

# Set the working directory in the Docker image
WORKDIR /app

# Copy the requirements.txt file into the Docker image
COPY requirements.txt ./

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Create .env file based on the environment variables of the environment where the Dockerfile is being built
RUN echo "SERVER_ADDRESS=$SERVER_ADDRESS" >> .env && \
    echo "SERVER_PORT=$SERVER_PORT" >> .env && \
    echo "AI_PRIVATE_KEY_PASS=$koja_ai_private_key_password" >> .env && \
    echo "KOJA_AWS_DYNAMODB_ACCESS_KEY_ID=$koja_aws_dynamodb_access_key_id" >> .env && \
    echo "KOJA_AWS_DYNAMODB_ACCESS_KEY_SECRET=$koja_aws_dynamodb_access_key_secret" >> .env && \
    echo "KOJA_ID_SECRET=$koja_id_secret" >> .env && \
    echo "AI_PRIVATE_KEY_SALT=$koja_ai_private_key_salt" >> .env

# Copy the rest of the application's source code into the Docker image
COPY . .

EXPOSE $PORT

# Start the Flask application when the Docker container is started
# Notice the "./app/Koja-AI.py", it points to your Flask application
CMD ["python", "Koja-AI.py"]
