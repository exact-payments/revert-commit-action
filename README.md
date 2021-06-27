# Github Revert Commit Action

This action reverts the given commit in the Github Action Workflow

## Inputs

## `git-branch`

**Required** The given commit's short hash to be reverted.

## Outputs

## `start-time`

The time this action started

## Example usage
```
- name: Revert Commit
  uses: tofu-apis/revert-commit-action@v0.0.1
```
