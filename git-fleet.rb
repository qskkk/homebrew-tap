class GitFleet < Formula
  desc "Manage multiple Git repositories easily"
  homepage "https://github.com/qskkk/git-fleet"
  version "2.0.0"
  
  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v2.0.0/git-fleet-v2.0.0-darwin-amd64.tar.gz"
    sha256 "a58af628ec43773207bc29f365ccb8654bc47b45426744547e0ec64ce6de36f6"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v2.0.0/git-fleet-v2.0.0-darwin-arm64.tar.gz"
    sha256 "39b911a77d1103988ea345ad2bd41859c35db08325785d8458cbd6f2384ba31d"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v2.0.0/git-fleet-v2.0.0-linux-amd64.tar.gz"
    sha256 "f92712117783e4637e3e6b2b1a8788699ac72541f10c1406bf5e7393cd4d02c3"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v2.0.0/git-fleet-v2.0.0-linux-arm64.tar.gz"
    sha256 "109228cee99619903e257396466acc4985646b00bdbabd42b453248055a81c7c"
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
