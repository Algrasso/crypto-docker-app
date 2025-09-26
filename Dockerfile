# 1️⃣ Base image with Python
FROM python:3.11-slim

# 2️⃣ Set working directory inside container
WORKDIR /app

# 3️⃣ Copy compiled main executable
COPY app/main /app/main

# 4️⃣ (Optional) Copy requirements if needed
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5️⃣ Default command: run the compiled binary
CMD ["./main"]
