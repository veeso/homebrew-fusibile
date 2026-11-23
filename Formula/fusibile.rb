class Fusibile < Formula
  desc "Mount remote file systems locally via FUSE or Dokany"
  homepage "https://github.com/veeso/remotefs-rs"
  license "MIT"
  version "1.2.0"

  on_macos do
    # The Apple Silicon build vendors Samba, which links gnutls/libunistring
    # dynamically. The Intel build has no SMB support at all, see caveats below.
    on_arm do
      depends_on "gnutls"
      depends_on "libunistring"
      url "https://github.com/veeso/remotefs-rs/releases/download/fusibile-v1.2.0/fusibile-v1.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "ee87ac5182ae79c20819b61eedf1bb4604b78e78e6f84e99de12237e96dee8e2"
    end
    on_intel do
      url "https://github.com/veeso/remotefs-rs/releases/download/fusibile-v1.2.0/fusibile-v1.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "655eabca79ae7e2d6bf437c6963179262ca436fb865a05cd0cfa3cf4fc45a01e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/veeso/remotefs-rs/releases/download/fusibile-v1.2.0/fusibile-v1.2.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "32d6b85b0dd0d34151296600d24a5c4eb05f5c36c4a641eb4c3fc0b0f7b5dce9"
    end
    on_intel do
      url "https://github.com/veeso/remotefs-rs/releases/download/fusibile-v1.2.0/fusibile-v1.2.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "bab32d081b7b094df61284feebc6dd6cc82e2ff63bb82e1e6f55140510c2773d"
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
