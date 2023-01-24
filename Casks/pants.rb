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

  version "0.2.1"
  if OS.mac?
    sha256 arm: "79ba5efeb606b1d3dc13d810003a7c99d418e6e977ec65860ba6ad131f747928",
           intel: "c5bb6b99319a374b1e97dba17558e981c6e050b77823ad57ec0211a0efc366ce"
  else
    sha256 arm: "ab062b11b18e96e1877c69946a807eaa2ac2ca8e96902a377e055bfc3684a77b",
           intel: "f70a78a2470f909d42f6b306a7e96e270d1eaabeb19778007c20e2e13ba5c696"
  end
  url "https://github.com/pantsbuild/scie-pants/releases/download/v#{version}/scie-pants-#{Utils.os}-#{Utils.arch}",
      verified: "https://github.com/pantsbuild/"

  name "Pants"
  desc "Fast, scalable, user-friendly build system for codebases of all sizes"
  homepage "https://pantsbuild.org"

  depends_on arch: [:arm64, :x86_64]

  binary Utils.binary, target: "pants"

  postflight do
    Quarantine.release!(download_path: "#{caskroom_path}/#{version}/#{Utils.binary}") if Quarantine.available?
  end
end
