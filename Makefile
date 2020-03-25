###
### Variables
###
ANSIBLE_VERSION=2.5
HELM_VERSION=3.1.2
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
	@printf "%s\n\n" "Run modules unit tests with Python 2"
	docker run --rm -it \
		-v ${PWD}/:/tests/ \
		-w /tests \
		flaconi/ansible:${ANSIBLE_VERSION} python /tests/library/test_parse_helm_repositories.py

	@printf "%s\n\n" "Run modules unit tests with Python 3"
ifeq ($(ANSIBLE_VERSION),latest)
	docker run --rm -it \
		-v ${PWD}/:/tests/ \
		-w /tests \
		--entrypoint /bin/sh \
		python:3 -c "pip3 install -q ansible && python3 /tests/library/test_parse_helm_repositories.py"
else
	docker run --rm -it \
		-v ${PWD}/:/tests/ \
		-w /tests \
		--entrypoint /bin/sh \
		python:3 -c "pip3 install -q ansible==${ANSIBLE_VERSION} && python3 /tests/library/test_parse_helm_repositories.py"
endif

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
