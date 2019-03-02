module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version      = "2.2.1"
  cluster_name = "${var.cluster-name}"
  subnets      = ["${var.vpc-private-cidrs}", "${var.vpc-public-cidrs}"]
  vpc_id       = "${var.vpc-id}"

  worker_groups = [
    {
      name                 = "${var.cluster-name}-workers"
      subnets              = "${join(",", var.vpc-private-cidrs)}"
      instance_type        = "${var.instance-type}"
      ami_id               = "ami-0eeeef929db40543c"
      asg_max_size         = "${var.asg-max}"
      asg_desired_capacity = "${var.asg-desired}"
      asg_min_size         = "${var.asg-min}"

      #   "key_name"       = "${var.ssh_key_name}"
    },
  ]

  tags = "${
    map(
     "Terraform","true",
     "Name", "${var.cluster-name}-eks-vpc",
     "kubernetes.io/cluster/${var.cluster-name}", "owned",
    )
  }"
}

resource "aws_iam_policy" "alb_ingress_permissions" {
  name   = "eks-alb-ingress"
  policy = "${file("${path.module}/eks_ingress.permissions.json")}"
}

resource "aws_iam_role_policy_attachment" "alb_ingress_permissions_attach" {
  role       = "${module.eks.worker_iam_role_name}"
  policy_arn = "${aws_iam_policy.alb_ingress_permissions.arn}"
}
