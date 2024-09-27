locals {
  cluster_name       = "argoci"
  kubernetes_version = "v1.31.0"
  kubeconfig_path    = "/tmp/kubeconfig"
}

resource "kind_cluster" "default" {
  name            = local.cluster_name
  node_image      = "kindest/node:${local.kubernetes_version}" # check from kind releases
  kubeconfig_path = pathexpand(local.kubeconfig_path)
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
      extra_port_mappings {
        container_port = 80
        host_port      = 80
      }
    }

    node {
      role = "worker"
    }
  }
}
