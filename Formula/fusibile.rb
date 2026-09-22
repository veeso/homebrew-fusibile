class Fusibile < Formula
  desc "Mount remote file systems locally via FUSE or Dokany"
  homepage "https://github.com/remotefs-rs/remotefs-rs-fuse"
  license "MIT"
  version "1.0.1"

  on_macos do
    # The Apple Silicon build vendors Samba, which links gnutls/libunistring
    # dynamically. The Intel build has no SMB support at all, see caveats below.
    on_arm do
      depends_on "gnutls"
      depends_on "libunistring"
      url "https://github.com/remotefs-rs/remotefs-rs-fuse/releases/latest/download/fusibile-v1.0.1-aarch64-apple-darwin.tar.gz"
      sha256 "2e56524121bb7b7370178b4b90b6e5c639df62fa3213f562d8571a7a66da5df1"
    end
    on_intel do
      url "https://github.com/remotefs-rs/remotefs-rs-fuse/releases/latest/download/fusibile-v1.0.1-x86_64-apple-darwin.tar.gz"
      sha256 "0de9293667e2b88647f5895ff5eb2c1fe7862e78d317f1b342e2ee3f1f3f4591"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/remotefs-rs/remotefs-rs-fuse/releases/latest/download/fusibile-v1.0.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1a54f43456bf92c608407be0a2ea336fd1191f716553dd586c025bbe28c0f5b4"
    end
    on_intel do
      url "https://github.com/remotefs-rs/remotefs-rs-fuse/releases/latest/download/fusibile-v1.0.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b12931a872c69d4be8e506b4b0d71d3427cefe3986d43054e747c470dddf31c9"
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
