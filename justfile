# Display help information
default:
  @just --list

# Create the k3d cluster
create-cluster:
  k3d cluster create argo || k3d cluster start argo

# Destroy the k3d cluster
delete-cluster:
  k3d cluster delete argo

port-forward-server:
  @kubectl -n argo port-forward service/argo-workflows-server 2746:2746

port-forward-artifacts:
  @kubectl -n argo-artifacts port-forward service/argo-artifacts-console 9001:9001

# Install argo-workflows
install-argo-workflows:
  cd terraform/argo-workflows && terraform init && terraform apply -auto-approve

# Uninstall argo-workflows
uninstall-argo-workflows:
  cd terraform/argo-workflows && terraform destroy -auto-approve

# Setup local cluster
setup: create-cluster install-argo-workflows
# port-forward

# Teardown local cluster
teardown: uninstall-argo-workflows delete-cluster
