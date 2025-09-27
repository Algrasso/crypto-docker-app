# 🚀 Crypto Streaming App

A real-time **Spark Structured Streaming** application that tracks live cryptocurrency prices, calculates technical indicators, and generates ML-powered predictions in 5-minute batches.

## 📊 Features

- **Real-time Data Ingestion**: Fetches live prices from CoinGecko API every 30 seconds
- **Spark Streaming Processing**: Uses PySpark for distributed, scalable data processing
- **5-minute Window Aggregations**: Calculates rolling metrics and technical indicators
- **Machine Learning Predictions**: LightGBM model scoring with custom threshold
- **Production-ready Architecture**: Multi-process container with supervised execution

## 🛠️ Technology Stack

- **Python 3.12**
- **PySpark 3.5.0** - Distributed processing engine
- **LightGBM 4.6.0** - Machine learning model scoring
- **CoinGecko API** - Cryptocurrency data source
- **Docker** - Containerization and deployment

## 🏃‍♂️ Quick Start

```bash
# Pull the Docker image
docker pull algrasso/crypto-app:latest

# Run the application
docker run -it --rm algrasso/crypto-app:latest
```

## ⏹️ Stopping the Application
- Press Ctrl+C in the terminal where the application is running. The container will automatically clean up thanks to the --rm flag.

## 🔄 Restarting
After a normal stop, simply run the command again:

bash
docker run -it --rm algrasso/crypto-app:latest
🛠️ Troubleshooting
Force Restart
If the application crashes or hangs:

```bash
# Stop all running containers
docker stop $(docker ps -q) 2>/dev/null

# Remove any stopped containers
docker rm $(docker ps -aq) 2>/dev/null 2>/dev/null

# Clean local temporary directories
rm -rf data_stream/ historical_data/ predictions/ checkpoints/ 2>/dev/null || true

# Restart the application
docker run -it --rm algrasso/crypto-app:latest
Check Application Status
bash
# See if any containers are running
docker ps

# View recent containers
docker ps -a
```
## 📈 What to Expect
When the application starts successfully, you should see:

Historical data collection initialization

Real-time price streaming every 30 seconds

5-minute batch processing with predictions

Live updates in the terminal

## 💡 Notes
The application automatically manages its own data storage

Source code and ML models are proprietary and included in the Docker image

Use Ctrl+C for graceful shutdown

The Spark UI is available at http://localhost:4040 when running

## ❓ Need Help?
If you encounter persistent issues:

Ensure Docker is running correctly on your system

Check that you have internet connectivity for data streaming

Try the force restart procedure above

Verify you're using the latest image: docker pull algrasso/crypto-app:latest
