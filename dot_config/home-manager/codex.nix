{ ... }:

{
  programs.codex = {
    enable = true;
    package = null; # Installed in packages.nix with the other development tools.
    context = ./codex/AGENTS.md;
    mutableSettings = true;

    settings = {
      model = "gpt-6.1-sol";
      model_reasoning_effort = "medium";

      tui = {
        status_line = [
          "model-with-reasoning"
          "current-dir"
          "five-hour-limit"
          "git-branch"
        ];
        status_line_use_colors = true;
        theme = "github";
      };
    };
  };
}
