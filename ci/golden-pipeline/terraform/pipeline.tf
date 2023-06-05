resource "codefresh_project" "ci_project" {
  name = "Continuous Integration"

  tags = [
    "ci"
  ]
}

resource "codefresh_pipeline" "ci_golden_pipeline" {
  name = "${codefresh_project.ci_project.name}/ci-golden-pipeline"

  tags = [
    "ci"
  ]

  spec {
    spec_template {
	  repo        = "${var.git_repo_owner}/${var.git_repo_repo_name_pipelines}"
      path        = "./ci/golden-pipeline/microservices-codefresh.yaml"
      revision    = "main"
      context     = "${var.cf_git_context}"
    }

    trigger {
      name                = "${var.git_repo_name_microservice_a}"
      type                = "git"
      repo                = "${var.git_repo_owner}/${var.git_repo_name_microservice_a}"
      events              = ["push.heads", "pullrequest.opened", "pullrequest.synchronize"]
      pull_request_allow_fork_events = false
      comment_regex       = "/.*/gi"
      branch_regex        = "/^((?!main)).*/gi"
      branch_regex_input  = "regex"
      provider            = "github"
      disabled            = false
      options {
        no_cache        = false
        no_cf_cache     = false
        reset_volume    = false
      }
      context             = "${var.cf_git_context}"
      contexts            = []
    }

    trigger {
      name                = "${var.git_repo_name_microservice_b}"
      type                = "git"
      repo                = "${var.git_repo_owner}/${var.git_repo_name_microservice_b}"
      events              = ["push.heads", "pullrequest.opened", "pullrequest.synchronize"]
      pull_request_allow_fork_events = false
      comment_regex       = "/.*/gi"
      branch_regex        = "/^((?!main)).*/gi"
      branch_regex_input  = "regex"
      provider            = "github"
      disabled            = false
      options {
        no_cache        = false
        no_cf_cache     = false
        reset_volume    = false
      }
      context             = "${var.cf_git_context}"
      contexts            = []
    }
  }
}