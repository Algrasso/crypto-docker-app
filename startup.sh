#!/bin/bash
echo "🚀 Starting Crypto App (auto-stops after 60 minutes)..."
echo "💡 To run longer, use: timeout 120m docker run ..."

# Set 45-minute timeout for the entire application
timeout 45m bash -c "
    echo '1. Running historical collector...'
    python app/historical_collector.py

    echo '2. Starting real-time data in background...'
    python app/crypto_data.py &

    echo '3. Starting Spark processor...'
    python app/main.py
"

# This runs after timeout or normal completion
echo "⏰ Application stopped (timeout or completed)"