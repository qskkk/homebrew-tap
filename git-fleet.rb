class GitFleet < Formula
  desc "Manage multiple Git repositories easily"
  homepage "https://github.com/qskkk/git-fleet"
  version "1.2.0"
  
  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v1.2.0/git-fleet-v1.2.0-darwin-amd64.tar.gz"
    sha256 "d2966e753bfd3086e9b160da50525ab185261117acfd2237242c804a64dd4479"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v1.2.0/git-fleet-v1.2.0-darwin-arm64.tar.gz"
    sha256 "a2824c4bfa38361795f9928f31c4682836f7955a1a13e2bd3da8a3b96868f99a"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v1.2.0/git-fleet-v1.2.0-linux-amd64.tar.gz"
    sha256 "8a360f415fcdcaad592f7167b0b4d50cc3665c833feb414204617a9b250faca0"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v1.2.0/git-fleet-v1.2.0-linux-arm64.tar.gz"
    sha256 "9c866092109949f96f70d73ac7e3db98cab3e02e1d2e7795e2c312a79e9bdc4d"
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
