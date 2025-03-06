provider "aws" {
  region = "us-east-1"
}

resource "aws_eks_cluster" "my_eks" {
  name     = "my-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = ["subnet-xxxxx", "subnet-yyyyy"]
  }
}

resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role"
  
  assume_role_policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}
