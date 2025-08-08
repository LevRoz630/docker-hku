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

# Pull LFS files separately with retry logic and verification
RUN cd /workspace-hku/hku-data && \
    echo "Verifying Git LFS installation..." && \
    git lfs version && \
    echo "Starting LFS pull with retry logic..." && \
    for i in 1 2 3; do \
        echo "Attempt $i to pull LFS files..." && \
        git lfs pull --include="*.parquet,*.csv" && \
        echo "LFS pull successful on attempt $i" && \
        break || \
        (echo "Attempt $i failed, waiting before retry..." && sleep 30); \
    done && \
    echo "Verifying LFS files were downloaded..." && \
    git lfs ls-files

# Install Python requirements
RUN cd /workspace-hku/hku-comp-fix && \
    git checkout develop && \
    pip install -r requirements.txt
# Install additional useful tools
RUN apt-get update && apt-get install -y \
    vim \
    nano \
    curl \
    wget \
    tree \
    htop \
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
