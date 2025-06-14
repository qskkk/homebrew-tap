class GitFleet < Formula
  desc "Manage multiple Git repositories easily"
  homepage "https://github.com/qskkk/git-fleet"
  
  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v0.4.2/git-fleet-v0.4.2-darwin-amd64.tar.gz"
    sha256 "3048bc964e53c43095c99667c9fcd9682dac6ca148cbec3a0527f155d1897a98"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v0.4.2/git-fleet-v0.4.2-darwin-arm64.tar.gz"
    sha256 "8cd141485f09abc9b9e4c45fad91071a4b3afef900fc10d4619c095d077a08f4"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v0.4.2/git-fleet-v0.4.2-linux-amd64.tar.gz"
    sha256 "3e046672daf86de5af45e95a8b8b5f78486f20e56b5ed6ae2ce858247a643bc6"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v0.4.2/git-fleet-v0.4.2-linux-arm64.tar.gz"
    sha256 "5c779a592c0d195a9eefb318efaf1b9fb94d97b9aee2e6a0145aac1a7043d132"
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
