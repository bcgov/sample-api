
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
COPY . .
EXPOSE 8000
ENV PYTHONUNBUFFERED=1
CMD ["poetry", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

