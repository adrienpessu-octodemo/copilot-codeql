# Usage of ubuntu-latest runner

## Description

This query detects when GitHub Actions workflows use `ubuntu-latest` instead of a specific Ubuntu version in the `runs-on` field of a job definition.

## Recommendation

Instead of using `ubuntu-latest`, specify an exact Ubuntu version like `ubuntu-22.04` or `ubuntu-20.04` to ensure reproducible builds and prevent unexpected breakage when GitHub updates the default Ubuntu runner version.

## Example

### Problematic Code

```yaml
jobs:
  build:
    runs-on: ubuntu-latest  # Avoid this
    steps:
      - uses: actions/checkout@v4
      - run: npm install
```

### Better Alternative

```yaml
jobs:
  build:
    runs-on: ubuntu-22.04  # Use specific version
    steps:
      - uses: actions/checkout@v4
      - run: npm install
```

## References

- [GitHub Actions: Choosing the runner for a job](https://docs.github.com/en/actions/using-jobs/choosing-the-runner-for-a-job)
- [GitHub Actions: Runner images](https://github.com/actions/runner-images)
