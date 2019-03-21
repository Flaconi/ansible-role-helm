# Ansible role: Helm

This role handles the creation and updates of Helm charts.

[![Build Status](https://travis-ci.org/Flaconi/ansible-role-helm.svg?branch=master)](https://travis-ci.org/Flaconi/ansible-role-helm)
[![Version](https://img.shields.io/github/tag/Flaconi/ansible-role-helm.svg)](https://github.com/Flaconi/ansible-role-helm/tags)
[![Ansible Galaxy](https://img.shields.io/ansible/role/d/25936.svg)](https://galaxy.ansible.com/Flaconi/aws-vpc-cgw/)

## Requirements

* Ansible 2.5


## Additional variables

Additional variables that can be used (either as `host_vars`/`group_vars` or via command line args):

| Variable                     | Description              |
|------------------------------|--------------------------|
| `helm_version`               | Helm version to download |
| `helm_local_directory_path`  | Directory into which to download Helm |
| `helm_configuration_files`   | Directory where chart configuration files is stored |

## Example Usage

```yml
---
- name: Install Helm locally and roll out charts
  hosts: localhost
  roles:
    - role: rolename
      vars:
        helm_version: 2.12.3

        helm_local_directory_path: '/tmp/helm'

        # Directory with custom values for helm charts
        # Example:
        #   $ tree ./helm-config
        #   ./helm-config
        #   ├── prometheus
        #   │   └── values.yml
        #   └── logstash
        #       └── values.yml
        helm_configuration_files: "{{ playbook_dir }}/helm-config"
        helm_charts:
          - release: prometheus
            chart: stable/prometheus
            chart_version: 8.8.0
            values_file_path: prometheus/values.yml
            namespace: prometheus

          - release: logstash
            chart: stable/logstash
            chart_version: 8.8.0
            values_file_path: logstash/values.yml
            namespace: logstash
```

## Testing

#### Requirements

* Docker
* [yamllint](https://github.com/adrienverge/yamllint)

#### Run tests

```bash
# Lint the source files
make lint

# Run integration tests with default Ansible version
make test

# Run integration tests with custom Ansible version
make test ANSIBLE_VERSION=2.4
```
