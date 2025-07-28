**Author: Lev Rozanov**

# HKU Docker Environment

This Docker image sets up a shared dev environment for the HKU competition projects, cloning repos via HTTPS with a GitHub token.

## What is this?

- Clones both `hku-data` and `hku-comp-fix` repos automatically on build using a GitHub token  
- Python 3.11 with all required dependencies pre-installed  in a uv venv
- Everyone works in the same environment  
- Git LFS support for large data files  

## What's inside

- Python 3.11 and essential packages  
- Git and Git LFS configured  
- Pre-installed: pandas, numpy, scikit-learn, pyarrow, psutil, jupyter  
- Tools: vim, nano, curl, wget, tree, htop  
- Both repos cloned into `/workspace-hku/`  

## Quick Start

**Build the image (using buildkit and secret token):**  
```bash
Windows PowerShell:
$env:DOCKER_BUILDKIT=1; docker build --secret id=GITHUB_TOKEN,src=./token.txt -t hku-docker-env  .

Linux:
DOCKER_BUILDKIT=1 docker build --secret id=GITHUB_TOKEN,src=./token.txt -t hku-docker-env  .

#Run the container:
docker run -it --rm hku-docker-env
