cask "pants" do
  version "0.13.2"
  sha256 "a6f3231413ca1f793caffa621171a4b1a0158e7488cd0b5bb3e742cb99cc72a8"

  url "https://github.com/pantsbuild/scie-pants/releases/download/v#{version}/scie-pants-macos-aarch64",
      verified: "github.com/pantsbuild/"
  name "Pants"
  desc "Fast, scalable, user-friendly build system for codebases of all sizes"
  homepage "https://pantsbuild.org/"

  depends_on arch: :arm64

  binary "scie-pants-macos-aarch64", target: "pants"

  preflight do
    target = config.binarydir / "pants"
    if target.exist? && !target.symlink?
      opoo "replacing self-updated #{target}"
      target.delete
    end
  end

  postflight do
    if Quarantine.available?
      Quarantine.release!(download_path: caskroom_path.join(version,
                                                            "scie-pants-macos-aarch64"))
    end
  end
end
