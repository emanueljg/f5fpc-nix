 { stdenv
, fetchurl
, autoPatchelfHook
, dpkg
}: let file = "linux_f5cli.x86_64.deb"; in stdenv.mkDerivation rec {
  name = "f5fpc";

  src = fetchurl {
    url = "https://iconnect.global.volvocars.biz/public/share/${file}";
    sha256 = "sha256-XJNuRBP6ZUImm6IXHoJfuIwvGwl/HSkEQ19dgmQjpok=";
  };

  sourceRoot = ".";
  unpackCmd = "${dpkg}/bin/dpkg-deb -x ${src} .";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall
    cp -r . $out
    # chmod +x "$out/usr/local/lib/F5Networks/f5fpc_x86_64"
    # chmod +x "$out/usr/local/lib/F5Networks/SSLVPN/svpn_x86_64"
    # install -m755 -D "usr" $out
    install -m755 -D "usr/local/lib/F5Networks/f5fpc_x86_64" $out/bin/f5fpc
    # install -m755 -D "usr/local/lib/F5Networks/SSLVPN/svpn_x86_64" $out/bin/svpn
    runHook postInstall
  '';

}

