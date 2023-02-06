#/bin/env bash
set -eufo pipefail

# A script to update the version and shas
version=${1/v/}

if [ "$version" == "" ]; then
  echo "Usage: $0 <version> [<cask-name>]"
  exit 1
fi

case "${2:-pants}" in
    pants)
        cask=Casks/pants.rb
        repo=pantsbuild/scie-pants
        binary=scie-pants;;
    scie-jump)
        cask=Casks/scie-jump.rb
        repo=a-scie/jump
        binary=scie-jump;;
    *)
        echo "Unknown cask: $cask"
        exit 1;;
esac

inline=(-i)
if [ $(uname -o) == Darwin ]; then
    inline[1]=''
fi

for tuple in 'arm: aarch64' 'intel: x86_64'; do
  declare -a platform=($tuple)
  tag=${platform[0]}
  arch=${platform[1]}
  url="https://github.com/${repo}/releases/download/v${version}/${binary}-macos-${arch}.sha256"
  sha=$(curl -Ls ${url} | cut -f 1 -d ' ')
  sed -f - "${inline[@]}" "${cask}" <<EOF
s/version "[^"]*"/version "${version}"/
s/${tag} "[0-9a-f]*"/${tag} "${sha}"/
EOF
done

echo "Updated ${cask}, please review the changes then commit and push--thanks!"
