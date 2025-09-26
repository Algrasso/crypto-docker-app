# 1️⃣ Base image with Python
FROM python:3.11-slim

# 2️⃣ Set working directory inside container
WORKDIR /app

# 3️⃣ Install system dependencies for PySpark
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 4️⃣ Set JAVA_HOME for PySpark
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# 5️⃣ Copy Python requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 6️⃣ Copy Python scripts into the container
COPY app/ /app/

# 7️⃣ Expose ports if needed (optional Spark UI)
EXPOSE 4040

# 8️⃣ Default command: run your main app
CMD ["python", "main.py"]
