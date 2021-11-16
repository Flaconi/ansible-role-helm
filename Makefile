###
### Variables
###
ANSIBLE_VERSION=2.9
HELM_VERSION=3.4.2
ANSIBLE_ARGS=

.PHONY: help test test-unit test-integration lint

###
### Default
###
help:
	@printf "%s\n\n" "Available commands"
	@printf "%s\n"   "make test             Test the Ansible role"
	@printf "%s\n"   "make lint             Lint source files"
	@printf "%s\n"   "make help             Show help"

test-unit:
	@printf "%s\n\n" "Run modules unit tests with Python 3"
	docker run --rm -it \
		-v ${PWD}/:/tests/ \
		-w /tests \
		flaconi/ansible:${ANSIBLE_VERSION} python3 /tests/library/test_parse_helm_repositories.py

test-integration:
	@printf "%s\n\n" "Run integration tests"
	docker run --rm -it \
		-e HELM_VERSION=$(HELM_VERSION) \
		-e ANSIBLE_ARGS=$(ANSIBLE_ARGS) \
		-v ${PWD}:/etc/ansible/roles/rolename \
		-w /etc/ansible/roles/rolename/tests \
		flaconi/ansible:${ANSIBLE_VERSION} ./support/run-tests.sh

test: test-unit test-integration

lint:
	yamllint .
