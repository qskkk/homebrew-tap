class GitFleet < Formula
  desc "Manage multiple Git repositories easily"
  homepage "https://github.com/qskkk/git-fleet"
  version "2.4.1"
  
  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v2.4.1/git-fleet-v2.4.1-darwin-amd64.tar.gz"
    sha256 "e3423bb5cb230356d2b5aab6941f4d0eff46fb440ab213c2ea3d2a52471ca948"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v2.4.1/git-fleet-v2.4.1-darwin-arm64.tar.gz"
    sha256 "e4a60714ba9934b3af22b990e32d5205d6b29a62dc87ba736037932b2f3d0f4c"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v2.4.1/git-fleet-v2.4.1-linux-amd64.tar.gz"
    sha256 "15576e779a18e405078a4439f350ccd3340ce83b49c2c8b3ea32e4e7e20d7781"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v2.4.1/git-fleet-v2.4.1-linux-arm64.tar.gz"
    sha256 "01b42236d4ca2c39e704d8e3eb50018840c2b4eb9d6845080b8a4964eeae973f"
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
