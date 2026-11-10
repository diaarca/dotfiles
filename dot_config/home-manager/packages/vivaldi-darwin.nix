{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vivaldi-darwin";
  version = "8.3.4191.35";

  src = fetchurl {
    url = "https://downloads.vivaldi.com/stable-auto/Vivaldi.${finalAttrs.version}.universal.tar.xz";
    hash = "sha256-7NxToZUSRD/q6ggm6nPG9NePUdStIfJWHupLbOVa8n0=";
  };

  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;
  # Preserve the upstream code signature.
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    cp -R Vivaldi.app "$out/Applications/"
    runHook postInstall
  '';

  meta = {
    description = "Vivaldi browser for macOS";
    homepage = "https://vivaldi.com/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
