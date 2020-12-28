#!/usr/bin/env python
# -*- coding: utf-8 -*-

import unittest

from parse_helm_repositories import *

class parse(unittest.TestCase):
    def test_parse_helm_repositories_output(self):
        helm_repositories_output = """
NAME               	URL
stable             	https://charts.helm.sh/stable
local              	http://127.0.0.1:8879/charts
reactiveops-stable 	https://charts.reactiveops.com/stable
flaconi-common-helm	s3://flaconi-helm-charts
zalenium-github    	https://raw.githubusercontent.com/zalando/zalenium/3.141.59u/charts/zalenium
        """.strip()

        expected_helm_repositories = [
            {
                "name": "stable",
                "url": "https://charts.helm.sh/stable",
            },
            {
                "name": "local",
                "url": "http://127.0.0.1:8879/charts",
            },
            {
                "name": "reactiveops-stable",
                "url": "https://charts.reactiveops.com/stable",
            },
            {
                "name": "flaconi-common-helm",
                "url": "s3://flaconi-helm-charts",
            },
            {
                "name": "zalenium-github",
                "url": "https://raw.githubusercontent.com/zalando/zalenium/3.141.59u/charts/zalenium",
            },
        ]

        self.assertListEqual(expected_helm_repositories, parse_helm_repositories_output(helm_repositories_output))

    # The method is prepared if "helm repo list" output changes in the future
    def test_parse_helm_repositories_output_malformed(self):
        helm_repositories_output = """
NAME               	VERSION URL
stable             	1       https://charts.helm.sh/stable
local              	1       http://127.0.0.1:8879/charts
reactiveops-stable 	1       https://charts.reactiveops.com/stable
flaconi-common-helm	1       s3://flaconi-helm-charts
zalenium-github    	1       https://raw.githubusercontent.com/zalando/zalenium/3.141.59u/charts/zalenium
        """.strip()

        expected_helm_repositories = []

        self.assertListEqual(expected_helm_repositories, parse_helm_repositories_output(helm_repositories_output))

if __name__ == '__main__':
    unittest.main()
