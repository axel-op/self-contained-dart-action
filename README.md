# Self-contained Dart GitHub Action

> [See here](https://gist.github.com/axel-op/deff66ac2f28a01813193d90de36c564) for a comparison of the different ways to build a GitHub Action with Dart.

In 2020, I published the Pub package [`github_actions_toolkit`](https://pub.dev/packages/github_actions_toolkit) to write GitHub Actions with Dart more easily. However, using such actions in a workflow is still cumbersome, as they need [a full Dart container to be pulled](https://github.com/axel-op/containerized-dart-action) before they can be run, which is very time consuming for these scripts that generally run in a few seconds.

This repository is a template to demonstrate how to create a GitHub Action with Dart that is self-contained in a tiny Docker container, that can be pulled and used in a workflow very quickly.

## How it works

The repository leverages the [`dart compile`](https://dart.dev/tools/dart-compile#exe) (ex `dart2native`) command and [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry) to package and publish the Dart action as a small container image.

[A GitHub Action workflow](.github/workflows/push.yml) automatically compiles the Dart application into a native executable using `dart compile`. Then, this executable is wrapped in a Docker container that contains only the libraries required to run it. Finally, the image of this container is published on GitHub Container Registry using the Docker API.

By default, the full image tag is `{OWNER}/{REPOSITORY}:{BRANCH}`, where `BRANCH` is the branch on which the workflow that published the image was executed.

The image is listed at the address [`github.com/{OWNER}/{REPOSITORY}/packages`](https://github.com/axel-op/self-contained-dart-action/packages).

## How to use it in a workflow

The following workflow is inspired by the [`Hello World` example of the GitHub documentation](https://docs.github.com/en/actions/creating-actions/creating-a-docker-container-action#example-using-a-private-action):

```yml
on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Hello World action step
        # docker://{host}/{image}:{tag}
        # See https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#example-using-the-github-packages-container-registry
        uses: docker://ghcr.io/axel-op/self-contained-dart-action:main
        id: hello
        with:
          who-to-greet: "you"
      # Use the output from the `hello` step
      - name: Get the output time
        run: echo "The time was ${{ steps.hello.outputs.time }}"
```

![](https://user-images.githubusercontent.com/49279289/154850348-3650dc94-a1d7-47ce-a721-6ac07247bf5f.png)
