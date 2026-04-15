FROM mcr.microsoft.com/mssql/server:2022-latest

USER root

RUN apt-get update \
    && apt-get install -y curl gnupg ca-certificates apt-transport-https \
    && mkdir -p /etc/apt/keyrings \
    && curl https://packages.microsoft.com/keys/microsoft.asc \
        | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/22.04/prod jammy main" \
        > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y mssql-tools18 unixodbc-dev

ENV PATH="$PATH:/opt/mssql-tools18/bin"

USER mssql