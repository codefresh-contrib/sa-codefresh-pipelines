# sa-codefresh-pipelines
Example Pipelines built by SA Team.

Additional documentation on [Codefresh Pipeline Specification](https://codefresh.io/docs/docs/integrations/codefresh-api/#full-pipeline-specification)

# Golden Pipeline
## Shared CI Pipeline

This specific example pipeline explains how one can reuse a Codefresh pipeline with multiple microservices.

The concept of the golden pipeline is to have a single YAML definition for CI that will be consumed by multiple microservice projects.

These projects could be separate GIT repositories or a mono repository.  

The example though is based on a separate GIT repository for each microservice.

The file `./ci/golden-pipeline/microservice.yaml` is full pipeline specification which is made up of both [GIT Triggers](https://codefresh.io/docs/docs/pipelines/triggers/git-triggers/) and [Codefresh Steps](https://codefresh.io/docs/docs/pipelines/steps/).

GIT triggers allow the user to associate the Codefresh pipeline with multiple GIT repositories or a single GIT repository with directory/path based microservices.

To utilize these in your account you will need to configure a [GIT provider pipeline integration](https://codefresh.io/docs/docs/integrations/git-providers) 

You will find the steps located under `.spec.steps` these steps can be stored inline in the full specification but can also be stored in another file or another GIT repository using `.spec.specTemplate`

```yaml
  specTemplate:
    location: git
    repo: <org name>/<repo name>
    path: ./<directory>/<file>
    revision: <branch>
    context: <GIT Pipeline Integration Name>
```

This pipeline will contain the steps for Continuous Integration.

Arguments should make use of [variables supplied by webhooks](https://codefresh.io/docs/docs/pipelines/variables) or by GIT triggers via [Build Variables in Advanced Options](https://codefresh.io/docs/docs/pipelines/triggers/git-triggers/#advanced-options).

The latter is defined in the pipeline specification under `.spec.triggers.[].variables`.

In the example Codefresh pipeline you'll see the a combination of both.

After you've setup the pipeline to meet your CI requirements for microservices.

The next step is to add consumers to use this pipeline.

Each microservice should be a separate trigger entity under `.spec.triggers.[]` array.

In this pipeline 2 such triggers exist.  

More can be added by adding into the array.

You can also control these externally as separate triggers and combine them through GIT contributions and a Codefresh Pipeline w/ Codefresh Marketplace Step [pipeline-trigger-merge](https://codefresh.io/steps/step/pipeline-trigger-merge)

Each trigger is setup to build on commit push, pull request open and pull request synchronize.

The CI pipeline is simplified into 4 steps.
1. [clone](https://codefresh.io/steps/step/git-clone) # Clones source code from GIT repository identified in trigger
1. [build](https://codefresh.io/steps/step/build) # Builds and pushes image to artifact repository
1. [test](https://codefresh.io/steps/step/freestyle) # Runs image as container
1. [report](https://codefresh.io/steps/step/codefresh-report-image) # Reports image to Codefresh

To utilize the final step in CI you will need to [install a Codefresh GitOps Runtime](https://codefresh.io/docs/docs/installation/gitops/)

More about GitOps Promotions will be covered by the next section of the README.md

Now that you have some information about purpose behind the pipelines you can copy over the files in `./ci/golden-pipelines` and make edits to use them on your Codefresh Account.

You will find in both files `<` and `>` symbols indicating those symbols should be replaced by the value of the source/key between the symbols.

In many cases the values will be found by locating the friendly names of the Pipeline Integrations and by the GIT VCS derived data.