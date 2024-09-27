# Display help information
default:
  @just --list

# Create the KinD cluster
create-kind-cluster:
  cd terraform/kind && terraform init && terraform apply -auto-approve

# Destroy the KinD cluster
delete-kind-cluster:
  cd terraform/kind && terraform destroy -auto-approve

# Export KUBECONFIG for the KinD cluster
export-kubeconfig:
  export KUBECONFIG="/tmp/kubeconfig"

# Install argo-workflows
install-argo-workflows:
  cd terraform/argo-workflows && terraform init && terraform apply -auto-approve

# Install argo-workflows in HA mode
install-argo-workflows-ha:
  cd terraform/argo-workflows && terraform init && terraform apply -auto-approve -var "ha=true"

# Uninstall argo-workflows
uninstall-argo-workflows:
  cd terraform/argo-workflows && terraform destroy -auto-approve

# Setup local cluster
setup: create-kind-cluster install-argo-workflows export-kubeconfig

# Setup local cluster in HA mode
setup-ha: create-kind-cluster install-argo-workflows-ha export-kubeconfig

# Teardown local cluster
teardown: uninstall-argo-workflows delete-kind-cluster

port-forward:
  @echo "https://localhost:2746"
  @kubectl -n argo port-forward service/argo-workflows-server 2746:2746
