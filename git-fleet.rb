class GitFleet < Formula
  desc "Manage multiple Git repositories easily"
  homepage "https://github.com/qskkk/git-fleet"
  version "1.0.1"
  
  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v1.0.1/git-fleet-v1.0.1-darwin-amd64.tar.gz"
    sha256 "5747a5d6c410719c4562436ff14f08ec7932c6efe7b7ca366d4504b2ef60add2"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v1.0.1/git-fleet-null-darwin-arm64.tar.gz"
    sha256 "b4304dc309ced7bb3d115ba45c84e94a20d4f1b0e8c03af17269230846d02dcf"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/null/git-fleet-null-linux-amd64.tar.gz"
    sha256 "23671b5a5a0edc187444a33f63218cc7d13adc1345c349a745e52d9df26470ef"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/null/git-fleet-null-linux-arm64.tar.gz"
    sha256 "0213f3a0109273f876223e940339b800a89d285fe04a9aee18b7b8d841d6969e"
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
