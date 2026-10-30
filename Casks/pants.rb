cask "pants" do
  version "0.13.4"
  sha256 "687229e71caa059a7ce009f57c02dbb7795a05d050e1dbfa2d933d8ec3600d78"

  url "https://github.com/pantsbuild/scie-pants/releases/download/v#{version}/scie-pants-macos-aarch64"
  name "Pants"
  desc "Fast, scalable, user-friendly build system for codebases of all sizes"
  homepage "https://pantsbuild.org/"

  depends_on arch: :arm64

  binary "scie-pants-macos-aarch64", target: "pants"

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
