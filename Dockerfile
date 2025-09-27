# Stage 1: Builder with Obfuscation
FROM python:3.12-slim AS builder

WORKDIR /build

RUN apt-get update && apt-get install -y \
    build-essential \
    openjdk-17-jre-headless \
    && rm -rf /var/lib/apt/lists/*

# Copy ALL necessary files
COPY app/ ./app/
COPY models/ ./models/  # ← ADD THIS
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

RUN pyarmor gen --recursive --output /build/obfuscated \
    --package-runtime 0 \
    --restrict-mode 1 \
    ./app/

# Stage 2: Runtime (MODIFIED)
FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    openjdk-17-jre-headless \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create directory structure
RUN mkdir -p data_stream historical_data predictions checkpoints models

# Copy only obfuscated code (NO models)
COPY --from=builder /build/obfuscated ./app
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

ENV PYSPARK_PYTHON=python3
ENV PYTHONPATH=/app/app:${PYTHONPATH}

EXPOSE 4040

# Use volume mount or download at runtime
CMD ["python", "-c", "from app.main import main; main()"]