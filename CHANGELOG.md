# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-03-16


### Added

- Server initialization workflow (`.github/workflows/server-init.yml`) and the accompanying
  `scripts/init-server.sh`. This one-time GitHub Actions workflow prepares a fresh server by
  creating persistent Docker volume directories, uploading the assembled `.env.prod` file and
  optionally starting the shared Traefik reverse proxy.
- `scripts/reset-db.sh` — helper script for resetting the local development database (local use only).

### Changed

- The automated deployment workflow (`.github/workflows/deploy.yml`) was simplified: the
  runtime environment file `.env.prod` is now assembled from the encrypted `PROD_ENV` secret and
  GitHub environment variables, which removes the need to manually manage environment files on
  the server. This makes environment configuration auditable and controllable from GitHub.
- The deploy workflow and related scripts were adjusted so there is no longer a requirement to
  keep a live interactive connection to the server just to update environment variables — the
  `PROD_ENV` secret contains the sensitive values and GitHub variables supply non-sensitive
  overrides.
- Removed legacy Strapi-related logic from the deployment scripts (cleanup of leftover
  Strapi handling that remained after the migration to Payload CMS).

### Removed

- Removed unused/stale GitHub environment configurations for staging and prod that were not in
  active use.
- Clarified proxy control: starting or skipping the proxy (Traefik) during server
  initialization is controllable via the `WITH_PROXY` setting in `.env.prod` (managed as a
  GitHub environment variable). This makes it explicit whether this repository should run the
  shared proxy container or rely on another project already providing it.


## [1.0.1] - 2025-12-29

### Changed

- Updated Docker Compose configuration to add persistent volume for Payload CMS data storage
- Updated Docker Compose configuration healthcheck for Payload CMS service

## [1.0.0] - 2025-12-29

### Changed

- **BREAKING**: Replaced Strapi CMS with Payload CMS as the primary backend
- Payload CMS now serves the API at `api.kraeuterakademie.it` (previously Strapi)
- Updated all Docker Compose configurations to remove Strapi services
- Updated environment variables to use Payload instead of Strapi
- Updated deploy script to remove Strapi deployment option
- Archived Strapi repository - it is no longer actively maintained

### Removed

- Strapi CMS service from infrastructure
- Strapi-related environment variables and configuration
- Strapi uploads volume

## [0.3.0] - 2025-11-12

### Added

- add GitHubActions workflow for deploying the application to the Hetzner Cloud server using SSH and Docker Compose
- add `deploy.sh` script for deploying the application to the Hetzner Cloud server

### Changed

- mention subprojects in README.md
- update base image in Dockerfile from `typescript-node:22` to `typescript-node:24`
- changed Strapi environment variable names in Docker Compose file

## [0.2.0] - 2025-11-11

- Removed git submodules for Nuxt and Strapi to simplify repository management and improve developer experience.
- **Terraform**:
	- Added a new 10GB volume to separate persistent data from the server. The volume is mounted for PostgreSQL data and Strapi uploads, improving data management and reliability.
	- Updated server type from `cx22` to `cx23` for better performance.
- **Devcontainer**:
	- Switched from mounting SSH files to mounting the SSH agent for improved security.
	- Automated cloning of Nuxt and Strapi repositories into the `apps` folder via the `setup.sh` script.
	- Added recommended VSCode extensions for development:
		- `hashicorp.terraform` (Terraform support)
		- `ms-azuretools.vscode-docker` (Docker integration)
		- `nuxtr.nuxt-vscode-extentions` (Nuxt support)
		- `dbaeumer.vscode-eslint` (ESLint)
		- `streetsidesoftware.code-spell-checker` (Spell checking)
		- `EditorConfig.EditorConfig` (EditorConfig)
		- `vitest.explorer` (Vitest integration)
		- `ms-playwright.playwright` (Playwright testing)
		- `GitHub.copilot` (GitHub Copilot)
		- `GitHub.copilot-chat` (GitHub Copilot Chat)
		- `mskelton.npm-outdated` (NPM outdated packages)
		- `mhutchie.git-graph` (Git graph visualization)
	- Improved the devcontainer Dockerfile and added GitHub CLI installation for easier repository management.
	- Configured terminal SSH connection to the Hetzner Cloud server in the workspace settings for streamlined access.
	- Named workspace folders and added a dedicated Terraform folder for better organization.
- Upgraded PostgreSQL from 17.6 to 18
- Upgraded Traefik from 2.10 to 3.6
- Moved the Docker Compose file from the root directory to `infrastructure/` for better structure.
- Refactored Docker Compose configuration, splitting into `compose.prod.yml` and `compose.staging.yml` for environment-specific setups.
- Secured PostgreSQL by not exposing its port externally.
- Switched to using Docker images for Nuxt and Strapi in production, enabling faster and more reliable deployments compared to direct code usage.
- Added `setup.sh` and `up_env.sh` scripts to streamline production setup and environment management.


## [0.1.0] - 2025-08-30

- Terraform configuration for infrastructure-as-code.
- Git submodules for the Nuxt (frontend) and Strapi (CMS) servers.
- Development container (devcontainer) for a reproducible development environment.
- VS Code workspace configuration.
- Project README.md.
- compose.yml for the production server.