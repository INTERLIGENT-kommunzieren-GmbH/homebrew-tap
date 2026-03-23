class DockerControl < Formula
  desc "a CLI tool to control ik docker stack"
  homepage "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control"
  version "2.0.6"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control/releases/download/2.0.6/docker-control-aarch64-apple-darwin.tar.xz"
    sha256 "16cd45370aa7947d00bc6a7be0985d09df295694c00c595a276a44084895577b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control/releases/download/2.0.6/docker-control-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4b3ad15a86101520d88815d33625e2e209b76cb7b89e66a1ea0b7db685a0b334"
    end
    if Hardware::CPU.intel?
      url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control/releases/download/2.0.6/docker-control-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4b8f5fb72208bad9a08de02c52b4be44a2b6f9c6142957d2ac57905aacd26c9d"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {
      "docker-control": [
        "dc2",
      ],
    },
    "aarch64-unknown-linux-gnu": {
      "docker-control": [
        "dc2",
      ],
    },
    "x86_64-unknown-linux-gnu":  {
      "docker-control": [
        "dc2",
      ],
    },
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "docker-control" if OS.mac? && Hardware::CPU.arm?
    bin.install "docker-control" if OS.linux? && Hardware::CPU.arm?
    bin.install "docker-control" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
