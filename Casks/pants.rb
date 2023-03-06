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

  version "0.5.4"
  if OS.mac?
    sha256 arm: "b672866745f5607ca4f5c8bc21ef12daddd12f63b6e58a10012c7739333e9a40",
           intel: "19cf9bb247ec3c9f42c26b9ce3c62cf3701a1bbc4e6fd93950cb810790f3b662"
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
