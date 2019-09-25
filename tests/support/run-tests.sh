#!/usr/bin/env bash

set -e
set -u
set -o pipefail

script_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
test_directory="${script_directory}/.."


HELM_VERSION="${HELM_VERSION:-2.12.3}"
ANSIBLE_ARGS="--diff ${ANSIBLE_ARGS:-}"



echo "Ansible arguments set to '${ANSIBLE_ARGS}'. Overwrite with ANSIBLE_ARGS"


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


echo
echo "----------------------------------------------------------------------------------------------------"
echo "- [NEED TO SUCC] (kubecontext) Role without charts defined"
echo "----------------------------------------------------------------------------------------------------"
export HELM_KUBECTL_CONTEXT=minikube
ansible-playbook ${ANSIBLE_ARGS} ${test_directory}/test-defaults.yml -e helm_kubectl_context=${HELM_KUBECTL_CONTEXT}
unset HELM_KUBECTL_CONTEXT

echo
echo "----------------------------------------------------------------------------------------------------"
echo "- [NEED TO SUCC] (kubecontext) Role with charts defined"
echo "----------------------------------------------------------------------------------------------------"
export HELM_KUBECTL_CONTEXT=minikube
ansible-playbook ${ANSIBLE_ARGS} ${test_directory}/test-with-charts.yml -e helm_kubectl_context=${HELM_KUBECTL_CONTEXT}
unset HELM_KUBECTL_CONTEXT


# Clean up
rm -f /usr/local/bin/helm || true
