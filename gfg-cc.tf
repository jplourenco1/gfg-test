# GFG Code Challenge
variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

provider "aws" {
  access_key = 
  secret_key = 
  region = "${var.aws_region}"
}

resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc_elk"
  }
}

resource "aws_subnet" "first_subnet" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "first_subnet"
  }
}

resource "aws_subnet" "second_subnet" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    Name = "second_subnet"
  }
}

resource "aws_security_group" "first" {
  name        = "eip_first"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.default.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ec2_elk_access_role" {
  name               = "elk-role"
  assume_role_policy = "${file("assumerolepolicy.json")}"
}

data "aws_iam_policy_document" "elasticsearch_iam_policy_document" {
  statement {
    sid = "1"

    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A ELK policy"
  policy      = "${data.aws_iam_policy_document.elasticsearch_iam_policy_document.json}"
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = ["${aws_iam_role.ec2_elk_access_role.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_route53_zone" "main" {
  name = "gfg-es-cluster.com"
}

module "elasticsearch" {
  source                  = "git::https://github.com/cloudposse/terraform-aws-elasticsearch.git?ref=master"
  namespace               = "eg"
  stage                   = "dev"
  name                    = "ES-Cluster"
  dns_zone_id             = "${aws_route53_zone.main.zone_id}"
  security_groups         = ["${aws_security_group.first.id}"]
  vpc_id                  = "${aws_vpc.default.id}"
  subnet_ids              = ["${aws_subnet.first_subnet.id}", "${aws_subnet.second_subnet.id}"]
  zone_awareness_enabled  = "true"
  elasticsearch_version   = "6.2"
  instance_type           = "t2.small.elasticsearch"
  instance_count          = 4
  iam_role_arns           = ["${aws_iam_role.ec2_elk_access_role.arn}"]
  iam_actions             = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"]
  encrypt_at_rest_enabled = "false"
  kibana_subdomain_name   = "kibana-es"
  ebs_volume_type         = "gp2"
  ebs_volume_size         = "10"
}
