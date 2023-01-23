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

  version "0.2.0"
  if OS.mac?
    sha256 arm: "03feb5fcc36599df5071ea1b27c044935865c54aa3b1e8452f2baed65861416e",
           intel: "62d1a27cd0c5c9999f5148598820edcd19571b461605131faa7e8a39b8a0779e"
  else
    sha256 arm: "b581d6cd75ea803ad7419275044320fadc34257e55a066270abedbd630625c79",
           intel: "ec8aa3224eb3313023a9dd14cafb2f13f14ce3af3dc6d42ee44be9543b3c192b"
  end
  url "https://github.com/pantsbuild/scie-pants/releases/download/v#{version}/scie-pants-#{Utils.os}-#{Utils.arch}",
      verified: "https://github.com/pantsbuild/"

  name "Pants"
  desc "Fast, scalable, user-friendly build system for codebases of all sizes"
  homepage "https://pantsbuild.org"

  auto_updates true
  depends_on arch: [:arm64, :x86_64]

  binary Utils.binary, target: "pants"

  postflight do
    Quarantine.release!(download_path: "#{caskroom_path}/#{version}/#{Utils.binary}") if Quarantine.available?
  end
end
