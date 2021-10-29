FROM python:3.10-alpine3.13 AS base
WORKDIR /app

# Install app depedencies
FROM base AS build
RUN pip install pipenv
COPY Pipfile* ./
RUN pipenv install --deploy

FROM base
ENTRYPOINT ["python", "-m", "plex_trakt_sync"]

ENV \
	PTS_CONFIG_DIR=/app/config \
	PTS_CACHE_DIR=/app/config \
	PTS_LOG_DIR=/app/config \
	PTS_IN_DOCKER=1 \
	PYTHONUNBUFFERED=1

VOLUME /app/config

# Copy things together
COPY . .
COPY --from=build /root/.local/share/virtualenvs/app-*/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages

ARG APP_VERSION=$APP_VERSION
ENV APP_VERSION=$APP_VERSION