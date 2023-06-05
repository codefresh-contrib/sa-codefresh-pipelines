terraform {
  required_providers {
    codefresh = {
      source = "codefresh-io/codefresh"
      version = "0.4.0"
    }
  }
}

provider "codefresh" {
  api_url = var.cf_api_url
  token = var.cf_api_token
}
