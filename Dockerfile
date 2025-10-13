# Use official Python base image (Debian-based)
FROM python:3.10

# Set working directory
WORKDIR /app

# Copy all project files to /app
COPY . /app

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libffi-dev \
    ffmpeg \
    aria2 \
    make \
    g++ \
    cmake \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Build and install Bento4 (for mp4decrypt)
RUN wget -q https://github.com/axiomatic-systems/Bento4/archive/v1.6.0-639.zip && \
    unzip v1.6.0-639.zip && \
    cd Bento4-1.6.0-639 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    cp mp4decrypt /usr/local/bin/ && \
    cd ../.. && \
    rm -rf Bento4-1.6.0-639 v1.6.0-639.zip

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir -U yt-dlp

# Expose port (Render requirement, even if not used)
EXPOSE 10000

# Start the Telegram bot directly (no gunicorn needed)
CMD ["python3", "main.py"]
