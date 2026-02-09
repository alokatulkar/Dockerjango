# =========================
# Stage 1: Builder
# =========================
FROM python:3.11-slim AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (layer caching)
COPY requirements.txt .

# Create virtual environment
RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install gunicorn

# Copy project code
COPY . .

# =========================
# Stage 2: Distroless Runtime
# =========================
FROM gcr.io/distroless/python3-debian12

WORKDIR /app

# Copy virtual environment
COPY --from=builder /venv /venv

# Copy application code
COPY --from=builder /app /app

# Set environment variables
ENV PATH="/venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=employee_pro.settings

# Expose Django port
EXPOSE 8000

# Run Django using Gunicorn
CMD ["gunicorn", "employee_pro.wsgi:application", "--bind", "0.0.0.0:8000"]
