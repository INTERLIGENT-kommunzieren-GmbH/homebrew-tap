class DockerControl < Formula
  desc "a CLI tool to control ik docker stack"
  homepage "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control"
  version "2.0.13"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control/releases/download/2.0.13/docker-control-aarch64-apple-darwin.tar.xz"
    sha256 "476bfc55adf2d3d75b674fcdbd3bbd021d394f9e795bb2622375f495e8d2cda7"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control/releases/download/2.0.13/docker-control-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9817d26db41fa1e93c3a17bcb8894986eb601357ca24ce922caa6c6bfc01b6f7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control/releases/download/2.0.13/docker-control-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ead01bddd95eabe539e4496cd6492f025cbceac47aefc13102785e79c9c07c19"
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

  def post_install
    ingress_volumes_dir = HOMEBREW_PREFIX/"etc/docker-control/ingress/volumes"
    ingress_volumes_dir.mkpath

    # Copy ingress volume assets from share to the stable config directory
    # Overwrites existing files to ensure updates are propagated
    share_ingress_volumes = prefix/"share/docker-control/ingress/volumes"
    if share_ingress_volumes.exist?
      # Using cp_r with source/. will copy contents and overwrite
      cp_r(share_ingress_volumes/".", ingress_volumes_dir, verbose: true, remove_destination: false)
    end
  end
end
