{ config, pkgs, inputs, lib, ... }:
{
	home.username = "fhasl";
	home.homeDirectory = "/home/fhasl";
	home.stateVersion = "25.11";
	imports = [ inputs.zen-browser.homeModules.beta ];
	programs.zen-browser = {
		enable = true;
	};
	gtk = {
		enable = true;
		gtk3.extraCss = ''
			@import url("file://${config.home.homeDirectory}/.config/gtk-3.0/gtk.css");
		'';
	};
}
