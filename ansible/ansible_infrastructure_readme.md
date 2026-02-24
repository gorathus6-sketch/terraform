# Ansible Infrastructure Automation

This repo contains a complete Ansible project demonstrating:
 - Inventories (INI + group vars)
 - Playbooks
 - Roles (webserver + database)
 - Jinja2 templates
 - Best practices for idempotent automation

 ## How to Run

 ```bash
 ansible-playbook -i inventories/dev/hosts.ini playbooks/site.yml