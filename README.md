Pants tap for Homebrew
======================

To install `pants` using [`brew`](https://brew.sh/)

    brew install pantsbuild/tap/pants

To update `pants`

    brew update && brew upgrade pants


Tap development
---------------

For maintainers.

#### Update the version of `scie-pants`

To update the `pants` cask in this tap when there is a newer version of `scie-pants` available:

    ./bump_version.sh <version>

This will update the `Casks/pants.rb` file with the new version and the sha sums which are fetched from the release page on Github.

You may verify that the updated cask is working by applying it directly from file locally with:

    brew install --cask ./Casks/pants.rb
