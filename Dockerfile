# Build Stage (Install dependencies)
FROM python:3.12-slim AS builder

WORKDIR /app

# Install curl, build dependencies, and psycopg2 dependencies
RUN apt-get update && apt-get install -y curl gcc python3-dev libpq-dev build-essential

# Copy project files
COPY pyproject.toml poetry.lock ./

# Install dependencies using Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="$PATH:/root/.local/bin"
RUN poetry install --no-root

# Install uvicorn and psycopg2-binary explicitly
RUN poetry run pip install uvicorn psycopg2-binary

# Verify installation of fastapi, uvicorn, and psycopg2-binary
RUN poetry run pip show fastapi
RUN poetry run pip show uvicorn
RUN poetry run pip show psycopg2-binary

# Final Stage (Run the application)
FROM python:3.12-slim

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y libpq-dev

# Copy the Poetry installation from the builder stage
COPY --from=builder /root/.local /root/.local

# Set the PATH environment variable
ENV PATH="/root/.local/bin:$PATH"

# Copy the application code
COPY . .

# Copy the start script
COPY start-local.sh /app/start-local.sh
RUN chmod +x /app/start-local.sh

WORKDIR /app/src

# Expose the port
EXPOSE 3000

# Set the virtual environment path
ENV VIRTUAL_ENV=/root/.cache/pypoetry/virtualenvs/sample-api-9TtSrW0h-py3.12
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Run the application using the start script
CMD ["/app/start-local.sh"]

