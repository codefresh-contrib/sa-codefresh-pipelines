variable "cf_api_url" {
  type = string
  default = "http://g.codefresh.io/api"
  description = "Codefresh URL access. SAAS is at http://g.codefresh.io/api"
}
# Only required to be changed for self hosted control plane.

variable "cf_api_token" {
  type    = string
  default = ""
  sensitive = true
  description = "Codefresh access token. Create it from the Codefresh UI"
}
# Documentation: https://codefresh.io/docs/docs/integrations/codefresh-api/#authentication-instructions

variable "cf_git_context" {
  type    = string
  default = "github"
  sensitive = false
  description = "The name of the GIT context inside codefresh"
}
# Documentation: https://codefresh.io/docs/docs/integrations/git-providers

variable "git_repo_owner" {
  type    = string
  default = "codefresh_contrib"
  sensitive = false
  description = "A GitHub Repository Owner/Organization"
}
# GIT Organization Name or Personal GIT Name

variable "git_repo_repo_name_pipelines" {
  type    = string
  default = "sa-codefresh-pipelines"
  sensitive = false
  description = "Name of GIT repository storing Codefresh pipelines"
}
# GitHub Example Repository for Codefresh pipelines
# https://github.com/codefresh-contrib/sa-codefresh-pipelines

variable "git_repo_name_microservice_a" {
  type    = string
  default = "express"
  sensitive = false
  description = "Name of GIT repository of example microservice a"
}
# GitHub Example Repository for Express Microservice
# https://github.com/povadmin-45cbc49/express

variable "git_repo_name_microservice_b" {
  type    = string
  default = "flask-ui"
  sensitive = false
  description = "Name of GIT repository of example microservice b"
}
# GitHub Example Repository for Flask UI
# https://github.com/povadmin-45cbc49/flask-ui