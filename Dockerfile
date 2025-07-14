# syntax=docker/dockerfile:1.4
FROM python:3.11-slim

WORKDIR /workspace-hku

RUN apt-get update && apt-get install -y \
    git \
    git-lfs \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN git lfs install

RUN pip install uv

RUN git config --global user.name "LevRoz630" && \
    git config --global user.email "l.rozanov@outlook.com"

RUN --mount=type=secret,id=GITHUB_TOKEN \
    GITHUB_TOKEN=$(cat /run/secrets/GITHUB_TOKEN) && \
    git clone https://$GITHUB_TOKEN@github.com/LevRoz630/hku-comp-fix.git /workspace-hku/hku-comp-fix && \
    GIT_LFS_SKIP_SMUDGE=1 git clone https://$GITHUB_TOKEN@github.com/LevRoz630/hku-data.git /workspace-hku/hku-data

RUN cd /workspace-hku/hku-data && git lfs pull --include="*.parquet,*.csv"

WORKDIR /workspace-hku/hku-comp-fix

RUN uv venv && uv pip install -r requirements.txt

CMD ["/bin/bash"]
