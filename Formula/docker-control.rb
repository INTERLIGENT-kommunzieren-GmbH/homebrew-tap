class DockerControl < Formula
  desc "a CLI tool to control ik docker stack"
  homepage "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-plugin"
  version "2.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-plugin/releases/download/2.0.0/docker-control-aarch64-apple-darwin.tar.xz"
      sha256 "39c81d74102b7e73d1f7f39af99adb9dcca60ebd97e92438dd087d0973c1802b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-plugin/releases/download/2.0.0/docker-control-x86_64-apple-darwin.tar.xz"
      sha256 "9f7137cd4813f73251217bce2c44afd4ce5118edd872257feccad3d6e985bf2b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-plugin/releases/download/2.0.0/docker-control-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "372fa1ed85a4ebd659e6710fdba0919e28c5f6d5418b63d42f126163808032cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-plugin/releases/download/2.0.0/docker-control-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b89c1c8e02630cd446e6ae6c88748517c4dbdf2252c837a23b65f32b702af498"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "docker-control" if OS.mac? && Hardware::CPU.intel?
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
