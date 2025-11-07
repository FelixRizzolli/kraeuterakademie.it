FROM mcr.microsoft.com/devcontainers/typescript-node:22

RUN echo "INSTALL KRAEUTERAKADEMIE DEVCONTAINER IMAGE" && \
    # Configure Bash
    #  --> Disable Bash's bracket paste mode
    echo "bind 'set enable-bracket-paste off'" >> ~/.bashrc && \
    #  --> Allways show hidden files in ls and colorize the output
    echo "alias ls='ls -a --color=auto'" >> ~/.bashrc && \
    # Configure Git
    #  --> Ensure that git reats /workspace as a safe directory to avoid permission-related issues.
    git config --global --add safe.directory /workspace && \
    # Install common dependencies
    apt-get update && \
    (type -p curl >/dev/null || (apt-get install curl -y)) && \
    (type -p ca-certificates >/dev/null || (apt-get install ca-certificates -y)) && \
    (type -p gnupg >/dev/null || (apt-get install gnupg -y)) && \
    (type -p wget >/dev/null || (apt-get install wget -y)) && \
    (type -p unzip >/dev/null || (apt-get install unzip -y)) && \
    (type -p lsb-release >/dev/null || (apt-get install lsb-release -y)) && \
    # Install PostgreSQL
    install -d /usr/share/postgresql-common/pgdg && \
    curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc && \
    sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    apt-get update && apt-get install postgresql -y && \
    psql --version && \
    # Install Terraform
    curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update -y && apt-get install -y terraform && \
    terraform --version && \
    # Install GitHub CLI
    mkdir -p -m 755 /etc/apt/keyrings /etc/apt/sources.list.d && \
    wget -nv -O /etc/apt/keyrings/githubcli-archive-keyring.gpg https://cli.github.com/packages/githubcli-archive-keyring.gpg && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list && \
    apt-get update && apt-get install -y gh && \
    gh --version && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 3000
EXPOSE 1337