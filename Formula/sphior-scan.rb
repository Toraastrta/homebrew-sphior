# SPHIOR CODE CLI (@sphior/scan) for Homebrew.
# Update `url` and `sha256` together when a new version is published to npm.
class SphiorScan < Formula
  desc "Deterministic security scanner for secrets, CWE patterns and taint flows"
  homepage "https://sphior.com/code"
  url "https://registry.npmjs.org/@sphior/scan/-/scan-0.1.11.tgz"
  sha256 "e96135257690e87fa46ae0f04ba8e01db4141f90e5159905cd26b8fbdb75911b"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"app.js").write <<~JS
      const key = "AKIAABCDEFGHIJKLMNOP";
    JS
    # A finding at or above --fail-on exits 1; stdout is SARIF when it is not a terminal.
    output = shell_output("#{bin}/sphior-scan run #{testpath} --fail-on high", 1)
    assert_match "AWS Access Key ID", output
  end
end
