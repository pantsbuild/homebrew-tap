#/bin/env bash

# A script to update the version and shas
version=${1/v/}
cask=Casks/pants.rb

if [ "$version" == "" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

for tuple in 'arm: aarch64' 'intel: x86_64'; do
  declare -a platform=($tuple)
  tag=${platform[0]}
  arch=${platform[1]}
  url="https://github.com/pantsbuild/scie-pants/releases/download/v${version}/scie-pants-macos-${arch}.sha256"
  sha=$(curl -Ls ${url} | cut -f 1 -d ' ')
  sed -i '' "s/version \"[^\"]*\"/version \"${version}\"/" "${cask}"
  sed -i '' "s/${tag} \"[0-9a-f]*\"/${tag} \"${sha}\"/" "${cask}"
done

echo "Updated ${cask}, please review the changes then commit and push--thanks!"
