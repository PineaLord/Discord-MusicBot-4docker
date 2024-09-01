# Music Bot Setup and Configuration

This repository contains scripts for setting up a Music Bot with Docker. The setup process involves configuring the bot and starting it with Docker. Follow the instructions below to configure and run the Music Bot.

## 1. Configuration Script: `config-maker.sh`

### Purpose
The `config-maker.sh` script helps you create a configuration file for your Music Bot by prompting you for various settings. It generates a `config.txt` file based on your inputs.

### Usage

1. **Make the script executable:**
    ```bash
    chmod +x config-maker.sh
    ```

2. **Run the script:**
    ```bash
    ./config-maker.sh
    ```

3. **Follow the prompts to provide:**
   - **Bot Token**: The token used for the bot to log in.
   - **Owner ID**: Your Discord user ID.
   - **Prefix**: The command prefix for interacting with the bot.
   - **Game Setting**: Status or game to display.
   - **Skip Ratio**: Ratio of users required to skip a song.
   - **Alone Time Until Stop**: Time (in seconds) for the bot to leave a channel when alone.

   The script will create a `config.txt` file with your settings and a `Playlists` directory.

## 2. Docker Start Script: `music-bot-docker-start`

### Purpose
The `music-bot-docker-start` script is used to build and run the Music Bot Docker container. It uses the configuration file created by `config-maker.sh` to configure the bot.

### Usage

1. **Make the script executable:**
    ```bash
    chmod +x music-bot-docker-start
    ```

2. **Run the script with `sudo` to start the Docker container:**
    ```bash
    sudo ./music-bot-docker-start
    ```

   This will:
   - Build the Docker image for the Music Bot.
   - Run the Docker container with the necessary configuration.

## Additional Notes

- **Ensure Docker is installed**: Make sure Docker is installed and running on your system before executing `music-bot-docker-start`.
- **Permissions**: Running Docker commands with `sudo` is necessary to ensure the container has the required permissions.

## Troubleshooting

If you encounter issues, verify:
- The Docker service is active.
- The `config.txt` file is correctly formatted and located in the appropriate directory.
- Docker has the necessary permissions and access.

Feel free to contribute to the repository by submitting issues or pull requests.
