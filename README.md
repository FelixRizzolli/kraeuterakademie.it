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

The production deployment process is fully automated with GitHub Actions.
Container images are built and pushed to the
[GitHub Container Registry (GHCR)](https://ghcr.io) by each sub-project's
own CI pipeline. **This repository only handles server provisioning and service
deployments — it never builds images.**

### Workflows

| Workflow | File | Trigger | Purpose |
|---|---|---|---|
| Server Initialization | [`server-init.yml`](.github/workflows/server-init.yml) | Manual | Clones this repo on a fresh server and runs the one-time setup |
| Automated Deployment  | [`deploy.yml`](.github/workflows/deploy.yml)           | Automatic / Manual | Deploys a specific service by pulling its latest image |

### Deployment Flow

```
Sub-project repository                    This repository
──────────────────────────────────────    ──────────────────────────────────────
1. Code is pushed to main
2. Build workflow runs:
   - Builds Docker image
   - Pushes to GHCR with tags:
       :latest
       :sha-<commit>
   - Dispatches repository_dispatch  ──▶  3. deploy.yml is triggered
        event-type: <service>-updated         - Assembles .env.prod from
        client-payload:                          GitHub secrets + variables
          version: sha-<commit>               - Uploads .env.prod to server
                                              - Runs deploy.sh <service> <version>
                                                - Pulls new image
                                                - Restarts container
                                                - Waits for health check ✓
                                                - Rolls back on failure  ✗
```

### Initial Server Setup

Run **once** on a fresh Hetzner server. Before triggering the workflow, make
sure all secrets and variables are configured (see [Requirements](#requirements)
below).

1. Go to **Actions → Server Initialization → Run workflow**.

The workflow will:

- Clone this repository to `/var/www/kraeuterakademie.it` on the server
- Upload `.env.prod` assembled from your GitHub secrets and variables
- Create all required Docker volume directories
- Start the shared Traefik reverse proxy *(only if `WITH_PROXY=true`)*

### Redeploying Manually

Go to **Actions → Automated Deployment → Run workflow**, pick the service,
and optionally enter a specific image tag. Leave the version field empty to
redeploy the `:latest` image.

---

### Requirements

> Configure the following in the **`production`** GitHub environment before
> running either workflow.
> Navigate to **Settings → Environments → production**.

#### Variables

Non-sensitive configuration values. Visible in workflow logs.

| Variable                   | Example                 | Description                                                                                                                                       |
|----------------------------|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| `WITH_PROXY`               | `true`                  | `true` if this project owns and starts the shared Traefik reverse proxy. Set to `false` if another project on the same server already manages it. |
| `ACME_EMAIL`               | `you@example.com`       | Email address for Let's Encrypt certificate expiry notifications.                                                                                 |
| `TRAEFIK_DASHBOARD_DOMAIN` | `traefik.example.com`   | Hostname for the Traefik dashboard.                                                                                                               |
| `PAYLOAD_DOMAIN`           | `api.example.com`       | Public hostname of the API service.                                                                                                               |
| `NUXT_DOMAIN`              | `example.com`           | Root hostname of the main website. The `www.` subdomain is added automatically.                                                                   |
| `STORYBOOK_DOMAIN`         | `storybook.example.com` | Hostname of the component documentation site.                                                                                                     |

#### Secrets

Sensitive values, encrypted by GitHub and never exposed in logs.

| Secret | Description |
|---|---|
| `PROD_HOST` | IP address or hostname of the production server. |
| `PROD_USER` | SSH login username on the production server. |
| `SSH_PRIVATE_KEY` | Private SSH key for authenticating with the server. The corresponding public key must be in `~/.ssh/authorized_keys` on the server. |
| `PROD_ENV` | Full content of the `.env.prod` file. Contains all remaining runtime secrets. See the template below. |

#### `PROD_ENV` Secret Template

Use [`infrastructure/.env`](infrastructure/.env) as your template — it
documents every required variable with example values and notes which ones
are managed separately as GitHub environment variables. Copy its contents
into the `PROD_ENV` secret and replace the `changeme` placeholders with
your real values.

> **Note:** The `*_DOMAIN` and `WITH_PROXY` variables are included in that
> file for documentation and standalone use. In CI they are **overridden**
> by the GitHub environment variables configured above, so you don't need
> to keep them in sync manually.
