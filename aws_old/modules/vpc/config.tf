# PROVIDERS to identify both VPC's
provider "aws" {
  region  = var.region
  alias   = "peer"
  profile = "aline"
  assume_role {
      role_arn = var.peer_role_arn
  }
}

provider "aws" {
  region  = var.region
  alias   = "db"
  profile = "db"
}
