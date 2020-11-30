# ---- Base python ----
FROM tiangolo/meinheld-gunicorn-flask:python3.7 AS base
RUN apt-get update &&\
 apt-get install -y cron &&\
 apt-get clean all
# Create app directory
WORKDIR "/usr/src/app"

# ---- Dependencies ----
FROM base AS dependencies
COPY ./requirements.txt ./
# install app dependencies

# ---- Copy Files/Build ----
FROM dependencies AS build
WORKDIR "/usr/src/app"
COPY . /usr/src/app
# Build / Compile if required

# --- Release with Alpine ----
FROM tiangolo/meinheld-gunicorn:python3.7-alpine3.8 AS release
# Create app directory
WORKDIR "/usr/src/app"
COPY --from=dependencies /usr/src/app/requirements.txt ./
COPY --from=dependencies /root/.cache /root/.cache
# Install app dependencies
RUN apk --update add python py-pip openssl ca-certificates py-openssl curl&& \
 apk --update add --virtual build-dependencies libffi-dev openssl-dev python-dev py-pip build-base && \
 pip install -r requirements.txt &&\
 apk del build-dependencies
HEALTHCHECK --interval=60s --timeout=5s \
 CMD curl -fs http://localhost:5010/healthyCheck || exit 1

COPY --from=build /usr/src/app/ ./
ENTRYPOINT ["sh", "/usr/src/app/entrypoint.sh"]
