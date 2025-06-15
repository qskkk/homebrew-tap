class GitFleet < Formula
  desc "Manage multiple Git repositories easily"
  homepage "https://github.com/qskkk/git-fleet"
  
  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v1.0.0/git-fleet-v1.0.0-darwin-amd64.tar.gz"
    sha256 "bd3d701a8b26524eef42ff6209f80a28b1e6959aed11990f2a0c733350ef060c"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v1.0.0/git-fleet-v1.0.0-darwin-arm64.tar.gz"
    sha256 "aaa415c9905d41905dbc6e79ebe00ad7b58ad5bf370563fcf591c112f7fddaf9"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v1.0.0/git-fleet-v1.0.0-linux-amd64.tar.gz"
    sha256 "c495fceda0d2c75410fa48e00f3468f731156b760a73180ab9383f52dec2a2d4"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v1.0.0/git-fleet-v1.0.0-linux-arm64.tar.gz"
    sha256 "f7007fb804dc0959b12988d5c6a785b53719cf9017fcf89aaded34ab72ba93b5"
    end
  end

  license "GNU"

  def install
    bin.install "gf"
  end

  test do
    system "#{bin}/gf", "--version"
  end
end
