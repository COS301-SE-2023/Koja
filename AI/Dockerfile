# Use an official Python runtime as a parent image
FROM --platform=linux/amd64 python:3.8-slim-buster

# Set the working directory in the Docker image
WORKDIR /app

# Set the PORT environment variable
ENV PORT=4000

# Copy the requirements.txt file into the Docker image
COPY requirements.txt ./

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application's source code into the Docker image
COPY . .

# Expose the port specified by the PORT environment variable
EXPOSE $PORT

# Start the Flask application when the Docker container is started
# Notice the "./app/Koja-AI.py", it points to your Flask application
CMD ["python", "Koja-AI.py"]