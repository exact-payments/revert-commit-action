# Github Revert Commit Action

This action reverts the given commit in the Github Action Workflow

## Inputs

## `commit-username`

**Optional** Username to execute commits to Github with

## `commit-email`

**Optional** Email to execute commits to Github with

## `github-token`

**Required** Github Action generated secret token for authentication purposes

## `is-push-enabled`

**Required** Parameter to enable or disable the push of the revert (defaulting to false for safety/testing).

## `should-log-diff`

**Optional** Boolean: true if git diff should be logged, false otherwise

## Outputs

## `was-commit-reverted`

Boolean: true if commit was revert, false otherwise.

## `reverted-commit-hash`

The commit hash of the commit that was reverted.

## Example usage
```
  # Revert commit (only should run on failure of some phase in a CI/CD pipeline)
  auto-revert-commit:
    needs: tests
    runs-on: ubuntu-latest
    if: always() && (needs.tests.result == 'failure')
    steps:
      - name: Automatic Commit Revert
        uses: 'tofu-apis/revert-commit-action@v0.0.32'
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          is-push-enabled: 'true'
```
