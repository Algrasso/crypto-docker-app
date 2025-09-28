#!/bin/bash
echo "Starting Crypto App..."

# Historical collector runs first
echo "1. Running historical collector..."
python app/historical_collector.py

# Real-time data runs in background
echo "2. Starting real-time data in background..."
python app/crypto_data.py &

# Spark processor runs in foreground, PID 1 receives Ctrl+C
echo "3. Starting Spark processor..."
exec python -u app/main.py
