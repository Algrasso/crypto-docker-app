# ──────────────────────────────
# Stage 1: Builder
# ──────────────────────────────
FROM python:3.12-slim AS builder

# Set working directory
WORKDIR /build

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libffi-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install PyInstaller
RUN pip install --no-cache-dir pyinstaller

# Copy app source code and requirements
COPY app/ ./app/
COPY requirements.txt .

# Install Python dependencies needed for build
RUN pip install --no-cache-dir -r requirements.txt

# Build the Linux binary for main.py
# PyInstaller automatically bundles imports from other app files
RUN pyinstaller --onefile --name main app/main.py

# ──────────────────────────────
# Stage 2: Runtime
# ──────────────────────────────
FROM debian:bookworm-slim

# Set working directory
WORKDIR /app

# Install minimal runtime dependencies for Linux binary
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    && rm -rf /var/lib/apt/lists/*

# Copy only the compiled binary from the builder stage
COPY --from=builder /build/dist/main ./main

# Make binary executable
RUN chmod +x ./main

# Expose ports if your app has a UI
EXPOSE 4040

# Run the binary
CMD ["./main"]
