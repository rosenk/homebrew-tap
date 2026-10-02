class TerminalCode < Formula
  desc "VS Code inside your terminal"
  homepage "https://github.com/zenbu-labs/terminal-code"
  version "0.4.2"
  license "MIT"

  depends_on :linux

  if Hardware::CPU.arm?
    url "https://tode-releases.zenbu-labs.workers.dev/dl/stable/v0.4.2/tode-linux-arm64.tar.gz"
    sha256 "ab59e0aab3e1d171288699c3fbba508b5cf5f214f0c0db2ec42e35baf5396156"
  else
    url "https://tode-releases.zenbu-labs.workers.dev/dl/stable/v0.4.2/tode-linux-x64.tar.gz"
    sha256 "a8aae8c31c649781ee4fb3b174da08163830cc10e1dcee58465cc184a152cb25"
  end

  def install
    libexec.install Dir["*"]
    (bin/"tode").write <<~SH
      #!/bin/bash
      if [[ "${1:-}" == "--upgrade" ]]; then
        echo "terminal-code is managed by Homebrew; run: brew update && brew upgrade terminal-code" >&2
        exit 1
      fi
      export TODE_INSTALL_ROOT="#{libexec}"
      exec "#{libexec}/bin/tode" "$@"
    SH
    (bin/"tode").chmod 0755
  end

  def caveats
    <<~EOS
      terminal-code requires a terminal supporting the Kitty graphics protocol.
      If Electron reports missing libraries on Debian/Ubuntu, install them with:
        sudo apt-get install libnss3 libgtk-3-0 libgbm1
        sudo apt-get install libasound2t64  # or libasound2, depending on your release
    EOS
  end

  test do
    assert_match "Usage: tode", shell_output("#{bin}/tode --help")
  end
end
