class DockerControl < Formula
  desc "a CLI tool to control ik docker stack"
  homepage "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control"
  version "2.0.10"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control/releases/download/2.0.10/docker-control-aarch64-apple-darwin.tar.xz"
    sha256 "20ab1ccb44fb4a0e2b458f1969bd7d5e6ad3b21bee1da6094176bfc0fd2d5567"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control/releases/download/2.0.10/docker-control-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9140cb3a91edc2057eba06dab5be531eca838566d511787d857a23655cad1972"
    end
    if Hardware::CPU.intel?
      url "https://github.com/INTERLIGENT-kommunzieren-GmbH/docker-control/releases/download/2.0.10/docker-control-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f6fdb28060166560412eff501686895da320ed85da1a6be480c3dbb9bd03a9a0"
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
    ingress_volumes_dir = Pathname.new("#{Dir.home}/.config/docker-control/ingress/volumes")
    ingress_volumes_dir.mkpath

    # Copy ingress volume assets from share to the stable config directory
    # Overwrites existing files to ensure updates are propagated
    share_ingress_volumes = prefix/"share/docker-control/ingress/volumes"
    if share_ingress_volumes.exist?
      # Using FileUtils.cp_r with source/. will copy contents and overwrite
      FileUtils.cp_r(share_ingress_volumes/".", ingress_volumes_dir, verbose: true, remove_destination: false)
    end
  end
end
