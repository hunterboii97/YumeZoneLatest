FROM python:3.11-slim

WORKDIR /app

# Install system dependencies for better performance
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install production server + performance libs
RUN pip install --no-cache-dir \
    gunicorn[gevent] \
    gevent \
    greenlet \
    cachetools \
    redis

COPY . .

EXPOSE 5000

# 17 workers (2×8 vCPU +1), 2000 connections each, gevent async
CMD ["gunicorn", "run:app", \
     "--worker-class", "gevent", \
     "--workers", "17", \
     "--worker-connections", "2000", \
     "--bind", "0.0.0.0:5000", \
     "--timeout", "120", \
     "--keep-alive", "10", \
     "--max-requests", "1000", \
     "--max-requests-jitter", "100", \
     "--log-level", "warning", \
     "--access-logfile", "-"]
