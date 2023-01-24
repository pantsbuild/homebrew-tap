#/bin/env bash

# A script to get the shas
version=$1

if [ "$version" == "" ]; then
  echo "Usage: get_shas.sh <version>"
  exit 1
fi

for os in macos linux; do
  for arch in aarch64 x86_64; do
    echo $(curl -Ls https://github.com/pantsbuild/scie-pants/releases/download/${version}/scie-pants-$os-$arch.sha256)
  done
done
