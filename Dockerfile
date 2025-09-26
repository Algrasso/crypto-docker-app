# ─────────────────────────────
# Stage 1: Build the Linux binary
# ─────────────────────────────
FROM python:3.12-slim AS builder

# Set working directory
WORKDIR /app

# Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        build-essential \
        python3-dev \
        && rm -rf /var/lib/apt/lists/*

# Install PyInstaller
RUN pip install --no-cache-dir pyinstaller

# Copy all Python source files
COPY app/ ./

# Build the executable
RUN pyinstaller --onefile --name main main.py

# ─────────────────────────────
# Stage 2: Runtime
# ─────────────────────────────
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy only the compiled Linux binary from builder stage
COPY --from=builder /app/dist/main .

# Expose any ports if needed (optional)
EXPOSE 4040

# Run the binary
CMD ["./main"]

