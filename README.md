# 🚀 Crypto Streaming App

A real-time **Spark Structured Streaming** application that tracks live cryptocurrency prices, calculates technical indicators, and generates ML-powered predictions in 5-minute batches.

For testing purposes a 45 minutes timeout was set and the crypto currency value is stellar XLM/USDT.

## BUSINESS PROBLEM
**To predict in real time if the price of the crypto currency will increase in the following 6 hours**

Data is collected and aggregated in 5 minutes batches and a predictive model was trained using daily hisotrical data and 1 minute candle real time streaming data.

Input features include, and are not limited to, the following signals:

```
price_volatility – Standard deviation of price in the 5 minutes window.
Use: Measures short-term risk; very predictive in momentum or trend models.

price_range – Difference between max and min price.
Use: Another volatility proxy; complementary to stddev.

volatility_ratio – price_volatility / avg_price.
Use: Normalized volatility; removes scale dependence, often useful for comparing different coins.
```

SMA / EMA indicators: 
Average deviation of price from SMA/EMA in the window (%)
```
- avg_vs_sma20
- avg_vs_sma50
- avg_vs_sma100
- avg_vs_ema20 
Use: Momentum indicators; positive values indicate price above moving average (uptrend), negative below (downtrend).
```

Difference between short-term and long-term SMAs
```
-avg_sma20_minus_sma50
-avg_sma50_minus_sma100 
Use: Trend-following features; larger positive values indicate strong bullish momentum.
```

Average of crossover signal (1 if SMA20>SMA50 else 0):
```
- sma_crossover_strength 
Use: Classic momentum signal; indicates short-term trend strength.
```

Bollinger Bands:
```
- avg_bb_width 
Use: Captures volatility expansion/contraction; narrow bands often precede strong moves.
- avg_bb_pct_position
Use: Shows relative price position; 1 means near upper band (overbought), 0 near lower band (oversold).

Number of times price crossed upper or lower band:
- count_above_upper_band
- count_below_lower_band
Use: Frequency of extreme movements; useful for breakout detection.
```

RSI
Average 14-period Relative Strength Index:
```
- avg_rsi_14
```

Time cyclic features & Other Intraday Features
```
- avg_hour_sin
- avg_hour_cos, avg_day_sin
- avg_day_cos 
- price_change_5m
- price_change_15m
Use: Captures intraday and weekly patterns; crucial if the target depends on time-of-day or day-of-week seasonality
```


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
# Sign in Docker Desktop & Pull the Docker image
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
