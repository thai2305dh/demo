# terraform {
#     backend "s3" {
#         bucket = "nthai-tf"
#         key = "global/s3/terraform.tfstate"
#         region = "us-east-2"
#         dynamodb_table = "terraform-state-locking"
#         encrypt = true
#     }
# }

provider "aws" {
    region = "us-east-2"
#     access_key = "AKIAZ3235S2W5MIN2HU6"
#     secret_key = "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"
}

# resource "aws_s3_bucket" "tf-state" {
#     bucket = "nthai-tf"

#     lifecycle {
#         prevent_destroy = true //Yêu cầu xóa theo cách thủ công
#     }

#     # versioning {
#     #     enabled = true //có thể xem được trạng thái trước đó
#     # }

#     # server_side_encryption_configuration {
#     #     rule {
#     #         apply_server_side_encryption_by_default {
#     #             sse_algorithm = "AES256" // Đảm bảo tệp trong s3 được mã hóa
#     #         }
#     #     }
#     # }
# }

# resource "aws_dynamodb_table" "terraform_locks" {
#     name = "terraform-state-locking"
#     billing_mode = "PAY_PER_REQUEST"
#     hash_key = "LockID" //Đặt khóa băm

#     attribute {
#         name = "LockID"
#         type = "S"
#     }
# }
