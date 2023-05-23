# sa-codefresh-pipelines
Example Pipelines built by SA Team.

Additional documentation on [Codefresh Pipeline Specification](https://codefresh.io/docs/docs/integrations/codefresh-api/#full-pipeline-specification)

# Golden Pipeline
## Shared CI Pipeline

This specific example pipeline explains how one can reuse a Codefresh pipeline with multiple microservices.

The concept of the golden pipeline is to have a single YAML definition for CI that will be consumed by multiple microservice projects.

These projects could be separate GIT repositories or a mono repository.  

The example though is based on a separate GIT repository for each microservice.

The file ./ci/golden-pipeline/microservice.yaml is full pipeline specification which is made up of both [GIT Triggers](https://codefresh.io/docs/docs/pipelines/triggers/git-triggers/) and [Codefresh Steps](https://codefresh.io/docs/docs/pipelines/steps/).

GIT triggers allow the user to associate the Codefresh pipeline with multiple GIT repositories or a single GIT repository with directory/path based microservices.

You will find the steps located under .spec.steps these steps can be stored inline in the full specification but can also be stored in another file or another GIT repository using .specTemplate

```
  specTemplate:
    location: git
    repo: <org>/<repo>
    path: ./<directory>/<file>
    revision: <branch>
    context: <git integration context>
```