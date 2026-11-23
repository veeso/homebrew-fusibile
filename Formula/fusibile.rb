class Fusibile < Formula
  desc "Mount remote file systems locally via FUSE or Dokany"
  homepage "https://github.com/veeso/remotefs-rs"
  license "MIT"
  version "1.2.1"

  on_macos do
    # The Apple Silicon build vendors Samba, which links gnutls/libunistring
    # dynamically. The Intel build has no SMB support at all, see caveats below.
    on_arm do
      depends_on "gnutls"
      depends_on "libunistring"
      url "https://github.com/veeso/remotefs-rs/releases/download/v1.2.1/fusibile-v1.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "88ab2dd11d8e9f960911bbded0900b826d5ed4b7ef0b88516e5694ca6c1572a5"
    end
    on_intel do
      url "https://github.com/veeso/remotefs-rs/releases/download/v1.2.1/fusibile-v1.2.1-x86_64-apple-darwin.tar.gz"
      sha256 "39f08f3fff975dd57c6616293dd5233390f05e96165c5c0a6af3a981d9b933c8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/veeso/remotefs-rs/releases/download/v1.2.1/fusibile-v1.2.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4c2772efc5ca53a52beff5418edebca192fbd70c8b54c943c9fd7a466171e7cc"
    end
    on_intel do
      url "https://github.com/veeso/remotefs-rs/releases/download/v1.2.1/fusibile-v1.2.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "45abcfc4a14a4128105fefe92047e6012bad621963c93813bfe40019574878d9"
    end
  end

  def install
    bin.install "fusibile"
  end

  def caveats
    on_macos do
      <<~CAVEATS
        fusibile needs macFUSE, which Homebrew cannot install as a formula
        dependency. Install it first with "brew install --cask macfuse".
        macOS will ask you to allow the system extension in System Settings ->
        Privacy & Security the first time you mount anything.
      CAVEATS
      on_intel do
        <<~CAVEATS
          This build has no SMB support: vendoring Samba fails to link on Intel
          macOS. Build from source with "cargo install fusibile --locked" if you
          need it.
        CAVEATS
      end
    end
    on_linux do
      <<~CAVEATS
        fusibile needs the setuid fusermount3 binary from your distribution's
        fuse3 package, which Homebrew cannot provide. Install it with your
        system package manager, e.g. "sudo apt-get install fuse3".
      CAVEATS
    end
  end

  test do
    assert_match "fusibile", shell_output("#{bin}/fusibile --help")
  end
end
