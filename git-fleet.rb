class GitFleet < Formula
  desc "Manage multiple Git repositories easily"
  homepage "https://github.com/qskkk/git-fleet"
  version "2.2.0"
  
  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v2.2.0/git-fleet-v2.2.0-darwin-amd64.tar.gz"
    sha256 "64bf769234fc3f9ef0bc604ba0dd27435983d4da27822671fcb40142e6fb67b3"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v2.2.0/git-fleet-v2.2.0-darwin-arm64.tar.gz"
    sha256 "001532efac05185fbbc36584181eb1436b26b90ce9a0bdc9e7e7807bfaf54593"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/qskkk/git-fleet/releases/download/v2.2.0/git-fleet-v2.2.0-linux-amd64.tar.gz"
    sha256 "69d080e6a5ff1fc740bb37d1df35e8c722aba7e6d97459228b47934a0e9606ac"
    else
      url "https://github.com/qskkk/git-fleet/releases/download/v2.2.0/git-fleet-v2.2.0-linux-arm64.tar.gz"
    sha256 "dfbf8e64b69ba14a1a61ffd800ad6467f50de338c811e570a669ccd437354dd8"
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
