# Ansible role: Helm

This role handles the creation and updates of Helm charts.

[![Build Status](https://travis-ci.com/Flaconi/ansible-role-helm.svg?branch=master)](https://travis-ci.com/Flaconi/ansible-role-helm)
[![Version](https://img.shields.io/github/tag/Flaconi/ansible-role-helm.svg)](https://github.com/Flaconi/ansible-role-helm/tags)

## Requirements

* Ansible 2.5


## Additional variables

Additional variables that can be used (either as `host_vars`/`group_vars` or via command line args):

| Variable                    | Type   | Description              |
|-----------------------------|--------|--------------------------|
| `helm_version`              | string | Locally expected Helm version (major+minor) (defaults to: `2.12.3`) |
| `helm_version_strict`       | bool   | If True, check against major, minor and patch, otherwise only major and minor version (defaults to: `True`) |
| `helm_configuration_files`  | dict   | Directory where chart configuration files is stored |
| `helm_charts`               | list   | List of items which represent the release. <br />Release items have the following fields: `release`,`chart`,`chart_version`,`values_file_path`,`namespace` |

## Example Usage

```yml
---
- name: Install Helm locally and roll out charts
  hosts: localhost
  roles:
    - role: rolename
      vars:
        helm_version: 2.12.x
        helm_version_strict: False

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
make test ANSIBLE_VERSION=2.5
```
