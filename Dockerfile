
FROM python:3.12-slim
RUN apt-get update && \
    apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN pip install poetry
COPY pyproject.toml poetry.lock* ./
RUN poetry install --no-root --no-dev
#COPY start-local.sh /app/start-local.sh
COPY . .
RUN chmod +x /app/start-local.sh
EXPOSE 3000
ENV PYTHONUNBUFFERED=1
CMD ["./start-local.sh"]