class Resin < Formula
  desc "Superfast CLI for the conventional commits commit format"
  homepage "https://github.com/failpark/resin/"
  version "1.7.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/failpark/resin/releases/download/v1.7.0/resin-aarch64-apple-darwin.tar.xz"
    sha256 "8666118c8e3cc3ad6e8ac43fdf26ca16c9d03c6ea25219472348369dc34fa5c0"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/failpark/resin/releases/download/v1.7.0/resin-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "df6a63dab13a4021622f03030e68be5ec298502f03b771ce092d520a409e81d3"
  end
  license "MPL-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "resin" if OS.mac? && Hardware::CPU.arm?
    bin.install "resin" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
