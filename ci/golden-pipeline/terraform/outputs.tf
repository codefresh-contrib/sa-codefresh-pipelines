output "project_id" {
  value = codefresh_project.ci_project.id
}

output "pipeline_id" {
  value = codefresh_pipeline.ci_golden_pipeline.id
}