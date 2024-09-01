#!/bin/bash

# Set the script and bot directory paths
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
BOT_DIR="$SCRIPT_DIR"

# Prompt user for Docker image and container names
echo "Please name the Docker image to be used:"
read -r IMAGE_NAME

echo "Please name the Docker container:"
read -r CONTAINER_NAME

# Step 1: Fetch the latest release version from GitHub
echo "Fetching the latest release version from GitHub..."
LATEST_VERSION=$(curl -s "https://api.github.com/repos/jagrosh/MusicBot/releases/latest" | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')
JAR_NAME="JMusicBot-$LATEST_VERSION.jar"

# Step 2: Download the latest JAR file
echo "Downloading the latest JMusicBot version: $LATEST_VERSION..."
if curl -L -o "$BOT_DIR/$JAR_NAME" "https://github.com/jagrosh/MusicBot/releases/download/$LATEST_VERSION/$JAR_NAME"; then
    echo "JAR file downloaded successfully."
else
    echo "Error: Failed to download JAR file."
    exit 1
fi

# Step 3: Update Dockerfile (Ensure JAR_NAME is updated)
echo "Updating Dockerfile..."
cat > "$BOT_DIR/Dockerfile" <<EOL
# Use an official OpenJDK runtime as a parent image
FROM eclipse-temurin:11-jre-focal

# Set the working directory in the container
WORKDIR /app

# Copy the new JAR file into the container
COPY $JAR_NAME /app/JMusicBot.jar

# Copy configuration files into the container
COPY config.txt /app/config.txt
COPY Playlists /app/Playlists

# Entry point to run the JAR file
ENTRYPOINT ["java", "-Dconfig=/app/config.txt", "-Dnogui=true", "-jar", "/app/JMusicBot.jar"]
EOL

# Check if Dockerfile was created successfully
if [ -f "$BOT_DIR/Dockerfile" ]; then
    echo "Dockerfile updated successfully."
else
    echo "Error: Failed to create Dockerfile."
    exit 1
fi

# Step 4: Build the Docker image
echo "Building the Docker image..."
if docker build -t "$IMAGE_NAME" "$BOT_DIR"; then
    echo "Docker image built successfully."
else
    echo "Error: Failed to build Docker image."
    exit 1
fi

# Step 5: (Optional) Stop and remove the existing container
#echo "Stopping and removing the existing container..."
#docker stop $CONTAINER_NAME
#docker rm $CONTAINER_NAME

# Step 6: Run the new container
echo "Running the new container..."
if docker run --name "$CONTAINER_NAME" -d \
  -v "$BOT_DIR/config.txt:/app/config.txt:ro" \
  -v "$BOT_DIR/serversettings.json:/app/serversettings.json:ro" \
  -v "$BOT_DIR/Playlists:/app/Playlists:ro" \
  --restart=always \
  "$IMAGE_NAME"; then
    echo "Container $CONTAINER_NAME started successfully."
    echo "Update completed successfully!"
else
    echo "Error: Failed to run the Docker container."
    exit 1
fi
