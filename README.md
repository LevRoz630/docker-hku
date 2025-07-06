# HKU Docker Environment

This Docker image sets up a shared dev environment for the HKU competition projects, with built-in git access.

## What is this?

- Clones both `hku-data` and `hku-comp-fix` repos automatically when you build the image
- Lets you pull/push code without setting up your own git credentials
- Python is ready to go with all the dependencies you need
- Everyone works in the same environment
- **NEW**: Improved Git LFS handling with retry logic for large data files

## What's inside

- Python 3.11 (with all the packages you need)
- Git (SSH access is set up)
- Git LFS with retry logic for reliable large file downloads
- Pre-installed: pandas, numpy, scikit-learn, pyarrow, psutil, jupyter, git-lfs
- Tools: vim, nano, curl, wget, tree, htop
- Both repos are cloned into `/workspace-drw-comp/`

## Quick Start

**Build the image:**
```bash
docker build -t hku-docker-env .
```

**Run the container:**
```bash
docker run -it --rm hku-docker-env
```

**Using docker-compose (recommended):**
```bash
docker-compose up -d
docker-compose exec hku-env bash
```

## Usage

Once inside the container, you'll find:
- `hku-comp-fix/` - Main competition repository (with full git control)
- `hku-data/` - Data repository (with full git control and LFS files)
- All Python packages pre-installed
- Git configured and ready to use

**All development happens directly in the git repositories:**

```bash
# Navigate to the competition repo
cd hku-comp-fix

# Pull latest changes
git pull origin main

# Make your changes
# ... your development work ...

# Commit and push
git add .
git commit -m "Your changes"
git push origin main
```

**For data work:**
```bash
cd hku-data
git pull origin main
# Work with data files (LFS files are automatically handled)
git add .
git commit -m "Data updates"
git push origin main
```

## Development Workflow

1. **Start the container:**
   ```bash
   docker run -it --rm hku-docker-env
   ```

2. **Navigate to your project:**
   ```bash
   cd hku-comp-fix
   ```

3. **Pull latest changes:**
   ```bash
   git pull origin main
   ```

4. **Make your changes and commit:**
   ```bash
   # Your development work here
   git add .
   git commit -m "Your commit message"
   git push origin main
   ```

## Troubleshooting

**Git LFS Issues:**
The Dockerfile now includes retry logic for Git LFS downloads. If you still encounter issues:
- Check your internet connection
- Verify SSH key permissions
- Try rebuilding the image: `docker build --no-cache -t hku-docker-env .`

**SSH Key Issues:**
If you encounter SSH authentication problems, ensure the SSH keys are properly set up in the repository.

**Permission Issues:**
The container runs as root, so file permissions should not be an issue.

**Git Configuration:**
The container is pre-configured with git user.name and user.email. You can modify these in the Dockerfile if needed.

**Large File Downloads:**
If Git LFS files fail to download during build, the retry logic will attempt the download up to 3 times with increasing delays.