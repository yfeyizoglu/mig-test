# Start with the official Google Cloud SDK image, which has gcloud pre-installed
FROM google/cloud-sdk:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the bash script into the container
COPY script.sh /app/script.sh

# Make the script executable
RUN chmod +x /app/script.sh

# This is the command that runs when the container starts.
# It simply executes your bash script.
CMD ["./script.sh"]
