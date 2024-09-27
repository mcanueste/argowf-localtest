variable "ha" {
  type    = bool
  default = false
}

locals {
  cluster_name    = "argoci"
  kubeconfig_path = "/tmp/kubeconfig"
  ha_enabled      = var.ha
}

resource "helm_release" "argo_workflows" {
  name = "argo-workflows"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-workflows"

  namespace        = "argo"
  create_namespace = true

  values = concat(local.ha_enabled ? ["${file("ha-values.yaml")}"] : [], ["${file("default-sa-rbac.yaml")}"])

  set_list {
    name  = "server.authModes"
    value = ["server"]
  }
}
