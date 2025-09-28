# ============================
# Stage 1: Build & Obfuscation
# ============================
FROM python:3.12-slim AS builder

WORKDIR /app

# Install build-time system deps
RUN apt-get update && apt-get install -y \
    openjdk-21-jre-headless \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Copy source and models into builder
COPY app/ ./app/
COPY models/ ./models/
COPY requirements.txt .

# Install Python dependencies needed for build (and pyarmor)
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install pyarmor

# Generate obfuscated files
RUN pyarmor gen --recursive --output /app/obfuscated ./app/

# Move/copy models to a protected area (you can replace with encryption step)
RUN mkdir -p /app/protected_models && \
    cp -r ./models/* /app/protected_models/ && \
    rm -rf ./models

# Clean up builder-state if needed (optional)
# RUN rm -rf /root/.cache/pip

# ============================
# Stage 2: Runtime Image
# ============================
FROM python:3.12-slim

WORKDIR /app

# Install runtime system deps including dos2unix
RUN apt-get update && apt-get install -y \
    openjdk-21-jre-headless \
    libgomp1 \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*

# Copy only the obfuscated app and protected models from builder stage
COPY --from=builder /app/obfuscated/ ./
COPY --from=builder /app/protected_models ./models/
COPY requirements.txt .
COPY startup.sh .

# Fix line endings and make executable
RUN dos2unix startup.sh && \
    chmod +x startup.sh

# Install runtime Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

ENV PYSPARK_PYTHON=python3
ENV PYTHONPATH=/app

EXPOSE 4040

CMD ["/bin/sh", "./startup.sh"]