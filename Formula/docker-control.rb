class DockerControl < Formula
  desc "a CLI tool to control ik docker stack"
  homepage "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control"
  version "2.1.9"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control/releases/download/2.1.9/docker-control-aarch64-apple-darwin.tar.xz"
    sha256 "d9027997a878423d70696cf84c23d37f1df9a6026e9576c645aec8f6334f2586"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control/releases/download/2.1.9/docker-control-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b7fae7527851bdbe32734646db84a71fc17228b4dfe8ed5b88204f7fbd62c1df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control/releases/download/2.1.9/docker-control-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c314d5b1ba2a1ad20898a862b64002c1c41bdb8bac140e0767537a48ff3dd545"
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
