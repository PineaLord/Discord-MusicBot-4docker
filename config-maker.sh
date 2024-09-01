#!/bin/bash

# Ask the user for the bot token
echo -e "\e[32mThis sets the token for the bot to log in with\nThis MUST be a bot token (user tokens will not work)\nIf you don't know how to get a bot token, please see the guide here:\n\e[4mhttps://github.com/jagrosh/MusicBot/wiki/Getting-a-Bot-Token\e[0m\n\n\e[32mPlease enter the bot token:\e[0m"
read -r token

# Ask the user for the owner ID
echo -e "\e[32mThis sets the owner of the bot\nThis needs to be the owner's ID (a 17-18 digit number)\n\e[4mhttps://github.com/jagrosh/MusicBot/wiki/Finding-Your-User-ID\e[0m\n\n \e[32mPlease enter the owner's user ID (a 17-18 digit number):\e[0m"
read -r owner

# Ask the user for the bot prefix
echo -e "\e[32mThis sets the prefix for the bot\nThe prefix is used to control the commands\nIf you use 'dj', the play command will be djplay\nIf you do not set this, the prefix will be a mention of the bot (@Botname play)\n\nPlease enter the prefix for the bot (e.g., !!):\e[0m"
read -r prefix

# Ask the user for the game setting
echo -e "\e[32mPlease enter the game setting (type DEFAULT, NONE, or Playing X):\e[0m"
read -r game

# Ask the user for the skip ratio
echo -e "\e[32mThis sets the ratio of users that must vote to skip the currently playing song.\nGuild owners can define their own skip ratios, but this will be used if a guild has not defined their own skip ratio\n\nPlease enter the skip ratio (e.g., 0.1):\e[0m"
read -r skipratio

# Ask the user for the alone time until stop
echo -e "\e[32mThis sets the amount of seconds the bot will stay alone on a voice channel until it automatically leaves the voice channel and clears the queue.\nIf not set or set to any number less than or equal to zero, the bot won't leave when alone\n\nPlease enter the alone time until stop (in seconds)(0 is recommended):\e[0m"
read -r alonetimeuntilstop

########################################################################################
# Define total capacity and the number of segments in the bar
TOTAL_SEGMENTS=45
BAR_CHAR="#"
EMPTY_CHAR="-"

# Define the animation duration in seconds
ANIMATION_DURATION=2
UPDATE_INTERVAL=0.1

# Calculate the number of updates
NUM_UPDATES=$(echo "scale=0; $ANIMATION_DURATION / $UPDATE_INTERVAL" | bc)

# Animate the bar from 0% to 100%
for ((i = 0; i <= 100; i += (100 / TOTAL_SEGMENTS))); do
    # Calculate the number of filled and empty segments
    FILLED_SEGMENTS=$((TOTAL_SEGMENTS * i / 100))
    EMPTY_SEGMENTS=$((TOTAL_SEGMENTS - FILLED_SEGMENTS))

    # Generate the bar
    BAR=$(printf "%${FILLED_SEGMENTS}s" | tr ' ' "$BAR_CHAR")
    BAR+=$(printf "%${EMPTY_SEGMENTS}s" | tr ' ' "$EMPTY_CHAR")

    # Clear the line and print the bar with percentage
    echo -ne "\e[33mWait:\e[0m \e[32m[${BAR}] ${i}%\r\e[0m"

    # Wait for the update interval
    sleep "$UPDATE_INTERVAL"
done

# Ensure the final state is displayed
echo -e "\e[32mDone: [${BAR}] Complete\e[0m"
########################################################################################

# Create the config.txt file with user inputs and defaults
cat <<EOF >config.txt
# This sets the token for the bot to log in with
# This MUST be a bot token (user tokens will not work)
# If you don't know how to get a bot token, please see the guide here:
# https://github.com/jagrosh/MusicBot/wiki/Getting-a-Bot-Token
token = "$token"

# This sets the owner of the bot
# This needs to be the owner's ID (a 17-18 digit number)
# https://github.com/jagrosh/MusicBot/wiki/Finding-Your-User-ID
owner = "$owner"

# This sets the prefix for the bot
# The prefix is used to control the commands
# If you use !!, the play command will be !!play
# If you do not set this, the prefix will be a mention of the bot (@Botname play)
prefix = "$prefix"

# If you set this, it modifies the default game of the bot
# Set this to NONE to have no game
# Set this to DEFAULT to use the default game
# You can make the game "Playing X", "Listening to X", or "Watching X"
# where X is the title. If you don't include an action, it will use the
# default of "Playing"
game = "$game"

# If you set this, it will modify the default status of bot
# Valid values: ONLINE IDLE DND INVISIBLE
status = "ONLINE"

# If you set this to true, the bot will list the title of the song it is currently playing in its
# "Playing" status. Note that this will ONLY work if the bot is playing music on ONE guild;
# if the bot is playing on multiple guilds, this will not work.
songinstatus = true

# If you set this, the bot will also use this prefix in addition to
# the one provided above
altprefix = "NONE"

# If you set these, it will change the various emojis
success = "🎶"
warning = "💡"
error = "🚫"
loading = "⌚"
searching = "🔎"

