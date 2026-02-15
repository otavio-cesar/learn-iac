module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "EKS-Django"
  kubernetes_version = "1.33"

  # endpoint_public_access  = true
  endpoint_private_access = true

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    green = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = [var.maquina]
      vpc_security_group_ids = [aws_security_group.ssh_cluster.id]
      min_size     = 2
      max_size     = 3
      desired_size = 2
    }
  }
}