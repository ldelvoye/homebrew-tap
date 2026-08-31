class Smorg < Formula
  include Language::Python::Virtualenv

  desc "Keyboard-driven terminal dashboard, one tab per connected integration"
  homepage "https://github.com/ldelvoye/smorg"
  url "https://files.pythonhosted.org/packages/f0/1c/6602ae74d15a9093f90514c6e0e05c6bf9c802c8362d8f310348d08bd33f/smorg-1.4.3.tar.gz"
  sha256 "0f68ee97d20cbca09e5963a6cdeff4e4109aebc5ce51e2b96e2de750930029fe"
  license "MIT"

  depends_on "python@3.13"

  resource "requirements" do
    url "https://github.com/ldelvoye/smorg/releases/download/v1.4.3/requirements.txt"
    sha256 "75dddb5103f5b632cf4150a69421812814da1af73f71c14857e24c21dd1f461e"
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
