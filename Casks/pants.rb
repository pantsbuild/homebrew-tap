cask "pants" do
  version "0.13.2"

  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos-aarch64", linux: "linux-#{arch}"

  artifact = "scie-pants-#{os}"

  sha256 arm:          "a6f3231413ca1f793caffa621171a4b1a0158e7488cd0b5bb3e742cb99cc72a8",
         arm64_linux:  "b40b60e50e9cb69e13029e100be995fbfdb3b3799ef1ccff60a81177f78e6b82",
         x86_64_linux: "74a1e53bc50d6ef6ce1bc67bd9f7b48e549505e0a2453ad4d5ccbc72b0bea874"

  on_macos do
    depends_on arch: :arm64
  end
  on_linux do
    depends_on arch: [:arm64, :x86_64]
  end

  url "https://github.com/pantsbuild/scie-pants/releases/download/v#{version}/#{artifact}",
      verified: "github.com/pantsbuild/"
  name "Pants"
  desc "Fast, scalable, user-friendly build system for codebases of all sizes"
  homepage "https://pantsbuild.org/"

  binary artifact, target: "pants"

  preflight_steps do
    if_path_exists("pants", base: :binarydir) do
      remove "pants", base: :binarydir
    end
  end

  postflight_steps do
    on_macos do
      remove "{{temp}}/{{token}}-{{version}}-quarantine-status"
      run "/usr/bin/xattr",
          args:         ["-p", "com.apple.quarantine", "{{caskroom_path}}/{{version}}/scie-pants-macos-aarch64"],
          must_succeed: false,
          print_stderr: false,
          stdout_path:  "{{temp}}/{{token}}-{{version}}-quarantine-status"

      if_path_exists "{{temp}}/{{token}}-{{version}}-quarantine-status" do
        run "/usr/bin/xattr",
            args: ["-d", "com.apple.quarantine", "{{caskroom_path}}/{{version}}/scie-pants-macos-aarch64"]
        remove "{{temp}}/{{token}}-{{version}}-quarantine-status"
      end
    end
  end
end
