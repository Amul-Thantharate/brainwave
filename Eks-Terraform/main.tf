data "aws_iam_policy_document" "assume_role" {
    statement {
        effect = "Allow"
        principals {
            type        = "Service"
            identifiers = ["eks.amazon.com"]
        }
        actions = ["sts:AssumeRole"] 
    }
}

resource "aws_iam_role" "eks-brainwave" {
    name               = "eks-brainwave"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "brainwave-AmazonEKSClusterPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eks-brainwave.name
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "public" {
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}

resource "aws_eks_cluster" "brainwave" {
    name = "brainwave"
    role_arn = aws_iam_role.eks-brainwave.arn
    vpc_config {
        subnet_ids = data.aws_subnets.public.ids
    }
    depends_on = [ aws_iam_role_policy_attachment.brainwave-AmazonEKSClusterPolicy, ]
}

resource "aws_iam_role" "brainwave1" {
    name = "brainwave1"
        assume_role_policy = jsonencode({
        Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "ec2.amazonaws.com"
        }
        }]
        Version = "2012-10-17"
    })
}

resource "aws_iam_instance_profile" "brainwave1" {
    name = "brainwave1"
    role = aws_iam_role.brainwave1.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.brainwave1.name
}

resource "aws_iam_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
    name = "example-AmazonEKSWorkerNodePolicy"
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    roles = [aws_iam_role.brainwave1.name]
}
resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role       = aws_iam_role.brainwave1.name
}

resource "aws_eks_node_group" "brainwave" {
    cluster_name = "brainwave"
    node_group_name = "brainwave-ng"
    node_role_arn = aws_iam_role.brainwave1.arn
    subnet_ids = data.aws_subnets.public.ids
    scaling_config {
        desired_size = 2
        max_size     = 2
        min_size     = 1
    }
    instance_types = [ "t2.medium" ]
    depends_on = [ 
        aws_iam_role_policy_attachment.brainwave-AmazonEKSClusterPolicy,
        aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
    ]
}