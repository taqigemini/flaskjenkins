# Base image with Python 3.11
FROM python:3.11.5

# Set up environment variables
ENV FLASK_APP=app.py \
    JENKINS_HOME=/var/jenkins_home

# Install required packages and tools
RUN apt-get update && apt-get install -y \
    software-properties-common \
    openjdk-11-jdk \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Jenkins
RUN curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add - && \
    sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' && \
    apt-get update && apt-get install -y jenkins && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
WORKDIR /app
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . /app

# Expose ports
EXPOSE 8080 50000 5000

# Define the default command to run both Jenkins and Flask app
CMD ["sh", "-c", "service jenkins start && flask run --host=0.0.0.0"]
