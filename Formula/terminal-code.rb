class TerminalCode < Formula
  desc "VS Code inside your terminal"
  homepage "https://github.com/zenbu-labs/terminal-code"
  version "0.2.0"
  license "MIT"
  revision 2

  depends_on :linux

  if Hardware::CPU.arm?
    url "https://tode-releases.zenbu-labs.workers.dev/dl/stable/v0.2.0/tode-linux-arm64.tar.gz"
    sha256 "8b891e84aea13e57ae689e0fcf66594cac98f9a3da953c1fd87b5740bd08acd2"
  else
    url "https://tode-releases.zenbu-labs.workers.dev/dl/stable/v0.2.0/tode-linux-x64.tar.gz"
    sha256 "83ea56fd2a2fc02af6a19e97d361008a9af85388231130e037f6e73f4ac831fb"
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
