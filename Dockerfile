FROM sailvessel/ubuntu:latest

WORKDIR /app

# Copy all files
COPY . .

# Install system dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y --fix-missing \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    ffmpeg \
    aria2 \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install appxdl tool
RUN wget https://www.masterapi.tech/get/linux/pkg/download/appxdl && \
    mv appxdl /usr/local/bin/appxdl && \
    chmod +x /usr/local/bin/appxdl

# Setup Python virtual environment and install Python packages
RUN python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r master.txt

# Add virtual environment to PATH
ENV PATH="/usr/local/bin:/venv/bin:$PATH"

# Run gunicorn server
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:8000"]
