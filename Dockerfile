# Step 1 - Use an official Python runtime as a parent image, considering M1/M2 Mac compatibility
FROM --platform=linux/amd64 public.ecr.aws/docker/library/python:3.9.10-slim-buster

# Step 2 - Set the working directory in the container to /app
WORKDIR /app

# Step 3 - Copy the application files in the container
COPY . /app

# Install system dependencies and ODBC driver
RUN apt-get update && apt-get install -y \
    unixodbc unixodbc-dev odbcinst odbcinst1debian2 libpq-dev gcc && \
    apt-get install -y gnupg && \
    apt-get install -y wget && \
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    wget -qO- https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 && \
    apt-get purge -y --auto-remove wget && \  
    apt-get clean

# Install pip and setuptools
RUN pip install --upgrade pip setuptools

# Step 4 - Install Python packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Step 5 - Expose port 5000
EXPOSE 5000

# Step 6 - Define Startup Command to run the Flask application
CMD ["python", "app.py"]
