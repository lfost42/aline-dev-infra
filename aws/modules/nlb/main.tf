# Kubernetes Service Manifest (Type: Network Load Balancer Service)
resource "kubernetes_service_v1" "server_nlb" {
  metadata {
    name = "lf-aline-nlb"
    annotations = {
      # Traffic Routing
      "service.beta.kubernetes.io/aws-load-balancer-name" = "lf-aline-nlb"
      "service.beta.kubernetes.io/aws-load-balancer-type" = "external"
      "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "instance"

      # Access Control
      "service.beta.kubernetes.io/load-balancer-source-ranges" = "0.0.0.0/0"  # specifies the CIDRs that are allowed to access the NLB.
      "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing" # specifies whether the NLB will be internet-facing or internal

      # AWS Resource Tags
      "service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags" = "Environment=dev, Team=test"
    }        
  }
  spec {
    selector = {
      aline.component = server
    }
    ports {
      name        = "tcp"
      port        = 80
      target_port = 80
    }
    type = "ClusterIP"
  }
}