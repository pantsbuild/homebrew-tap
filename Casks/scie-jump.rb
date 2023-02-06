cask "scie-jump" do
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
      "scie-jump-#{@@os}-#{@@arch}"
    end
  end

  version "0.10.0"
  if OS.mac?
    sha256 arm: "b19511bb715aa948e221a53ad5be37945647be3c77bf06b85e0269cb1366b340",
           intel: "e1793daf1b253a5e7c1c445a3620099e4c1ae3424dd9095f9b1d6f1a5b14f325"
  end
  url "https://github.com/a-scie/jump/releases/download/v#{version}/scie-jump-#{Utils.os}-#{Utils.arch}",
      verified: "https://github.com/a-scie/"

  name "scie-jump"
  desc "A Self Contained Interpreted Executable Launcher."
  homepage "https://github.com/a-scie/jump"

  depends_on arch: [:arm64, :x86_64]

  binary Utils.binary, target: "scie-jump"

  preflight do
    target = config.binarydir / "scie-jump"
    if target.exist? && !target.symlink?
      opoo "replacing self-updated #{target}"
      target.delete
    end
  end

  postflight do
    Quarantine.release!(download_path: "#{caskroom_path}/#{version}/#{Utils.binary}") if Quarantine.available?
  end
end
