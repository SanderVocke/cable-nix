(import (builtins.fetchTarball {
  url = "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  sha256 = "sha256:1mkdd75f462bb8a0429731422791443423522108191913495116";
}) {
  src = ./.;
}).defaultNix
