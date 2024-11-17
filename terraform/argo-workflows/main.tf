resource "helm_release" "argo_workflows" {
  name = "argo-workflows"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-workflows"

  namespace        = "argo"
  create_namespace = true

  values = ["${file("default-sa-rbac.yaml")}"]

  set_list {
    name  = "server.authModes"
    value = ["server"]
  }
}

resource "helm_release" "argo_artifacts" {
  name = "argo-artifacts"

  repository = "https://charts.min.io/"
  chart      = "minio"

  namespace        = "argo-artifacts"
  create_namespace = true

  set {
    name  = "replicas"
    value = "1"
  }

  set {
    name  = "mode"
    value = "standalone"
  }

  set {
    name  = "fullnameOverride"
    value = "argo-artifacts"
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "rootUser"
    value = "minioadmin"
  }

  set {
    name  = "rootPassword"
    value = "minioadmin"
  }

  set {
    name  = "buckets[0].name"
    value = "artifacts"
  }
}

# These secrets and configmaps need to be in the same ns as the submitted workflow ns
#
# For example, if we have `recogni-infrastructure` namespace for triggering CI on that repo
# then we need to create these secrets and configmaps in the same namespace
resource "kubernetes_secret" "argo_artifacts_secret" {
  metadata {
    namespace = "argo"
    name      = "argo-artifacts-secret"
  }

  data = {
    user     = "minioadmin"
    password = "minioadmin"
  }
}

resource "kubernetes_config_map" "argo_artifact_repository" {
  metadata {
    namespace = "argo"
    name      = "artifact-repositories"
    annotations = {
      "workflows.argoproj.io/default-artifact-repository" = "default-v1-s3-artifact-repository"
    }
  }

  data = {
    "default-v1-s3-artifact-repository" = <<-EOF
      s3:
        endpoint: argo-artifacts.argo-artifacts.svc.cluster.local:9000
        bucket: artifacts
        insecure: true
        accessKeySecret:
          name: argo-artifacts-secret
          key: user
        secretKeySecret:
          name: argo-artifacts-secret
          key: password
    EOF
  }
}

output "argo" {
  value = "Argo Workflows is available at http://localhost:2746"
}

output "argo-artifacts" {
  value = "Argo Artifacts is available at http://localhost:9000"
}


