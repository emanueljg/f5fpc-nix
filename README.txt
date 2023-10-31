f5fpc-nix
----------

A flake for the F5 VPN Client.

Access f5fpc:
	nix run github:emanueljg/f5fpc-nix
Run start script:
	nix run github:emanueljg/f5fpc-nix#f5fpc-start
Stop f5fpc:
	nix run github:emanueljg/f5fpc-nix -- --stop

If you don't want to install this flake on your NixOS system (or if you're running a different distro), you can
very easily create shell aliases for these commands too.

NOTE: If getting the error "bwrap: Can't chdir to <path>: <error>":
  1. cd to a directory you know your own, for example your homedir. Run the program again.
  2. If this doesn't work, make sure your nix invocation runs nixos-unstable and not nixos-23.05.
     More specifically, this nixpkgs commit is what is required for f5fpc to work:
     https://github.com/NixOS/nixpkgs/commit/c945723356c17f0570217dedefac645721d6fb70 
     It has to do with f5fpc being packaged with a FHS container (buildFHSEnv). 
     Before this commit, we can't call this package with sudo (which we need to do to allow it to edit
     our network configuration). 
     Hopefully nixos-23.11 fixes this error.
