# =========================
# Stage 1: Builder
# =========================
FROM python:3.11-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# Install dependencies into a custom directory
RUN pip install --upgrade pip \
    && pip install --no-cache-dir \
       --target=/python-deps \
       -r requirements.txt gunicorn

COPY . .

# =========================
# Stage 2: Distroless Runtime
# =========================
FROM gcr.io/distroless/python3-debian12

WORKDIR /app

# Copy dependencies and app
COPY --from=builder /python-deps /python-deps
COPY --from=builder /app /app

# Tell Python where to find dependencies
ENV PYTHONPATH=/python-deps
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=employee_pro.settings

EXPOSE 8000

# Distroless ENTRYPOINT = ["python"]
CMD ["-m", "gunicorn", "employee_pro.wsgi:application", "--bind", "0.0.0.0:8000"]
