#!/usr/bin/env bash

set -e
set -u
set -o pipefail

script_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
test_directory="${script_directory}/.."
helm_version='2.12.3'


# --- Test if role fails when Helm command does NOT exist ---
set +e
# Test if helm was installed successfully
ansible-playbook "${test_directory}/test-defaults.yml"

exit_code=$?
if [ "${exit_code}" = '0' ]; then
  echo "Role should fail since helm command does NOT exist"
  exit 1
fi
set -e
# ---


# --- Test if role fails when specific Helm version does NOT exist ---
# Mock Helm
echo -e "#!/usr/bin/env bash\necho '2.12.3-wong-version'" > /usr/local/bin/helm
chmod u+x /usr/local/bin/helm

set +e
# Test if helm was installed successfully
ansible-playbook "${test_directory}/test-defaults.yml"

exit_code=$?
if [ "${exit_code}" = '0' ]; then
  echo "Role should fail since helm command does NOT exist"
  exit 1
fi
set -e
# ---


# --- Test if role works if no charts were defined ---
# Mock Helm
cp "${script_directory}/helm.mock" /usr/local/bin/helm

# Run the role
ansible-playbook "${test_directory}/test-defaults.yml"
# ---


# --- Test if role works with charts ---
# Run the role
ansible-playbook "${test_directory}/test-with-charts.yml"
# ---


# Clean up
rm /usr/local/bin/helm
