#
# Homebrew formula for Atika Bridge Desktop.
#
# Install:
#   brew tap SSafet/atika
#   brew install SSafet/atika/atika-bridge-desktop
#
# A formula (CLI binary) rather than a cask (.app bundle) — the daemon lands
# as a bare executable in /opt/homebrew/bin and Gatekeeper does not gate it.
# Only quarantined downloads and .app bundles are gated by Gatekeeper.
#
class AtikaBridgeDesktop < Formula
  desc "Local daemon that connects this machine to Atika"
  homepage "https://atika.ai"
  url "https://registry.npmjs.org/@atika-ai/bridge-desktop/-/bridge-desktop-0.1.3.tgz"
  sha256 "025ec68c17289eca6a6b3c6a6d0f14a5ca090bb783b82ac0b1bb2e87b4780878"
  license "Apache-2.0"

  depends_on "node@22"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  service do
    run [opt_bin/"atika-bridge-desktop", "connect"]
    keep_alive true
    log_path var/"log/atika-bridge-desktop.log"
    error_log_path var/"log/atika-bridge-desktop.err.log"
    environment_variables PATH: std_service_path_env
  end

  test do
    assert_match "atika-bridge-desktop", shell_output("#{bin}/atika-bridge-desktop --help")
  end
end
