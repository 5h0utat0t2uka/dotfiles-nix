final: prev: {
  termscp = prev.termscp.overrideAttrs (old: {
    doCheck = false;
  });
}
