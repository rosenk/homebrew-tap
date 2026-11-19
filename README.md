# Homebrew Tap

Homebrew formulae maintained by rosenk.

## terminal-code

Install [terminal-code](https://github.com/zenbu-labs/terminal-code) on Linux:

```bash
brew trust rosenk/tap
brew install rosenk/tap/terminal-code
```

Homebrew refuses to load formulae from non-official taps until you trust them,
so the `brew trust` step is needed once per machine.

Updates are managed exclusively by Homebrew:

```bash
brew update
brew upgrade terminal-code
```

The formula is checked daily against terminal-code's official stable release
manifest and updated automatically when a new version is published.
