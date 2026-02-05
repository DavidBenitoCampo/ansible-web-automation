# Ansible Automation Project: Scalable Web Server Deployment

> **Automation of secure, Nginx-based web infrastructure using Ansible, demonstrating Infrastructure as Code (IaC) principles.**

This project is a showcase of a production-ready Ansible workflow. It automates the provisioning, configuration, and security hardening of web servers. To demonstrate these capabilities without external cloud costs, I have included a **local lab environment** using Docker and Docker Compose that simulates a multi-node cluster.

---

## 🛠 Technology Stack

- **Configuration Management**: Ansible (Modular Roles, Jinja2 Templates, Variables)
- **Infrastructure**: Docker & Docker Compose (Simulating 3 Linux nodes)
- **Web Server**: Nginx (Custom configuration, SSL/TLS, Reverse Proxy)
- **Scripting**: Bash (Environment bootstrapping)

## 🚀 Key Features

### 1. Role-Based Architecture
The project follows ANSIBLE best practices by splitting configuration into reusable roles:
- **`common` Role**: 
  - Performs system updates (`apt`/`yum`).
  - Installs essential packages (`curl`, `git`, `htop`).
  - Creates administrative users with secure defaults.
- **`webserver` Role**:
  - Installs and enables Nginx.
  - **Security**: Generates self-signed SSL certificates and configures HTTPS.
  - **Dynamic Config**: Uses Jinja2 templates for Nginx Server Blocks (`nginx.conf.j2`) and Landing Pages (`index.html.j2`).
  - **Optimization**: Configures caching headers and operational settings.

### 2. Infrastructure as Code (Local Lab)
Instead of requiring AWS/Azure, this project includes a "Lab in a Box":
- **`docker-compose.yml`**: Spins up 3 Ubuntu containers (`web1`, `web2`, `db1`) with SSH enabled.
- **`inventory/docker.yml`**: Dynamic inventory mapping local ports (2221, 2222) to the container's SSH service.
- **`setup_env.sh`**: Automatically generates secure SSH key pairs and injects them into the containers on build.

---

## 🏗 Project Structure

```text
ansible-web-automation/
├── ansible.cfg             # Default Ansible configuration
├── docker-compose.yml      # The "Local Lab" infrastructure definition
├── inventory/
│   └── docker.yml          # Inventory mapping for Docker containers
├── playbooks/
│   └── site.yml            # Main Orchestrator Playbook
├── roles/
│   ├── common/             # System baselining
│   └── webserver/          # App deployment & Nginx config
└── scripts/
    └── setup_env.sh        # Bootstrapper for SSH keys
```

---

## 💻 How to Run (Demo)

Follow these steps to spin up the environment and run the automation locally.

### Prerequisites
- Docker & Docker Compose
- Ansible

### Step 1: Bootstrap the Lab
Run the setup script to generate SSH keys and build the containers:
```bash
./scripts/setup_env.sh
docker-compose up -d --build
```

### Step 2: Verify Infrastructure
Ensure Ansible can communicate with the "servers" (containers):
```bash
ansible -i inventory/docker.yml all -m ping
```
*Expected Output: `SUCCESS` for `web1`, `web2`, and `db1`.*

### Step 3: Execute Automation
Run the main playbook to provision the web servers:
```bash
ansible-playbook -i inventory/docker.yml playbooks/site.yml
```
*Watch as Ansible configures the nodes, installs Nginx, and deploys the site.*

### Step 4: Validate Results
Open your browser to test the deployed web applications:
- **Web Node 1**: [http://localhost:9090](http://localhost:9090)
- **Web Node 2**: [http://localhost:9091](http://localhost:9091)

You should see a custom confirming page with the server's hostname and deployment timestamp.

---

## 🔧 Skills Demonstrated
- **Idempotency**: The playbook can be run multiple times without breaking the system.
- **Variables & Templating**: Using `group_vars` and Jinja2 for dynamic configuration.
- **Handler Management**: Efficient service restarts (Nginx only restarts on config changes).
- **Environment Abstraction**: The same playbook runs on Docker or Real VMs by just swapping the inventory file.

---

## 🛡 Security Audit

This project includes a built-in security audit script using [Docker Bench for Security](https://github.com/docker/docker-bench-security). This tool checks for dozens of common best-practices around deploying Docker containers in production.

### Running the Audit
To audit your current container configuration, run:
```bash
./scripts/security_audit.sh
```

**Note:** This is a portfolio demo environment, so some security warnings (like "Running as root" or "Missing Healthcheck") are expected as we prioritize simplicity over strict production hardening.

---

## 🦅 Runtime Security (Falco)

Falco is running in the background to detect anomalous behavior in real-time.

### Viewing Security Alerts
To see live security alerts:
```bash
docker logs -f falco
```

### Triggering a Test Alert
To simulate a security incident (e.g., a "sensitive file read" attempt), run this command:
```bash
# This attempts to read /etc/shadow inside the container (Falco will catch this)
docker exec -it web1 cat /etc/shadow
```
*Check the Falco logs again, and you should see a `Notice` or `Warning` about the sensitive file read.*
