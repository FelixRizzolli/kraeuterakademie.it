# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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