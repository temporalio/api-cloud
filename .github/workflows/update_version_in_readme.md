name: update version in readme

on:
  push
  <!-- pull_request: -->
  <!--   branches: -->
  <!--     - main -->

jobs:
  embed-code:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          persist-credentials: false
          fetch-depth: 0
          ref: refs/heads/${{ github.head_ref }}
      - uses: tokusumi/markdown-embed-code@main
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          message: "synchronizing Readme"
          silent: true
