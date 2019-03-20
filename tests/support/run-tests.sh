#!/usr/bin/env bash

set -e
set -u
set -o pipefail

helm_version='2.12.3'


# --- Test if Helm was successfully installed ---

# Test if helm was installed successfully
ansible-playbook --tags=helm-install --extra-vars=ansible_system=Linux test-defaults.yml

# Make sure helm was installed by checking its version
"/tmp/helm/helm-${helm_version}" version --client

# ---


# --- Test if role works if no charts were defined ---

# Create a backup of current main.yml
cat /etc/ansible/roles/rolename/tasks/main.yml > /tmp/backup-main.yml
# Squeeze in the logic where helm gets replaced by a mocked script
sed -i '/- helm-install/r /etc/ansible/roles/rolename/tests/support/ansible-task-mock-helm.yml' \
  /etc/ansible/roles/rolename/tasks/main.yml

# Run the role
ansible-playbook --extra-vars=ansible_system=Linux test-defaults.yml

# Revert the file
cat /tmp/backup-main.yml > /etc/ansible/roles/rolename/tasks/main.yml

# Cleanup mocked helm script
rm -rf /tmp/helm/
# ---


# --- Test if role works with charts ---

# Create a backup of current main.yml
cat /etc/ansible/roles/rolename/tasks/main.yml > /tmp/backup-main.yml
# Squeeze in the logic where helm gets replaced by a mocked script
sed -i '/- helm-install/r /etc/ansible/roles/rolename/tests/support/ansible-task-mock-helm.yml' \
  /etc/ansible/roles/rolename/tasks/main.yml

# Run the role
ansible-playbook --extra-vars=ansible_system=Linux test-with-charts.yml

# Revert the file
cat /tmp/backup-main.yml > /etc/ansible/roles/rolename/tasks/main.yml
# ---
