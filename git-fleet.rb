class GitFleet < Formula
  desc "Manage multiple Git repositories easily"
  homepage "https://github.com/qskkk/git-fleet"
  version "2.1.0"
  
  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v2.1.0/git-fleet-v2.1.0-darwin-amd64.tar.gz"
    sha256 "a6cfaa1646ce8805e06ae05b17353bc0e8e1d7e0f01d977a3734786e8956daa4"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v2.1.0/git-fleet-v2.1.0-darwin-arm64.tar.gz"
    sha256 "8e0bc9405192a60e13d030f1410e3a494ef3f46d2efff7cf84790df56db11cda"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v2.1.0/git-fleet-v2.1.0-linux-amd64.tar.gz"
    sha256 "c7ee8d22dcc963136fee40834329dd5813254e893954dddf9251a337ef8d1cac"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v2.1.0/git-fleet-v2.1.0-linux-arm64.tar.gz"
    sha256 "8d2b858e6e6bfc18c3087c0a5d2b7023ec9f5991732237ffe094c510005c80f7"
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
