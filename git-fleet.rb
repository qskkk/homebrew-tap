class GitFleet < Formula
  desc "Manage multiple Git repositories easily"
  homepage "https://github.com/qskkk/git-fleet"
  
  if Hardware::CPU.intel?
    url "https://github.com/qskkk/git-fleet/releases/download/v0.4.1/git-fleet-v0.4.1-darwin-amd64.tar.gz"
    sha256 "59c4f32a77a0bf5af4b48ea5ab93c4b7e3a33e2ac52f6812fa6b7ce6f462fe3d"
  else
    url "https://github.com/qskkk/git-fleet/releases/download/v0.4.1/git-fleet-v0.4.1-darwin-arm64.tar.gz"
    sha256 "0ca219abe08d6bc4903f94a6f994d37f47d9cd7125837933556aebca5b5e56c9"
  end

  license "GNU"

  def install
    bin.install "gf"
  end

  test do
    system "#{bin}/gf", "--version"
  end
end
