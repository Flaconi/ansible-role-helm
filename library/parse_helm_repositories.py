#!/bin/env python

from ansible.module_utils.basic import *

import re

def parse_helm_repositories_output(text):
    repositories = []

    # Remove the header
    lines = text.splitlines()[1:]

    # Prepare regular expression
    reg = re.compile(r"^(?P<name>[^\s\t]+)[\s\t]+(?P<url>[^\s\n]+)$")

    # Loop through all the lines with the following format:
    # stable             	https://kubernetes-charts.storage.googleapis.com
    # local              	http://127.0.0.1:8879/charts
    for line in lines:
        match = reg.match(line)

        if match:
            repository = {
                "name": match.group("name"),
                "url": match.group("url"),
            }
            repositories.append(repository)

    return repositories

if __name__ == '__main__':
    fields = {
        "helm_output": {"required": True, "type": "str"}
    }
    module = AnsibleModule(argument_spec=fields)

    repositories = parse_helm_repositories_output(module.params['helm_output'])
    repository_names = list(map(lambda repository: repository['name'], repositories))
    repository_urls = list(map(lambda repository: repository['url'], repositories))

    module.exit_json(repositories=repositories, repository_names=repository_names, repository_urls=repository_urls)
