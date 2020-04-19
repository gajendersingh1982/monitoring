#Role for EC2
resource "aws_iam_role" "ec2_role_api" {
  name = "cloudpoc_api_role"

  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
    "Effect": "Allow",
    "Principal": {
        "Service": "ec2.amazonaws.com"
    },
    "Action": "sts:AssumeRole",
    "Sid": ""
    }
]
}
EOF
}


#Instance profile
resource "aws_iam_instance_profile" "ec2_instance_profile_api" {
  name = "cloudpoc_instance_profile_api"
  role =  aws_iam_role.ec2_role_api.name
}


###Custom Policies can be defined as per requirement

resource "aws_iam_role_policy" "ec2_policy_api" {
  name = "cloudpoc_ec2_api"
  role = aws_iam_role.ec2_role_api.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:Describe*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:Describe*",
            "Resource": "*"
        }
    ]
}
EOF
}