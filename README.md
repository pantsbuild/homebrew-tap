# Pants tap for Homebrew

To install `pants` using [`brew`](https://brew.sh/)

```bash
brew install pantsbuild/tap/pants
```

To update `pants`

```bash
brew update && brew upgrade pants
```

## Tap Updates

Upon release of a new `scie-pants`, the [update-homebrew-tap](https://github.com/pantsbuild/scie-pants/blob/14c9998fc188a9965a6d13923dad40983f061954/.github/workflows/release.yml#L155) step should run and kick off this tap's release workflow.

To do this manually, run:

```bash
gh workflow run release.yml \
    --raw-field "tag=v{{ A.B.C }}" \
    --repo pantsbuild/homebrew-tap
```
