module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.58.0"

  name = "${var.cluster-name}-eks-vpc"
  cidr = "${var.vpc-cidr}"

  azs             = "${var.availability_zones["${var.aws-region}"]}"
  private_subnets = "${var.vpc-private-cidrs}"
  public_subnets  = "${var.vpc-public-cidrs}"

  enable_nat_gateway   = true
  enable_dns_hostnames = true

  tags = "${
    map(
     "Terraform","true",
     "Name", "${var.cluster-name}-eks-vpc",
     "kubernetes.io/cluster/${var.cluster-name}", "owned",
    )
  }"
}

resource "aws_iam_role" "user_role" {
  count = "${length(var.users)}"

  name = "${element(var.users, count.index)}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::100372148713:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# resource "aws_iam_policy" "assume_role" {
#   count = "${length(var.users)}"
#   name    = "allow-glue-s3-kms-encrypt-decrypt"
#   path        = "/"
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": {
#     "Effect": "Allow",
#     "Action": "sts:AssumeRole",
#     "Resource": "arn:aws:iam::100372148713:role/user-${element(var.users, count.index)}"
#   }
# }
# EOF
# }
#
# resource "aws_iam_role_policy_attachment" "assume_policy" {
#   count = "${length(var.users)}"
#
#   role       = "${aws_iam_role.user_role.user-${element(var.users, count.index)}"
#   policy_arn = "${aws_iam_policy.assume_role.arn}"
# }
