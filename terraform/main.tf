terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}


provider "kubernetes" {
  config_path    = "/home/olha/.kube/config"
  config_context = "minikube"
  experiments {
      manifest_resource = true
  }

}

resource "kubernetes_manifest" "deployment_test_go_app" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "go-app"
      }
      "name" = "go-app"
      "namespace" = "test"
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "app" = "go-app"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "go-app"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name" = "PORT"
                  "value" = "8080"
                },
              ]
              "image" = "go-docker"
              "imagePullPolicy" = "IfNotPresent"
              "lifecycle" = {
                "preStop" = {
                  "exec" = {
                    "command" = [
                      "/bin/sh",
                      "-c",
                      "echo PRE STOP!",
                    ]
                  }
                }
              }
              "livenessProbe" = {
                "httpGet" = {
                  "path" = "/"
                  "port" = 8080
                }
                "initialDelaySeconds" = 15
                "periodSeconds" = 10
              }
              "name" = "go-app"
              "ports" = [
                {
                  "containerPort" = 8080
                },
              ]
              "readinessProbe" = {
                "httpGet" = {
                  "path" = "/"
                  "port" = 8080
                }
                "initialDelaySeconds" = 15
                "periodSeconds" = 10
              }
            },
          ]
          "initContainers" = [
            {
              "command" = [
                "sleep",
                "30",
              ]
              "image" = "busybox"
              "name" = "delay"
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_test_go_app_service" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "go-app-service"
      "namespace" = "test"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "go-app-port"
          "port" = 8080
          "protocol" = "TCP"
          "targetPort" = 8080
        },
      ]
      "selector" = {
        "app" = "go-app"
      }
    }
  }
}
