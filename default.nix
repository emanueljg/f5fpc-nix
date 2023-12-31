 { stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, buildFHSEnv
, buildFHSUserEnv
, lib
}: 

let 
  file = "linux_f5cli.x86_64.deb"; 
  pkg = stdenv.mkDerivation rec {
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
      install -m755 -D "usr/local/lib/F5Networks/f5fpc_x86_64" $out/bin/f5fpc
      runHook postInstall
    '';
  };
in buildFHSEnv {
  name = "f5fpc";
  targetPkgs = _: [ pkg ];
  extraBuildCommands = ''
    cp -r "${pkg}/usr" $out
  '';
  runScript = "f5fpc";
}

