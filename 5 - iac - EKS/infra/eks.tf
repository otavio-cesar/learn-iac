module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = "1.34"

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
      min_size     = 1
      max_size     = 1
      desired_size = 1
    }
  }
}

resource "aws_eks_addon" "eks_addon" {
  cluster_name = module.eks.cluster_name
  addon_version = "v1.18.0-eksbuild.1"
  addon_name = "vpc-cni"
}