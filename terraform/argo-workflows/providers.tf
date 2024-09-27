terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.32.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.15.0"
    }
  }
}

provider "kubernetes" {
  config_path    = local.kubeconfig_path
  config_context = "kind-${local.cluster_name}"
}

provider "helm" {
  kubernetes {
    config_path = local.kubeconfig_path
  }
}
