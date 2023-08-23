cask "pants" do
  module Utils
    @@os = OS.mac? ? "macos" : OS.kernel_name.downcase
    @@arch = Hardware::CPU.arch.to_s.sub("arm64", "aarch64")
    def self.os
      @@os
    end
    def self.arch
      @@arch
    end
    def self.binary
      "scie-pants-#{@@os}-#{@@arch}"
    end
  end

  version "0.9.3"
  if OS.mac?
    sha256 arm: "f53991458ba57cb90ab77218a6d893327a8b1f4c08adcf8eb8da3c591dc89b18",
           intel: "ff7e3b4c04547c03e25e15945d3fe8a7c09162484bebd988c23b3edf541d87e4"
  else
    # Casks not supported on Linux: https://github.com/Linuxbrew/brew/issues/742
    # sha256 arm: "...",
    #        intel: "..."
  end
  url "https://github.com/pantsbuild/scie-pants/releases/download/v#{version}/scie-pants-#{Utils.os}-#{Utils.arch}",
      verified: "https://github.com/pantsbuild/"

  name "Pants"
  desc "Fast, scalable, user-friendly build system for codebases of all sizes"
  homepage "https://pantsbuild.org"

  depends_on arch: [:arm64, :x86_64]

  binary Utils.binary, target: "pants"

  preflight do
    target = config.binarydir / "pants"
    if target.exist? && !target.symlink?
      opoo "replacing self-updated #{target}"
      target.delete
    end
  end

  postflight do
    Quarantine.release!(download_path: "#{caskroom_path}/#{version}/#{Utils.binary}") if Quarantine.available?
  end
end
