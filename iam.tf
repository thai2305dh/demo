#Dinh nghia IAM va nhom
resource "aws_iam_user" "user1" {
    name = "user1"
}

resource "aws_iam_user" "user2" {
    name = "user2"
}

resource "aws_iam_group" "tf-group" {
    name = "tf-group"
}

# Sau khi tạo user và group thì cần phân users vào group
resource "aws_iam_group_membership" "assigment" {
    name =  "assigment"
    users = [
        aws_iam_user.user1.name,
        aws_iam_user.user2.name
    ]
    group = aws_iam_group.tf-group.name
}

resource "aws_iam_user_login_profile" "user1" {
    user = aws_iam_user.user1.name
    pgp_key = "keybase:thainguyen23"
}

resource "aws_iam_policy" "tf-policy" {
    name = "tf-policy"
    path = "/"//"arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
// Tạo 1 policy cho phép user đăng nhập vào EC2 nhưng k cho xóa và thay đổi policy
# JSON
    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:BatchGetImage",
                "ecr:GetLifecyclePolicy",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:ListTagsForResource",
                "ecr:DescribeImageScanFindings",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:PutImage"
            ],
            "Resource": "*"
        }
    ]
})
}
resource "aws_iam_role" "tf-role" {
    name = "tf-role"
    
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Attach(gán) role cho user
resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  users      = [aws_iam_user.user1.name,
        aws_iam_user.user2.name
  ]
  roles      = [aws_iam_role.tf-role.name]
  groups     = [aws_iam_group.tf-group.name]
policy_arn = aws_iam_policy.tf-policy.arn
}
