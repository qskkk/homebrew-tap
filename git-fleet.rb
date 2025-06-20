class GitFleet < Formula
  desc "Manage multiple Git repositories easily"
  homepage "https://github.com/qskkk/git-fleet"
  version "2.3.0"
  
  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v2.3.0/git-fleet-v2.3.0-darwin-amd64.tar.gz"
    sha256 "139a9ff77f670ab94e31087056290cd10fbbace65289850a3b57021314d56296"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v2.3.0/git-fleet-v2.3.0-darwin-arm64.tar.gz"
    sha256 "c602d0bc9de7f7aeb708ac10b856086d71d07c5be912146ec966b7b8756c5b66"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v2.3.0/git-fleet-v2.3.0-linux-amd64.tar.gz"
    sha256 "062634b27c913daa298aec4bf38bc8001f4057edebbfa5fe8c05cbf441d6de19"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v2.3.0/git-fleet-v2.3.0-linux-arm64.tar.gz"
    sha256 "cb3cf2d7825f5070250e64c575bc5a8020bca601b16491ed3ccc3bae2e2ff4e0"
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
