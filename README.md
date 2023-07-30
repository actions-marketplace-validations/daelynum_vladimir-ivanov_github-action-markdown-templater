# Markdown Template Replacement GitHub Action

This GitHub action substitutes placeholders in your Markdown files with values from a JSON file. The action can either
check all files or just the ones that have been modified. The action works with placeholders in the format
`{{placeholder}}`.

## Usage

### Pre-requisites

1) A GitHub repository with some Markdown files that you want to substitute placeholders in.
2) A JSON file that contains the substitution values for the placeholders.

### Inputs

This action has four inputs which are passed in via the `with` keyword in your GitHub Actions workflow file.

| Input                       | Description                                                                                                                                                                                                                                        | Required | Default             |
|-----------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|---------------------|
| `template-file`             | The relative path in your repository to the JSON file that contains the substitution values.                                                                                                                                                       | Yes      | `'./template.json'` |
| `replacement-directory`     | The directory in your repository where the Markdown files you want to substitute placeholders in are located. The action will check all Markdown files in this directory.                                                                          | Yes      | `'./replacements'`  |
| `check-modified-files-only` | This input determines whether the action should check all files in the replacement-directory or only those that have been modified. It should be set to 'yes' if you only want to check modified files, anything else will be interpreted as 'no'. | Yes      | `'no'`              |
| `base-branch`               | The name of the base branch in your repository. The action will check for modified files between the current branch and this base branch. This input is only required if `check-modified-files-only` is set to 'yes'.                              | Yes      | `'master'`          |

## Example

This is a basic example of how to use this action:

```yaml
on:
  push:
    branches:
      - master

jobs:
  substitute-placeholders:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@master

      - uses: daelynum/vladimir-ivanov_github-action-markdown-templater@v1.0
        with:
          check-modified-files-only: yes
          base-branch: master
```