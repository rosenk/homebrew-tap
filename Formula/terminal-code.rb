class TerminalCode < Formula
  desc "VS Code inside your terminal"
  homepage "https://github.com/zenbu-labs/terminal-code"
  version "0.4.3"
  license "MIT"

  depends_on :linux

  if Hardware::CPU.arm?
    url "https://tode-releases.zenbu-labs.workers.dev/dl/stable/v0.4.3/tode-linux-arm64.tar.gz"
    sha256 "708edd5fe76ab2915418e88bc1efe56549dc3446a18645d194d673ae8d60801c"
  else
    url "https://tode-releases.zenbu-labs.workers.dev/dl/stable/v0.4.3/tode-linux-x64.tar.gz"
    sha256 "2e0b12321cb83c3b42b84516f29ba79618915314c459ac16275cc33e9c340051"
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
