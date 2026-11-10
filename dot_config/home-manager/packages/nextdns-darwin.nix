{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nextdns-app";
  version = "2.1.4";

  src = fetchurl {
    url = "https://storage.googleapis.com/nextdns_macos/NextDNS-${finalAttrs.version}.dmg";
    hash = "sha256-rnCp457OimmejRVGyBTK7LeFbBsNmLA0MQHCiJIE9sQ=";
  };

  nativeBuildInputs = [ _7zz ];
  sourceRoot = "NextDNS";
  dontConfigure = true;
  dontBuild = true;
  # Preserve the upstream code signature and entitlements.
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    cp -R NextDNS.app "$out/Applications/"
    runHook postInstall
  '';

  meta = {
    description = "NextDNS menu bar app for macOS (requires macOS 15.6 or later)";
    homepage = "https://nextdns.io/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
