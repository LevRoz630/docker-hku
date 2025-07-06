FROM python:3.11-slim

WORKDIR /workspace-drw-comp

# Install git, git-lfs, and ssh with better error handling
RUN apt-get update && apt-get install -y \
    git \
    git-lfs \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Initialize git-lfs with verification
RUN git lfs install && \
    git lfs version && \
    echo "Git LFS installed successfully"

# Copy SSH key into the image
COPY docker-hku-ssh /root/.ssh/id_ed25519
COPY docker-hku-ssh.pub /root/.ssh/id_ed25519.pub

# Set permissions
RUN chmod 600 /root/.ssh/id_ed25519 && \
    chmod 644 /root/.ssh/id_ed25519.pub

# Add GitHub to known_hosts to avoid authenticity prompt
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# (Optional) Set git config (name/email)
RUN git config --global user.name "LevRoz630" && \
    git config --global user.email "l.rozanov@outlook.com"

# Configure Git LFS to use SSH BEFORE cloning
RUN git config --global lfs.url "git@github.com:LevRoz630/hku-data.git" && \
    git config --global lfs.transfer.mode basic

# Clone the repositories with LFS disabled initially
RUN git clone git@github.com:LevRoz630/hku-comp-fix.git /workspace-drw-comp/hku-comp-fix && \
    GIT_LFS_SKIP_SMUDGE=1 git clone git@github.com:LevRoz630/hku-data.git /workspace-drw-comp/hku-data

# Pull LFS files separately with retry logic and verification
RUN cd /workspace-drw-comp/hku-data && \
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
RUN pip install -r /workspace-drw-comp/hku-comp-fix/requirements.txt

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