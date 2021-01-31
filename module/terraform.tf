terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    okta = {
      source  = "oktadeveloper/okta"
      version = "~> 3.6"
    }
  }
}