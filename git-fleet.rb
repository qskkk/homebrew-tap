class GitFleet < Formula
  desc "Manage multiple Git repositories easily"
  homepage "https://github.com/qskkk/git-fleet"
  version "2.4.2"
  
  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v2.4.2/git-fleet-v2.4.2-darwin-amd64.tar.gz"
    sha256 "0f83404012bd72522f16f8819f81dc917aef9ce0e694cf080fb26a375433307a"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v2.4.2/git-fleet-v2.4.2-darwin-arm64.tar.gz"
    sha256 "13f1eb437a2f86547dd418efab8eb9e0ccd9696605f30742f4285c12e96c3e25"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v2.4.2/git-fleet-v2.4.2-linux-amd64.tar.gz"
    sha256 "efed0e916c4d9f38fc129cbd742ce4cc6e13b9105f2873b966a51792fae9861f"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v2.4.2/git-fleet-v2.4.2-linux-arm64.tar.gz"
    sha256 "86f90646a9f42e6e428772feda57107123db2d69a6024210410f2f9be18a4bcf"
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
