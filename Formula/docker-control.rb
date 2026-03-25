class DockerControl < Formula
  desc "a CLI tool to control ik docker stack"
  homepage "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control"
  version "2.1.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control/releases/download/2.1.3/docker-control-aarch64-apple-darwin.tar.xz"
    sha256 "278357cfe530142f0f9ec6fdde2ba367dbecd9ccf0130f0a4d93af7abfda59bc"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control/releases/download/2.1.3/docker-control-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9b437fc435b03c12de60d9c154f281876b5715b495c294c37e2f9d0e90368ff6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control/releases/download/2.1.3/docker-control-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "af1cf90809e68944ed96b678edf822f9e38832c0d6b9eb963b5f7ee5e4c61004"
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