# If you set this, you change the word used to view the help.
# For example, if you set the prefix to !! and the help to cmds, you would type
# !!cmds to see the help text
help = "help"

# If you set this, the "nowplaying" command will show YouTube thumbnails
# Note: If you set this to true, the nowplaying boxes will NOT refresh
# This is because refreshing the boxes causes the image to be reloaded
# every time it refreshes.
npimages = false

# If you set this, the bot will not leave a voice channel after it finishes a queue.
# Keep in mind that being connected to a voice channel uses additional bandwidth,
# so this option is not recommended if bandwidth is a concern.
stayinchannel = false

# This sets the maximum amount of seconds any track loaded can be. If not set or set
# to any number less than or equal to zero, there is no maximum time length. This time
# restriction applies to songs loaded from any source.
maxtime = 0

# This sets the maximum number of pages of songs that can be loaded from a YouTube
# playlist. Each page can contain up to 100 tracks. Playing a playlist with more
# pages than the maximum will stop loading after the provided number of pages.
# For example, if the max was set to 15 and a playlist contained 1850 tracks,
# only the first 1500 tracks (15 pages) would be loaded. By default, this is
# set to 10 pages (1000 tracks).
maxytplaylistpages = 10

# This sets the ratio of users that must vote to skip the currently playing song.
# Guild owners can define their own skip ratios, but this will be used if a guild
# has not defined their own skip ratio.
skipratio = "$skipratio"

# This sets the amount of seconds the bot will stay alone on a voice channel until it
# automatically leaves the voice channel and clears the queue. If not set or set
# to any number less than or equal to zero, the bot won't leave when alone.
alonetimeuntilstop = "$alonetimeuntilstop"

# This sets an alternative folder to be used as the Playlists folder
# This can be a relative or absolute path
playlistsfolder = "Playlists"

# By default, the bot will DM the owner if the bot is running and a new version of the bot
# becomes available. Set this to false to disable this feature.
updatealerts = true

# Changing this changes the lyrics provider
# Currently available providers: "A-Z Lyrics", "Genius", "MusicMatch", "LyricsFreak"
# At the time of writing, I would recommend sticking with A-Z Lyrics or MusicMatch,
# as Genius tends to have a lot of non-song results and you might get something
# completely unrelated to what you want.
# If you are interested in contributing a provider, please see
# https://github.com/jagrosh/JLyrics
lyrics.default = "A-Z Lyrics"

# These settings allow you to configure custom aliases for all commands.
# Multiple aliases may be given, separated by commas.
#
# Example 1: Giving command "play" the alias "p":
# play = [ p ]
#
# Example 2: Giving command "search" the aliases "yts" and "find":
# search = [ yts, find ]
aliases {
  # General commands
  settings = [ "status" ]

  # Music commands
  lyrics = []
  nowplaying = [ "np", "current" ]
  play = [ "p" ]
  playlists = [ "pls" ]
  queue = [ "list" ]
  remove = [ "delete" ]
  scsearch = []
  search = [ "ytsearch" ]
  shuffle = [ "sh" ]
  skip = [ "skip" ]

  # Admin commands
  prefix = [ "setprefix" ]
  setdj = []
  setskip = [ "setskippercent", "skippercent", "setskipratio" ]
  settc = []
  setvc = []

  # DJ Commands
  forceremove = [ "forcedelete", "modremove", "moddelete", "modelete" ]
  forceskip = [ "modskip" ]
  movetrack = [ "move" ]
  pause = []
  playnext = []
  queuetype = []
  repeat = []
  skipto = [ "jumpto" ]
  stop = [ "leave" ]
  volume = [ "vol" ]
}

# This sets the logging verbosity.
# Available levels: off, error, warn, info, debug, trace, all
#
# It is recommended to leave this at info. Debug log levels might help with troubleshooting,
# but can contain sensitive data.
loglevel = "info"

# Transforms are used to modify specific play inputs and convert them to different kinds of inputs
# These are quite complicated to use, and have limited use-cases, but in theory allow for rough
# whitelists or blacklists, roundabout loading from some sources, and customization of how things are
# requested.
#
# These are NOT EASY to set up, so if you want to use these, you'll need to look through the code
# for how they work and what fields are needed. Also, it's possible this feature might get entirely
# removed in the future if I find a better way to do this.
transforms = {}

# If you set this to true, it will enable the eval command for the bot owner. This command
# allows the bot owner to run arbitrary code from the bot's account.
#
# WARNING:
# This command can be extremely dangerous. If you don't know what you're doing, you could
# cause horrific problems on your Discord server or on whatever computer this bot is running
# on. Never run this command unless you are completely positive what you are running.
#
# DO NOT ENABLE THIS IF YOU DON'T KNOW WHAT THIS DOES OR HOW TO USE IT
# IF SOMEONE ASKS YOU TO ENABLE THIS, THERE IS AN 11/10 CHANCE THEY ARE TRYING TO SCAM YOU
eval = false
evalengine = "Nashorn"
EOF

mkdir -p Playlists
echo -e "Configuration file \e[32mconfig.txt\e[0m has been created \e[32mSUCCESSFULLY\e[0m."
