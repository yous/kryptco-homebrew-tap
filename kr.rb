class Kr < Formula
  desc "Krypton command-line client, daemon, and SSH integration"
  homepage "https://krypt.co"

  stable do
	  url "https://github.com/kryptco/kr.git", :tag => "2.4.13"
  end

  bottle do
    rebuild 2
    root_url "https://github.com/kryptco/bottles/raw/master"
    cellar :any_skip_relocation
    sha256 "c7ff5433486daa1654ec79806b0fcb9aafcc7dc052e166c5c68fa707ed49e2b4" => :el_capitan
    sha256 "2285ce4eebb3ee75ab9678676c15bf133d5a3d24d2b7a4dc4da31179de699462" => :sierra
    sha256 "b5278156184a7f50ed04790ecc7081be5c3f3d82c07da64d9683bf5db19472cb" => :high_sierra
    sha256 "8901218264de65fdbf2dc258f00557e456416f9f32fb9511956d546fea0a804a" => :mojave
    sha256 "8901218264de65fdbf2dc258f00557e456416f9f32fb9511956d546fea0a804a" => :catalina
    sha256 "8901218264de65fdbf2dc258f00557e456416f9f32fb9511956d546fea0a804a" => :big_sur	  
  end

  head do
    url "https://github.com/kryptco/kr.git"
  end

  option "with-no-ssh-config", "DEPRECATED -- export KR_SKIP_SSH_CONFIG=1 to prevent kr from changing ~/.ssh/config"

  depends_on "go" => :build
  depends_on "rust" => :build
  depends_on :xcode => :build if MacOS.version >= "10.12"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = Hardware::CPU.is_64_bit? ? "amd64" : "386"

    dir = buildpath/"src/github.com/kryptco/kr"
    dir.install buildpath.children

    system "mkdir", "-p", ENV["HOME"]

    ENV["PATH"] = ENV["HOME"] + "/.cargo/bin" + ":" + ENV["PATH"]
    ENV["PATH"] = ENV["HOME"] + "/Library/Caches/Homebrew/cargo_cache/bin" + ":" + ENV["PATH"]
    ENV["CARGO_HOME"] = ENV["HOME"] + "/.cargo"

    cd "src/github.com/kryptco/kr" do
      old_prefix = ENV["PREFIX"]
      ENV["PREFIX"] = prefix
      system "make", "install"
      ENV["PREFIX"] = old_prefix
    end
  end

  def caveats
    "kr is now installed! Run `kr pair` to pair with the Krypton app."
  end

  test do
    system "which kr && which krd"
  end
end
