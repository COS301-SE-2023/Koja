# Use an official Python runtime as a parent image
FROM python:3.8-slim-buster

# Set the working directory in the Docker image
WORKDIR /app

# Copy the requirements.txt file into the Docker image
COPY requirements.txt ./

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application's source code into the Docker image
COPY . .

# Expose port 6000 for the Flask application to listen on
EXPOSE 6000

# Start the Flask application when the Docker container is started
CMD [ "python", "./Koja-AI.py" ]
