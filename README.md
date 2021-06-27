# Github Revert Commit Action

This action reverts the given commit in the Github Action Workflow

## Inputs

## `github-token`

**Required** Github Action generated secret token for authentication purposes

## `git-branch`

**Required** The name of the git branch to revert commit from.

## Outputs

## `start-time`

The time this action started

## Example usage
```
- name: Revert Commit
  uses: tofu-apis/revert-commit-action@v0.0.1
  with:
    github-token: $${{ secrets.GITHUB_TOKEN }}
```
