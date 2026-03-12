{
	description = "bruh";
	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		zen-browser = {
			url = "github:0xc000022070/zen-browser-flake";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.home-manager.follows = "home-manager";
		};
		nixos-hardware = {
			url = "github:NixOS/nixos-hardware";
		};
		fcitx5-lotus = {
			url = "github:LotusInputMethod/fcitx5-lotus";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		spicetify = {
			url = "github:Gerg-L/spicetify-nix";
		}
	};
	outputs = inputs@{ self, nixpkgs, home-manager, nixos-hardware, fcitx5-lotus, spicetify-nix, ... }: {
		nixosConfigurations.amalthea = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./configuration.nix
				nixos-hardware.nixosModules.lenovo-thinkpad-t480
				inputs.fcitx5-lotus.nixosModules.fcitx5-lotus
				home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						extraSpecialArgs = { inherit inputs; };
						users.fhasl = import ./home.nix;
						backupFileExtension = "backup";
					};
				}
			];
		};
	};
}
