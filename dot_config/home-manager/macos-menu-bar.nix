{
  lib,
  pkgs,
  user,
  ...
}:
let
  capture = builtins.fromJSON (builtins.readFile ./macos-menu-bar.json);
  byHostPreferences =
    pkgs.runCommand "menu-bar-host-preferences" { nativeBuildInputs = [ pkgs.python3 ]; }
      ''
        python3 - ${./macos-menu-bar.json} "$out" <<'PY'
        import base64
        import json
        import pathlib
        import shlex
        import sys

        capture = json.loads(pathlib.Path(sys.argv[1]).read_text())
        output = pathlib.Path(sys.argv[2])
        output.mkdir()
        commands = ["set -euo pipefail"]
        commands.append('major=$(/usr/bin/sw_vers -productVersion | /usr/bin/cut -d. -f1)')
        for domain, settings in capture["byHost"].items():
            for key, value in settings.items():
                if isinstance(value, dict) and set(value) == {"dataBase64"}:
                    value = base64.b64decode(value["dataBase64"], validate=True)
                if isinstance(value, bytes):
                    kind, argument = "-data", value.hex()
                elif isinstance(value, bool):
                    kind, argument = "-bool", str(value).lower()
                elif isinstance(value, int):
                    kind, argument = "-int", str(value)
                elif isinstance(value, float):
                    kind, argument = "-float", str(value)
                elif isinstance(value, str):
                    kind, argument = "-string", value
                else:
                    raise ValueError(f"Unsupported menu-bar preference: {domain}/{key}")
                command = shlex.join([
                    "/usr/bin/defaults", "-currentHost", "write", domain, key, kind, argument
                ])
                if kind == "-data":
                    captured_major = capture["macOSVersion"].split(".")[0]
                    commands.extend([
                        'if [[ "$major" == ' + shlex.quote(captured_major) + ' ]]; then',
                        command,
                        'else',
                        shlex.join(["echo", f"Skipping {domain} layout: captured on macOS {captured_major}; restore it manually on other major versions."]) + " >&2",
                        'fi',
                    ])
                else:
                    commands.append(command)
        (output / "apply.sh").write_text("\n".join(commands) + "\n")
        PY
      '';
in
{
  system.defaults = {
    NSGlobalDomain = capture.global;
    menuExtraClock = capture.clock;
    universalaccess = capture.accessibility;
    CustomUserPreferences = capture.userPreferences;
  };

  # Write through CFPreferences for the destination host, without copying host UUIDs.
  # The two layout archives are private macOS formats; restoration is best effort.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    /usr/bin/sudo -H -u ${lib.escapeShellArg user.username} -- \
      ${pkgs.bash}/bin/bash ${byHostPreferences}/apply.sh
  '';
}
