# claude-pet: a tiny creature on your Mac that shows what Claude Code is doing.
# https://github.com/r45635/claude-pet
#
# Homebrew installs the release archive; `claude-pet setup` then copies the app to
# ~/.claude-pet/app, wires it into Claude Code and starts it at login. From there the app
# updates itself (signed releases only), so the `claude-pet` command below runs that copy
# when it exists — brew's own copy is only what `setup` installs from.
class ClaudePet < Formula
  desc "Tiny creature on your Mac that shows what Claude Code is doing"
  homepage "https://github.com/r45635/claude-pet"
  url "https://github.com/r45635/claude-pet/releases/download/v0.5.6/claude-pet-aarch64-apple-darwin.tar.gz"
  sha256 "8ac0f795a95dca4d4176ce4678d651f4e1a0e4eb5fb80992c4088eea318ef720"
  license "MIT"

  depends_on arch: :arm64
  depends_on :macos

  def install
    libexec.install "claude-pet", "claude-pet-widget", "hooks"
    (bin/"claude-pet").write <<~SH
      #!/bin/sh
      # The installed app updates itself; prefer it, except to (re)install it.
      app="$HOME/.claude-pet/app/claude-pet"
      if [ "$1" != "setup" ] && [ -x "$app" ]; then exec "$app" "$@"; fi
      exec "#{libexec}/claude-pet" "$@"
    SH
  end

  def caveats
    <<~EOS
      Finish with:
        claude-pet setup
      It installs the app in ~/.claude-pet/app, wires it into Claude Code (your settings are
      backed up and merged, never overwritten) and starts the creature at login. It updates
      itself from then on.

      Before `brew uninstall claude-pet`, run:
        claude-pet uninstall
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{libexec}/claude-pet version")
  end
end
