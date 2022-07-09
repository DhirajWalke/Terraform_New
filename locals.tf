locals {
  ingress_rules = [{
    port        = 22
    description = "this is ssh port"
    },
    {
      port        = 80
      description = "this is http port"
    }

  ]
}