class Smorg < Formula
  include Language::Python::Virtualenv

  desc "Keyboard-driven terminal dashboard, one tab per connected integration"
  homepage "https://github.com/ldelvoye/smorg"
  url "https://files.pythonhosted.org/packages/source/s/smorg/smorg-1.4.1.tar.gz"
  sha256 "1ef545b4850c73f2260a6492d808fec7496cde2d43a8c4c43e9ebd1d510bbe30"
  license "MIT"

  depends_on "python@3.13"

  resource "requirements" do
    url "https://github.com/ldelvoye/smorg/releases/download/v1.4.1/requirements.txt"
    sha256 "773e7a0ed255c173e7866d5e8b3c482fba2e7725f5ca47a1d6bf63cbd5145c1d"
  end

  def install
    virtualenv_create(libexec, "python3.13")
    # The venv is created without pip, so drive the brewed Python's pip at it.
    # Direct pip rather than the pip_install helper: the helper builds from
    # source, and hash-pinned wheels are the point here.
    pip = [Formula["python@3.13"].opt_bin/"python3.13", "-m", "pip", "--python=#{libexec}/bin/python"]
    resource("requirements").stage do
      system(*pip, "install", "--require-hashes", "-r", "requirements.txt")
    end
    system(*pip, "install", "--no-deps", ".")
    bin.install_symlink libexec/"bin/smorg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smorg --version")
  end
end
