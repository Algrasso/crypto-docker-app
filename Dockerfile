FROM python:3.12-slim

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    openjdk-21-jre-headless \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Copy application files (from your local private repo during build)
COPY app/ ./app/
COPY models/ ./models/
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create directories for data
RUN mkdir -p data_stream historical_data predictions checkpoints

# Obfuscate Python files to hide source code
#RUN pip install pyarmor
#RUN pyarmor gen --recursive --output /app/obfuscated ./app/
#RUN rm -rf /app/app && mv /app/obfuscated /app/app

COPY startup.sh .
RUN chmod +x startup.sh

ENV PYSPARK_PYTHON=python3
ENV PYTHONPATH=/app/app

EXPOSE 4040

# Start all three processes
CMD ["./startup.sh"]