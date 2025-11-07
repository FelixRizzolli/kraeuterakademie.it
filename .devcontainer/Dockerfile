FROM mcr.microsoft.com/devcontainers/typescript-node:22

RUN echo "INSTALL KRAEUTERAKADEMIE DEVCONTAINER IMAGE" && \
    # Disable Bash's bracket paste mode
    echo "bind 'set enable-bracket-paste off'" >> ~/.bashrc && \
    # Allways show hidden files in ls and colorize the output
    echo "alias ls='ls -a --color=auto'" >> ~/.bashrc && \
    # Ensure that git reats /workspace as a safe directory to avoid permission-related issues.
    git config --global --add safe.directory /workspace && \
    # Install PostgreSQL
    apt-get update && \
    apt-get install curl ca-certificates -y && \
    install -d /usr/share/postgresql-common/pgdg && \
    curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc && \
    sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    apt-get update && \
    apt-get install postgresql -y && \
    # Install Terraform
    apt-get update -y && apt-get install -y gnupg curl unzip lsb-release && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update -y && apt-get install -y terraform && \
    terraform -version && \
    # Install GitHub CLI
    (type -p wget >/dev/null || (apt update && apt install wget -y)) && \
    mkdir -p -m 755 /etc/apt/keyrings && \
	out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg && \
	cat $out | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
	chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
	mkdir -p -m 755 /etc/apt/sources.list.d && \
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
	apt update && apt install gh -y

EXPOSE 3000
EXPOSE 1337