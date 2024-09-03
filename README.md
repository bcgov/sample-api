# Sample API

This is a sample api. 

## Technology Used
- [x] [Python](https://www.python.org)
- [x] [FastAPI](https://fastapi.tiangolo.com)
- [x] [SQLAlchemy](https://www.sqlalchemy.org)
- [x] [Poetry](https://python-poetry.org)
- [x] [Flyway](https://www.red-gate.com/products/flyway/community/)
- [x] [Docker Compose](https://docs.docker.com/compose/install/)

## Setup

### Environment variables

The following environment variables are expected:

- ORIGINS: comma separated list of [allowed origins](https://fastapi.tiangolo.com/tutorial/cors/).
- POSTGRES_SERVER: URL of db server
- POSTGRES_USER
- POSTGRES_PASSWORD
- POSTGRES_DB: postgres DB name

### DB adaptor

The [psycopg2](https://www.psycopg.org) adaptor is used. Note the [installation requirements](https://www.psycopg.org/docs/install.html) for the psycopg2 package. The [sample-api dependencies](pyproject.toml) use the psycopg2 package and not the psycopg2-binary package.
    
## Local Development

### Running locally

- Run `docker compose up` command from root directory to start the entire stack. The following will be started: 
  - Postgres server 
  - Flyway - it setups the postgres tables and inserts some dev data.
  - sample-api server
- Environment variables are defined in the docker-compose.yml
- The `sample-api` folder is volume mounted, so any changes to the code will be reflected in the container 
- The API's documentation is available at [http://localhost:3003/docs](http://localhost:3003/docs).


### Unit tests

- Run `docker compose --profile test up` command to run the unit tests from the root directory. This will run the above services as well as the unit tests.
- The folder is volume mounted, so any changes to the code will be reflected in the container and run the unit tests again.


## The API

This is a simple API. It is not production ready. 

The API is based on the table schema defined in [V1.0.0__init.sql](db/migrations/V1.0.0__init.sql) file. Note the foreign key constraint if you want to try the endpoints out.

The [http://localhost:3003/docs](http://localhost:3003/docs) page lists the available endpoints.

## Running the Dockerfile
This Dockerfile builds the Docker image of the sample-api application. It includes the following steps
- Base Image :
	FROM python:3.12-slim
- Install system dependencies for postgreSql : updates the packges lists and install new packages, also install postgreSQl libraries development files, cleansup the packages list to reduce image size.
	RUN apt-get update && \
        apt-get install -y \
        gcc \
        libpq-dev \
        && rm -rf /var/lib/apt/lists/*
- Set the working directory in the container:
    WORKDIR /app
- Install Poetry
	RUN pip install poetry
- Copy the file poetry.lock, pyproject.toml to working directory of the  container
	COPY pyproject.toml poetry.lock* ./
- Set Environment Variables to the Path	for poetry
    ENV PATH="/root/.local/bin:$PATH"	
- Install the dependencies
	RUN poetry install --no-root --no-dev
- Copy rest of the code to working directory
	COPY . .
- Make the start script executable
	RUN chmod +x /app/start-local.sh	
- Expose the ports where the app runs on.
	EXPOSE 3000
- Define Environment variables
	ENV PYTHONUNBUFFERED=1
- Run the  start script
	CMD ["./start-local.sh"]

## Build the docker image
- docker build -t sample-api .

## Run the docker image 
- docker run -d -p 3000:3000 --name my-sample-api sample-api

## Instructions on how to pull and run the image
- docker pull ghcr.io/narmada84/sample-api/sample-api:latest
## Run the docker container using the pulled image
- docker run --rm -p 3000:3000 ghcr.io/narmada84/sample-api/sample-api:latest
## Access application
- once the docker container starts running access the application using below url 
	http://localhost:3000 and the docs can be found this url : http://localhost:3000/docs

## Github workflow for running unit tests and publish the docker image to github container registry
- unit tests are executed as part of github workflows, here are the steps how to run the workflow
   - workflow is triggered automatically on `push` and `pull_request`.
   - push a commit to main branch or create a pull request to main branch, this automatically triggers the workflow.
   - go to the actions tab on the github repo, where all the workflows runs can be seen.
   - click on the most recent workflow and all the details of the each step can be viewed.
   - Refer to the WORKFLOW_SUCCESS.md file for the screenshot of the successful workflow.
   - Link the most recent successfull workflow- https://github.com/narmada84/sample-api/actions/runs/10672143278/job/29579095648

## How to trigger and run the work flow
-  workflows can be triggered automatically on every push and pull request to the branch specified on the Build-Test Routine .yml file.
- It can also be triggered manually by navigating to actions tab on the repo and click on Build-Test Routine workflow and click on Re run all jobs.
