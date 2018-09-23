provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "darumatic"
  region                  = "ap-southeast-2"
}

terraform {
  backend "s3" {
    bucket  = "darumatic.harbor.terraform"
    key     = "teffaform.tfstate"
    region  = "ap-southeast-2"
    profile = "darumatic"
  }
}
