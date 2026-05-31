FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Gunicorn (production WSGI server — much faster than Flask's dev server)
RUN pip install --no-cache-dir gunicorn[gevent]

COPY . .

EXPOSE 5000

# Use gunicorn with gevent workers for async Flask — maximizes your VPS resources
CMD ["gunicorn", "run:app", \
     "--worker-class", "gevent", \
     "--workers", "4", \
     "--worker-connections", "1000", \
     "--bind", "0.0.0.0:5000", \
     "--timeout", "120", \
     "--keep-alive", "5", \
     "--log-level", "info"]
