class GitFleet < Formula
  desc "Manage multiple Git repositories easily"
  homepage "https://github.com/qskkk/git-fleet"
  
  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v0.4.3/git-fleet-v0.4.3-darwin-amd64.tar.gz"
    sha256 "1769e231a005f73612ed80fba4edb7514e3c42ade1b4bf7efd4eb28427f65bac"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v0.4.3/git-fleet-v0.4.3-darwin-arm64.tar.gz"
    sha256 "f6e19f3ccad23ec1d6f3da532c66a599d8df96a435b78fcf40200f09798b6f80"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v0.4.3/git-fleet-v0.4.3-linux-amd64.tar.gz"
    sha256 "17cac4251fe0fd036c00f1f8d850539dba80255fc1631a3234aeadfa676f6e94"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v0.4.3/git-fleet-v0.4.3-linux-arm64.tar.gz"
    sha256 "6220ddafeb254f5be0e23b99fbd66860b297b3e87020bc44482352d86438cd12"
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
