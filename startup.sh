#!/bin/bash
echo "🚀 Starting Crypto App in Sequence..."

echo "1. Running historical collector..."
python app/historical_collector.py

echo "2. Waiting for historical data to be ready..."
sleep 5  # Wait a few seconds for files to be written

echo "3. Starting real-time data in background..."
python app/crypto_data.py &

echo "4. Starting Spark processor (main app)..."
python app/main.py