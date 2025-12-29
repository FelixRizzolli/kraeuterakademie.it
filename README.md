# 🌿 Kräuterakademie.it - Monorepo

kraeuterakademie.it is the homepage of Sigrid Thaler Rizzolli and her company STR Kraeuterakademie. Initially, it serves as a presentation page for Sigrid and her courses. Planned future enhancements include:

- A management platform for Sigrid to simplify administrative tasks
- A platform for course participants to view upcoming modules, access helpful quizzes, and study materials
- Improved sharing of course information and content with participants

## 🏗️ Architecture

### Technical Project Overview

This project demonstrates a modern full-stack web architecture, optimized for maintainability, scalability, and developer experience:

- **Frontend: Nuxt 4**  
	Utilizes Nuxt 4 for its robust SSR/SSG capabilities, modular architecture, and seamless TypeScript integration. Nuxt's ecosystem accelerates development of performant, SEO-friendly web applications.

- **Backend: Payload CMS**  
	Payload CMS offers a modern, headless CMS solution with a focus on developer experience and extensibility. It supports REST and GraphQL APIs, custom admin interfaces, and robust access control.

- **Infrastructure: Terraform**  
	Infrastructure as Code is managed via Terraform, automating provisioning on Hetzner Cloud. This ensures reproducible, version-controlled deployments and simplifies scaling and maintenance.

- **Development Environment: VSCode Devcontainer**  
	The project leverages VSCode Devcontainer for consistent, containerized development environments. This eliminates "works on my machine" issues and speeds up onboarding and CI/CD integration.

- **Production: Docker Compose & Traefik**  
	Docker Compose orchestrates multi-service deployments, while Traefik acts as a dynamic reverse proxy and SSL manager. This combination enables zero-downtime deployments, secure routing, and simplified service discovery.

### Project Structure

```
kraeuterakademie.it/
├── apps/
│   ├── nuxt/          # Frontend application
│   └── payload/       # Headless CMS backend
├── infrastructure/    # Docker Compose for prod/staging
├── terraform/         # Infrastructure as Code
├── .devcontainer/     # Development environment
└── scripts/           # Automation scripts for production
```

#### Subprojects

 - [kraeuterakademie.it_nuxt](https://github.com/FelixRizzolli/kraeuterakademie.it_nuxt) — Nuxt frontend source
 - [kraeuterakademie.it_payload](https://github.com/FelixRizzolli/kraeuterakademie.it_payload) — Payload CMS backend source

#### Archived Subprojects

 - [kraeuterakademie.it_strapi](https://github.com/FelixRizzolli/kraeuterakademie.it_strapi) — Strapi backend (previously used as the CMS backend, now replaced by Payload CMS)


## 🛠️ Development

### Requirements

- VSCode
- Docker

### Environment Variables

- `GH_TOKEN` with access to `kraeuterakademie.it`, `kraeuterakademie.it_nuxt`, `kraeuterakademie.it_strapi`, and `kraeuterakademie.it_payload`
- `HCLOUD_API_TOKEN` with access to the Hetzner Cloud API

Both `GH_TOKEN` and `HCLOUD_API_TOKEN` are passed from your local environment to the devcontainer.

### Getting Started

The simplest way to develop in this project is to launch the VSCode devcontainer. It will install all required dependencies automatically.

To run the frontend or backend services:

- Open the Nuxt terminal and run:
	- `pnpm devcontainer` to start the Nuxt frontend
	- `pnpm storybook` to run Storybook
- Open the Payload terminal and run:
	- `pnpm devcontainer` to start the Payload CMS backend


## 🚀 Deployment

Releases are automated via GitHub Actions:

- When the package version of either the Payload, Strapi or Nuxt repository increases, a new tag and release are automatically created.
- Upon release creation, another GitHub Action builds and deploys a new container for that version to the GitHub Container Repository.


### Manual Update on Production

To update the monorepo in production, connect to the Hetzner Cloud Server using SSH. The connection profile is available in the workspace as `SSH kraeuterakademie production`.

Run the following commands:

```bash
cd /var/www/kraeuterakademie.it
git pull
```

### Other Helpful Commands

```bash
sudo chmod +x setup.sh
sudo chmod +x up_env.sh
./scripts/setup.sh        # Setup utility scripts
envup prod                # Start the production container
```

