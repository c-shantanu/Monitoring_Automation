terraform {

  backend "s3" {

    bucket         = "shantanu-tool"

    key            = "Postgresql/terraform.tfstate"

    region         = "ap-northeast-1"

    dynamodb_table = "terraform-dynamodb"

    encrypt        = true

  }

}
