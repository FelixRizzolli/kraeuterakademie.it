# Kräuterakademie.it

Is the project of the [Kräuterakademie](https://www.kraeuterakademie.it/) Webapplication.

## Terraform

This project uses Terraform to create a server in the Hetzner Cloud. At 
the current state, Docker and the project itself have to be installed 
and launched manually.

## Development Environment

The project uses a Visual Studio Code DevContainer for development. 
Make sure you have the DevContainer extension installed in your VS Code 
to get started.

## Connecting to the Cloud Server

To connect to the cloud server, use the following SSH command:

```bash
ssh -i ~/.ssh/id_ed25519 root@157.90.112.11
```

Make sure to replace `~/.ssh/id_ed25519` with the path to your SSH key if 
it's different.