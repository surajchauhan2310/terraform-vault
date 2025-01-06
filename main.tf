provider "aws" {
  region = "ap-south-1"
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "b0c695df-7865-3e5b-bace-b90e93b9b08d"
      secret_id = "18d20fd4-28a8-67cf-a3b5-bdcd90d54bbf"
    }
  }
}


data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "aws-secrets"
}

resource "aws_instance" "ec2-demo" {
  ami = "ami-0fd05997b4dff7aac"
  instance_type = "t2.micro"

  tags = {
    secrets=data.vault_kv_secret_v2.example.data["username"]
  }
}