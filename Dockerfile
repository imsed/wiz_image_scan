# Use the official Ubuntu image as the base
FROM ubuntu:20.04

# Set the working directory
WORKDIR /app

# Install necessary packages
RUN apt-get update && \
    apt-get install -y python3 python3-pip

# Copy the requirements file from local into the container
COPY requirements.txt /app/requirements.txt

# Install any needed packages specified in requirements.txt
RUN pip3 install --trusted-host pypi.python.org -r requirements.txt

# Copy the rest of the application code into the container
COPY . /app

# Set the entrypoint command to run the Python script
CMD ["python3", "app.py"]
