# Use a lightweight Python base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy dependency list and install packages
COPY app/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the app source code
COPY app /app

# Environment variables
ENV ENV=dev PORT=8000

# Expose the app port
EXPOSE 8000

# Run the Flask application
CMD ["python", "app.py"]
