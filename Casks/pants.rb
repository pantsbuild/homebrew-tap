cask "pants" do
  version "0.13.2"
  sha256 "a6f3231413ca1f793caffa621171a4b1a0158e7488cd0b5bb3e742cb99cc72a8"

  url "https://github.com/pantsbuild/scie-pants/releases/download/v#{version}/scie-pants-macos-aarch64"
  name "Pants"
  desc "Fast, scalable, user-friendly build system for codebases of all sizes"
  homepage "https://pantsbuild.org/"

  depends_on arch: :arm64

  binary "scie-pants-macos-aarch64", target: "pants"

  preflight_steps do
    run "/usr/bin/find",
        args:           ["{{HOMEBREW_PREFIX}}/bin/pants", "-depth", "0", "-type", "f", "-delete"],
        must_succeed:   false,
        print_stderr:   false,
        writable_paths: ["{{HOMEBREW_PREFIX}}/bin"]
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
