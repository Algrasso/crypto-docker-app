# 1️⃣ Base image with OpenJDK 17 (for Spark)
FROM openjdk:17-jdk-slim

# 2️⃣ Set working directory inside container
WORKDIR /app

# 3️⃣ Optional: Set JAVA_HOME for Spark
ENV JAVA_HOME=/usr/local/openjdk-17
ENV PATH=$JAVA_HOME/bin:$PATH

# 4️⃣ Copy the compiled executable into the container
COPY app/main.exe /app/main.exe

# 5️⃣ Expose Spark UI port if needed
EXPOSE 4040

# 6️⃣ Default command: run the compiled binary
CMD ["/app/main.exe"]
