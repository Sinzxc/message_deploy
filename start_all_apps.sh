#!/bin/bash
echo "Starting all VAN applications..."

# Проверяем, установлен ли screen
if ! command -v screen &> /dev/null; then
    echo "Error: screen is not installed. Install it with: sudo apt install screen"
    exit 1
fi

# Завершаем существующие сессии с именем "van_apps"
echo "Checking for existing sessions..."
screen -ls | grep van_apps | cut -d. -f1 | xargs -I{} screen -S {} -X quit 2>/dev/null

# Создаём новую сессию screen с именем "van_apps"
echo "Creating new session..."
screen -dmS van_apps

# Окно 0: Frontend
screen -S van_apps -X screen -t "Frontend" bash -c 'cd message_frontend && npm ci && npm run dev; exec bash'

# Окно 1: Backend
screen -S van_apps -X screen -t "Backend" bash -c 'cd message_backend && docker-compose up -d && npm i --no-optional && npm run start; exec bash'

# Окно 2: FileStorage
screen -S van_apps -X screen -t "FileStorage" bash -c 'cd FileStorageReborn && npm run start; exec bash'

echo "All applications have been started in screen session 'van_apps'!"
echo "To attach to the session, run: screen -r van_apps"
echo "To switch between windows: Ctrl+A followed by number (0, 1, 2)"
echo "To detach from screen: Ctrl+A followed by D"
echo "To terminate the session, run: screen -S van_apps -X quit"
read -p "Press Enter to continue..."