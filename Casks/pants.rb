cask "pants" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos-aarch64", linux: "linux-#{arch}"

  artifact = "scie-pants-#{os}"

  version "0.13.2"

  on_macos do
    sha256 "a6f3231413ca1f793caffa621171a4b1a0158e7488cd0b5bb3e742cb99cc72a8"

    depends_on arch: :arm64

    postflight do
      Quarantine.release!(download_path: caskroom_path.join(version, artifact)) if Quarantine.available?
    end
  end

  on_linux do
    sha256 x86_64_linux: "74a1e53bc50d6ef6ce1bc67bd9f7b48e549505e0a2453ad4d5ccbc72b0bea874",
           arm64_linux:  "b40b60e50e9cb69e13029e100be995fbfdb3b3799ef1ccff60a81177f78e6b82"

    depends_on arch: [:arm64, :x86_64]
  end

  url "https://github.com/pantsbuild/scie-pants/releases/download/v#{version}/#{artifact}",
      verified: "github.com/pantsbuild/"
  name "Pants"
  desc "Fast, scalable, user-friendly build system for codebases of all sizes"
  homepage "https://pantsbuild.org/"

  binary artifact, target: "pants"

  preflight do
    target = config.binarydir / "pants"
    if target.exist? && !target.symlink?
      opoo "replacing self-updated #{target}"
      target.delete
    end
  end
end
