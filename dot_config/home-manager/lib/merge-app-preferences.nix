{ lib, pkgs }:
let
  pgrep = if pkgs.stdenv.hostPlatform.isDarwin then "/usr/bin/pgrep" else "${pkgs.procps}/bin/pgrep";
  jsonFormat = pkgs.formats.json { };
in
name: process: path: settings:
lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  if ${pgrep} -ix ${lib.escapeShellArg process} > /dev/null; then
    echo "Skipping ${name} preferences: quit ${name} and rebuild to apply them." >&2
  else
    ${lib.hm.generators.mkImpureConfigMerger {
      inherit pkgs path;
      format = "json";
      empty = "{}";
      jqOperation = "$dynamic * $static";
      staticSettings = jsonFormat.generate "${name}-preferences.json" settings;
      mode = "600";
    }}
  fi
''
