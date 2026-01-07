# Ruby Base Image

Optimized Ruby Docker image with jemalloc memory allocator and common dependencies pre-installed.

## What's Included

- Ruby 4.0.0 (slim-trixie)
- jemalloc (enabled via LD_PRELOAD)
- Bun 1.3.5
- System packages from [Aptfile](Aptfile)

## Usage

Pull from GitHub Container Registry:

```dockerfile
FROM ghcr.io/vzb-io/ruby:latest
```

### Version Pinning

```dockerfile
# Exact version (recommended for production)
FROM ghcr.io/vzb-io/ruby:1.2.3

# Minor version (receives patch updates)
FROM ghcr.io/vzb-io/ruby:1.2

# Major version (receives minor and patch updates)
FROM ghcr.io/vzb-io/ruby:1

# Latest from main branch
FROM ghcr.io/vzb-io/ruby:latest
```

### Authenticating (Private Registry)

This image is hosted on a private registry. You must authenticate before pulling.

**Local development:**

```bash
# Create a Personal Access Token (classic) with read:packages scope
# https://github.com/settings/tokens

echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

**GitHub Actions:**

```yaml
- name: Log in to Container Registry
  uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
```

> **Note:** For cross-repo access, the package visibility must allow it. Go to the package settings and grant access to specific repositories under "Manage Actions access".

## Releasing a New Version

1. Make your changes to `Dockerfile` or `Aptfile`
2. Commit and push to `main`
3. Tag with semver and push:

```bash
git tag v1.0.0
git push origin v1.0.0
```

The GitHub Action will automatically build and publish:
- Multi-arch images (amd64 + arm64)
- Tags: `1.0.0`, `1.0`, `1`, and `latest`

## Verifying jemalloc

Inside a running container:

```bash
MALLOC_CONF=stats_print:true ruby -e "exit"
```

If jemalloc is active, you'll see memory allocation stats printed.

