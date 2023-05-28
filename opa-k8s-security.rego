package main

deny[msg] {
  input.kind = "Service"
  not input.spec.type = "NodePort"
  msg = "Service type should be NodePort"
}

deny[msg] {
  input.kind = "Deployment"
  not input.spec.template.spec.container[1].securityContext.runAsNonRoot = true
  msg = "Containers must not run as root - use runAsNonRoot within container security context"
}