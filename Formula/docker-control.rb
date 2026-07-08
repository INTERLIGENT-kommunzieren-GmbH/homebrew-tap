class DockerControl < Formula
  desc "a CLI tool to control ik docker stack"
  homepage "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control"
  version "2.3.13"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control/releases/download/2.3.13/docker-control-aarch64-apple-darwin.tar.xz"
    sha256 "8bae090e60688507b736d93863179320e6e28b0810e125a019e156d90f058f91"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control/releases/download/2.3.13/docker-control-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f96263c31ad9a54ef16a843bc133f3832d6f51b13385eaa9851753719a45fa1e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control/releases/download/2.3.13/docker-control-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "438932b691c8f0307959dae79a91c34670fcbf4ef3eb869c3c7e663a1a2558c1"
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
