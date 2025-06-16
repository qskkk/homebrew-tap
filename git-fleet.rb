class GitFleet < Formula
  desc "Manage multiple Git repositories easily"
  homepage "https://github.com/qskkk/git-fleet"
  version "1.1.0"
  
  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v1.1.0/git-fleet-v1.1.0-darwin-amd64.tar.gz"
    sha256 "621bfdd35dbeef2d6dbe7f6a62e44a68bd98386fe5fb417f4002073c57287f35"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v1.1.0/git-fleet-v1.1.0-darwin-arm64.tar.gz"
    sha256 "51c3d031454077daa00ad220098e2ba54bd8af3a5237198358cc1d51b3911c16"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v1.1.0/git-fleet-v1.1.0-linux-amd64.tar.gz"
    sha256 "4b720630c8e38096029e1efb0aa42151a114e0a4480ea9333112790ed4e1823b"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v1.1.0/git-fleet-v1.1.0-linux-arm64.tar.gz"
    sha256 "5ed7f344fc642b570c59a43f967c834d3e3a6021bc0a8573f8f41026a3bc890f"
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
