provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "ty"
  region                  = "ap-southeast-2"
}

terraform {
  backend "s3" {
    bucket  = "ty.harbor.terraform"
    key     = "teffaform.tfstate"
    region  = "ap-southeast-2"
    profile = "ty"
  }
}
