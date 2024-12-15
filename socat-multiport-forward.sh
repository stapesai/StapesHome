#!/bin/bash

# Array of port numbers to forward
PORTS=(8000 8001 8002)
DESTINATION_IP="192.168.0.253"

# Cleanup function to kill background processes
cleanup() {
    echo "Stopping all port forwards..."
    pkill -f "socat.*TCP-LISTEN"
    exit 0
}

# Set trap for cleanup on script termination
trap cleanup SIGINT SIGTERM

# Start socat for each port
for PORT in "${PORTS[@]}"; do
    echo "Starting forward for port $PORT..."
    socat TCP-LISTEN:$PORT,fork TCP:$DESTINATION_IP:$PORT &
    
    # Check if socat started successfully
    if [ $? -eq 0 ]; then
        echo "Successfully started forward on port $PORT"
    else
        echo "Failed to start forward on port $PORT"
    fi
done

echo "All port forwards are running. Press Ctrl+C to stop."

# Wait indefinitely
wait
