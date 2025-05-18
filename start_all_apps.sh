#!/bin/bash
echo "Starting all VAN applications..."

# Determine which terminal emulator is available
if command -v tilix &> /dev/null; then
    TERM_CMD="tilix -e"
elif command -v gnome-terminal &> /dev/null; then
    TERM_CMD="gnome-terminal --"
elif command -v xterm &> /dev/null; then
    TERM_CMD="xterm -e"
else
    echo "Using default terminal"
    TERM_CMD="bash -c"
fi

# Start Frontend
cd message_frontend
echo "Starting Frontend"
$TERM_CMD "bash -c 'cd \"$(pwd)\" && npm ci && npm run dev; exec bash'" &

# Start Backend
cd ../message_backend
echo "Starting Backend"
$TERM_CMD "bash -c 'cd \"$(pwd)\" && docker-compose up -d && npm i --no-optional && npm run start; exec bash'" &

# Start File Storage
cd ../FileStorageReborn
echo "Starting File Storage"
$TERM_CMD "bash -c 'cd \"$(pwd)\" && npm run start; exec bash'" &

# Return to root directory
cd ..
echo "All applications have been started!"
read -p "Press Enter to continue..."