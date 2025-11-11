# 🌿 Kräuterakademie.it - Monorepo

kraeuterakademie.it is the homepage of Sigrid Thaler Rizolli and her company STR Kraeuterakademie. Initially, it serves as a presentation page for Sigrid and her courses. Planned future enhancements include:

- A management platform for Sigrid to simplify administrative tasks
- A platform for course participants to view upcoming modules, access helpful quizzes, and study materials
- Improved sharing of course information and content with participants

## 🏗️ Architecture

### Technical Project Overview

This project demonstrates a modern full-stack web architecture, optimized for maintainability, scalability, and developer experience:

- **Frontend: Nuxt 4**  
	Utilizes Nuxt 4 for its robust SSR/SSG capabilities, modular architecture, and seamless TypeScript integration. Nuxt's ecosystem accelerates development of performant, SEO-friendly web applications.

- **Backend: Strapi 5**  
	Strapi 5 provides a flexible, headless CMS with a powerful REST/GraphQL API, enabling rapid content modeling and secure user management. Its plugin system and TypeScript support streamline backend customization.

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
│   └── strapi/        # Headless CMS backend
├── infrastructure/    # Docker Compose for prod/staging
├── terraform/         # Infrastructure as Code
├── .devcontainer/     # Development environment
└── scripts/           # Automation scripts for production
```


