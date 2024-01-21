{
  description =
    "THIS IS AN AUTO-GENERATED FILE. PLEASE DON'T EDIT IT MANUALLY.";
  inputs = {
    auto-minor-mode = {
      flake = false;
      owner = "joewreschnig";
      repo = "auto-minor-mode";
      type = "github";
    };
    gcmh = {
      flake = false;
      type = "git";
      url = "https://gitlab.com/koral/gcmh";
    };
  };
  outputs = { ... }: { };
}
