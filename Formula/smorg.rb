class Smorg < Formula
  include Language::Python::Virtualenv

  desc "Keyboard-driven terminal dashboard, one tab per connected integration"
  homepage "https://github.com/ldelvoye/smorg"
  url "https://files.pythonhosted.org/packages/source/s/smorg/smorg-1.4.2.tar.gz"
  sha256 "5cf32820c4bbbd87134d181a5f941c2957c8a645372c7462ce4dc889e3e3313e"
  license "MIT"

  depends_on "python@3.13"

  resource "requirements" do
    url "https://github.com/ldelvoye/smorg/releases/download/v1.4.2/requirements.txt"
    sha256 "73de64c48b60f8ea1a56ce12574f550b90dc54526488033648a30fc87d70ed22"
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
