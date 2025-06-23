class GitFleet < Formula
  desc "Manage multiple Git repositories easily"
  homepage "https://github.com/qskkk/git-fleet"
  version "2.4.0"
  
  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v2.4.0/git-fleet-v2.4.0-darwin-amd64.tar.gz"
    sha256 "afb904aefae998a6ceaafcf03b77d6cf0614688179cb6b26a0f2ef18d22e2a78"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v2.4.0/git-fleet-v2.4.0-darwin-arm64.tar.gz"
    sha256 "b59b2b2828e5acd2bf4f0a311ab7902df8295db4c2559c73b233493a515963d7"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v2.4.0/git-fleet-v2.4.0-linux-amd64.tar.gz"
    sha256 "cd8366df87e52d437ddab97f90c30efc7e04608e4fa127c5bae7dab5d10a49a2"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v2.4.0/git-fleet-v2.4.0-linux-arm64.tar.gz"
    sha256 "e64a0e906a9c117fabef174a26ff39ef0a825db7728eb7bca8d8165915815c70"
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
