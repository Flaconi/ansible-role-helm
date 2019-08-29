#!/usr/bin/env bash

set -e
set -u
set -o pipefail

script_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
test_directory="${script_directory}/.."


if env | grep -q '^HELM_VERSION=' 2>/dev/null; then
	HELM_VERSION="$( env | grep '^HELM_VERSION=' | sed 's/^HELM_VERSION=//g' )"
else
	HELM_VERSION="2.12.3"
fi

if env | grep -q '^ANSIBLE_ARGS=' 2>/dev/null; then
	ANSIBLE_ARGS="--diff $( env | grep '^ANSIBLE_ARGS=' | sed 's/^ANSIBLE_ARGS=//g' )"
else
	ANSIBLE_ARGS="--diff"
fi


echo "${ANSIBLE_ARGS}"
echo
echo "----------------------------------------------------------------------------------------------------"
echo "- [NEED TO FAIL] Helm is not installed"
echo "----------------------------------------------------------------------------------------------------"
# --- Test if role fails when Helm command does NOT exist ---
# Test if helm was installed successfully
if ansible-playbook ${ANSIBLE_ARGS} ${test_directory}/test-defaults.yml; then
  echo "Role should fail since helm command does NOT exist"
  exit 1
fi


echo
echo "----------------------------------------------------------------------------------------------------"
echo "- [NEED TO FAIL] Helm has wrong version"
echo "----------------------------------------------------------------------------------------------------"
# --- Test if role fails when specific Helm version does NOT exist ---
# Mock Helm
echo -e "#!/usr/bin/env bash" > /usr/local/bin/helm
echo -e "echo '1-wrong-version'" >> /usr/local/bin/helm
chmod u+x /usr/local/bin/helm

# Test if helm was installed successfully
if ansible-playbook ${ANSIBLE_ARGS} ${test_directory}/test-defaults.yml; then
  echo "Role should fail since helm command has wrong version"
  exit 1
fi


# Mock Helm
cp "${script_directory}/helm.mock" /usr/local/bin/helm


echo
echo "----------------------------------------------------------------------------------------------------"
echo "- [NEED TO SUCC] Role without charts defined"
echo "----------------------------------------------------------------------------------------------------"
ansible-playbook ${ANSIBLE_ARGS} ${test_directory}/test-defaults.yml


echo
echo "----------------------------------------------------------------------------------------------------"
echo "- [NEED TO SUCC] Role with charts defined"
echo "----------------------------------------------------------------------------------------------------"
ansible-playbook ${ANSIBLE_ARGS} ${test_directory}/test-with-charts.yml


# Clean up
rm -f /usr/local/bin/helm || true
