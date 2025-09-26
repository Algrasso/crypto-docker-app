# 1️⃣ Base image with OpenJDK 17 and slim Python
FROM openjdk:17-jdk-slim

# 2️⃣ Set working directory inside container
WORKDIR /app

# 3️⃣ Install Python 3 and pip
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 4️⃣ Optional: Set JAVA_HOME for Spark
ENV JAVA_HOME=/usr/local/openjdk-17
ENV PATH=$JAVA_HOME/bin:$PATH

# 5️⃣ Copy Python requirements and install
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# 6️⃣ Copy Python scripts into the container
COPY app/ /app/

# 7️⃣ Expose Spark UI port if needed
EXPOSE 4040

# 8️⃣ Default command to run your main app
CMD ["python3", "main.py"]
