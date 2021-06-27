# Github Revert Commit Action

This action reverts the given commit in the Github Action Workflow

## Inputs

## `github-token`

**Required** Github Action generated secret token for authentication purposes

## Outputs

## `start-time`

The time this action started

## Example usage
```
- uses: actions/checkout@v2
  with:
    # Use 0 to ensure we get the full history for all branches/tags
    # █     ██  █████  ██████  ███    ██ ██ ███    ██  ██████  ██ ██ ██ 
    # ██     ██ ██   ██ ██   ██ ████   ██ ██ ████   ██ ██       ██ ██ ██ 
    # ██  █  ██ ███████ ██████  ██ ██  ██ ██ ██ ██  ██ ██   ███ ██ ██ ██ 
    # ██ ███ ██ ██   ██ ██   ██ ██  ██ ██ ██ ██  ██ ██ ██    ██          
    #  ███ ███  ██   ██ ██   ██ ██   ████ ██ ██   ████  ██████  ██ ██ ██
    # IMPORTANT: Without this, the git revert will delete ALL files!
    # Make sure to add the fetch depth and set it to 0!
    fetch-depth: 0
- name: Revert Commit
  uses: tofu-apis/revert-commit-action@v0.0.9
  with:
    github-token: $${{ secrets.GITHUB_TOKEN }}
```
