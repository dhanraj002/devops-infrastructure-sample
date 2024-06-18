terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.25.0"
    }
  }
  backend "s3" {
    key = "network/terraform.tfstate"
    encrypt = true
  }
}

locals {
  region = var.aws_region
}

# Prep for default tags. Remember to supply a tags block per resource, but
#   only for the name or other custom/non-standard/otherwise specified tags
locals {
  terraform_component = "${basename(path.cwd)}"
  provider_component_tags = merge(
    var.common_tags,
    {
      "Provisioner"         = "terraform"
      "Environment"         = var.environment
      "terraform:component" = local.terraform_component
    }
  )
}

provider "aws" {
  region = local.region

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true

  default_tags {
    tags = local.provider_component_tags
  }
}
