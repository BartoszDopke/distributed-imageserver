provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      env     = "dev"
      service = "distributed-image-server"
    }
  }
}