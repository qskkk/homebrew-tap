class GitFleet < Formula
  desc "Manage multiple Git repositories easily"
  homepage "https://github.com/qskkk/git-fleet"
  version "2.6.3"
  
  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v2.6.3/git-fleet-v2.6.3-darwin-amd64.tar.gz"
    sha256 "a090f4d14ea9850e6e650ed30d9058d0e26ce182b363e6147a1606119bd173fa"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v2.6.3/git-fleet-v2.6.3-darwin-arm64.tar.gz"
    sha256 "9c77f134f62ec956028945ebfac502cbac813ea9080f9532e168c778fce03aee"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v2.6.3/git-fleet-v2.6.3-linux-amd64.tar.gz"
    sha256 "70387ee3aa0f8cb991da358df2ef085cb3dd419c400e2c27ca0ff481afef3be3"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v2.6.3/git-fleet-v2.6.3-linux-arm64.tar.gz"
    sha256 "d463373e0ce44a26966d2082ac84fc7a6813e107b3d730aca954781054f28cf9"
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
