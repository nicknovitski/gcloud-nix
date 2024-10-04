{
  description = "";

  outputs = _: {
    shellModules.default = {
      imports = [ ./shell-modules ];
    };
  };
}
