###
### Variables
###
ANSIBLE_VERSION=2.5
HELM_VERSION=2.12.3
ANSIBLE_ARGS=


###
### Default
###
help:
	@printf "%s\n\n" "Available commands"
	@printf "%s\n"   "make test             Test the Ansible role"
	@printf "%s\n"   "make lint             Lint source files"
	@printf "%s\n"   "make help             Show help"

test:
	docker run --rm -it \
		-e HELM_VERSION=$(HELM_VERSION) \
		-e ANSIBLE_ARGS=$(ANSIBLE_ARGS) \
		-v ${PWD}:/etc/ansible/roles/rolename \
		-w /etc/ansible/roles/rolename/tests \
		flaconi/ansible:${ANSIBLE_VERSION} ./support/run-tests.sh

lint:
	yamllint .
