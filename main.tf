# region Kubernetes Resources
# Referencing
# https://github.com/aws-samples/amazon-cloudwatch-container-insights/blob/master/k8s-yaml-templates/quickstart/cwagent-fluentd-quickstart.yaml
# Line 185
resource "kubernetes_service_account" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = var.create_iam_role ? aws_iam_role.this[0].arn : var.iam_role_arn
    }
    labels = {
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}
# line 191
resource "kubernetes_cluster_role" "this" {
  metadata {
    name = var.name
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods", "pods/logs"]
    verbs      = ["get", "list", "watch"]
  }
}
# Line 203
resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = var.name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = var.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = var.name
    namespace = var.namespace
  }
}
# Line 216
resource "kubernetes_config_map" "example" {
  metadata {
    labels = {
      "k8s-app" = "${var.name}-cloudwatch"
    }
    name      = "${var.name}-config"
    namespace = var.namespace
  }

  data = {
    "containers.conf" = "${file("${path.module}/templates/containers.conf")}"
    "fluent.conf"     = "${file("${path.module}/templates/fluent.conf")}"
    "host.conf"       = "${file("${path.module}/templates/host.conf")}"
    "systemd.conf"    = "${file("${path.module}/templates/systemd.conf")}"
  }

}


# Line 530
resource "kubernetes_daemon_set_v1" "this" {
  metadata {
    name      = "${var.name}-cloudwatch"
    namespace = var.namespace
    labels = {
      "k8s-app" = "${var.name}-cloudwatch"
    }
  }

  spec {
    selector {
      match_labels = {
        "k8s-app" = "${var.name}-cloudwatch"
      }
    }

    template {
      metadata {
        labels = {
          "k8s-app" = "${var.name}-cloudwatch"
        }
        annotations = {
          "iam.amazonaws.com/role" = var.name
        }
      }

      spec {
        container {
          env {
            name  = "REGION"
            value = data.aws_region.current.name
          }
          env {
            name  = "CLUSTER_NAME"
            value = data.aws_eks_cluster.target.name
          }
          image             = "fluent/${var.image_name}:${var.image_version}"
          image_pull_policy = "IfNotPresent"
          name              = "${var.name}-cloudwatch"

          resources {
            limits = {
              memory = "400Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "200Mi"
            }
          }

          volume_mount {
            mount_path = "/config-volume"
            name       = "config-volume"
          }
          volume_mount {
            mount_path = "/fluentd/etc"
            name       = "fluentdconf"
          }
          volume_mount {
            mount_path = "/var/log"
            name       = "varlog"
          }
          volume_mount {
            mount_path = "/var/lib/docker/containers"
            name       = "varlibdockercontainers"
            read_only  = true
          }
          volume_mount {
            mount_path = "/run/log/journal"
            name       = "runlogjournal"
            read_only  = true
          }
          volume_mount {
            mount_path = "/var/log/dmesg"
            name       = "dmesg"
            read_only  = true
          }


        }
        dns_policy                       = "ClusterFirst"
        service_account_name             = var.name
        termination_grace_period_seconds = 30
        volume {
          config_map {
            name = "${var.name}-config"
          }
          name = "config-volume"
        }
        volume {
          empty_dir {}
          name = "fluentdconf"
        }
        volume {
          host_path {
            path = "/var/log"
          }
          name = "varlog"
        }
        volume {
          host_path {
            path = "/var/lib/docker/containers"
          }
          name = "varlibdockercontainers"
        }
        volume {
          host_path {
            path = "/run/log/journal"
          }
          name = "runlogjournal"
        }
        volume {
          host_path {
            path = "/var/log/dmesg"
          }
          name = "dmesg"
        }
        init_container {
          command = ["sh", "-c", "cp /config-volume/..data/* /fluentd/etc"]
          image   = "busybox"
          name    = "copy-fluentd-config"
          volume_mount {
            mount_path = "/config-volume"
            name       = "config-volume"
          }
          volume_mount {
            mount_path = "/fluentd/etc"
            name       = "fluentdconf"
          }
        }
        init_container {
          command = ["sh", "-c", ""]
          image   = "busybox"
          name    = "update-log-driver"
        }
      }
    }
  }
}
/**/
# endregion Kubernetes Resources

# region aws iam role

locals {
  iam_role_name = coalesce(var.iam_role_name, "${var.eks_cluster_name}-${var.name}")
}
# to be updated
data "aws_iam_policy_document" "assume_role_policy" {
  count = var.create_iam_role ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.target.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values = [
        "system:serviceaccount:${var.namespace}:${var.name}"
      ]
    }
    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.target.identity[0].oidc[0].issuer, "https://", "")}"
      ]
      type = "Federated"
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.create_iam_role ? 1 : 0

  name        = var.iam_role_use_name_prefix ? null : local.iam_role_name
  name_prefix = var.iam_role_use_name_prefix ? "${local.iam_role_name}${var.prefix_separator}" : null
  path        = var.iam_role_path
  description = var.iam_role_description

  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy[0].json
  permissions_boundary  = var.iam_role_permissions_boundary
  force_detach_policies = true

  inline_policy {
    name = "DescribeLogGroupsandStreams"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams",
          ]
          "Resource" : "*"
        }
      ]
    })
  }

  managed_policy_arns = ["arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSAppSyncPushToCloudWatchLogs"]

  tags = merge(var.tags, var.iam_role_tags)

}

# endregion aws iam role
