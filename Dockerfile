FROM python:3.12-slim

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    openjdk-17-jre-headless \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Copy application files (from your local private repo during build)
COPY app/ ./app/
COPY models/ ./models/
COPY requirements.txt .
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create directories for data
RUN mkdir -p data_stream historical_data predictions checkpoints

# Obfuscate Python files to hide source code
RUN pip install pyarmor
RUN pyarmor gen --recursive --output /app/obfuscated \
    --package-runtime 0 \
    --restrict-mode 1 \
    ./app/

# Replace original source with obfuscated code
RUN rm -rf /app/app && mv /app/obfuscated /app/app

ENV PYSPARK_PYTHON=python3
ENV PYTHONPATH=/app/app:${PYTHONPATH}

EXPOSE 4040

# Start all three processes
CMD ["/usr/bin/supervisord"]