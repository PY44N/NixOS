{config, pkgs, ...}:

{
home.packages = with pkgs ; [
	  font-awesome # waybar styling requires this
];

  programs.waybar = {
  	enable = true;
  	settings = {
  	mainBar = {
  		  #layer = "top";
  		  #position = "top";
  		  height = 24;
  		  #output = [
  		  #  "eDP-1"
  		  #  "HDMI-A-1"
  		  #];
  		  modules-left = [ "hyprland/workspaces"];#, "custom/media" ];
  		  #modules-center = [ "sway/window" "custom/hello-from-waybar" ];
  		  modules-right = ["mpd" "temperature" "cpu" "memory" "network" "pulseaudio" "battery" "tray" "clock"];

		  temperature = {
			    thermal-zone = 2;
			    hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
			    critical-threshold = 80;
			    format-critical = "{icon} {temperatureC}°C";
			    format = "{icon} {temperatureC}°C";
			    format-icons = ["" "" ""];
			};

			cpu = {
			    format = " {usage}%";
#        "tooltip": false
			};

			memory = {
			    format = " {}%";
			};

			network = {
			    # "interface": "wlp2*", // (Optional) To force the use of this interface
			    format-wifi = "{essid} ({signalStrength}%) ";
			    format-ethernet = " {ifname}";
			    tooltip-format = " {ifname} via {gwaddr}";
			    format-linked = " {ifname} (No IP)";
			    format-disconnected = "Disconnected ⚠ {ifname}";
			    format-alt = " {ifname}: {ipaddr}/{cidr}";
			};

			pulseaudio = {
			        scroll-step = 5;# // %, can be a float
			        format = "{icon} {volume}% {format_source}";
			        format-bluetooth = " {icon} {volume}% {format_source}";
			        format-bluetooth-muted = "  {icon} {format_source}";
			        format-muted = "🔇 {format_source}";
			        format-source = " {volume}%";
			        format-source-muted = "";
			        format-icons = {
			#//            "headphone": "",
			#//            "hands-free": "",
			#//            "headset": "",
			#//            "phone": "",
			#//            "portable": "",
			#//            "car": "",
			            default = ["" "" ""];
			        };
			        on-click = "pavucontrol";
			        on-click-right = "foot -a pw-top pw-top";
			    };

			    battery = {
			        states = {
			            #// "good": 95,
			            warning = 30;
			            critical = 15;
			        };
			        format = "{icon} {capacity}%";
			        format-charging = " {capacity}%";
			        format-plugged = " {capacity}%";
			        format-alt = "{icon} {time}";
			        #// "format-good": "", // An empty format will hide the module
			        #// "format-full": "",
			        format-icons = ["" "" "" "" ""];
			    };

			    tray = {
			    	spacing = 10;	
			    };

			    clock = {
			        #// "timezone": "America/New_York",
			        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
			        #//"format-alt": "{:%Y-%m-%d}"
			        format = "{:%a %m-%d-%Y %H:%M}";
			        #//"format": "{:%Y-%m-%d %h:%M}"
			    };
  		};	
  	};

  	style = ''

* {
  /* `otf-font-awesome` is required to be installed for icons */
  font-family: "Noto Sans CJK KR Regular";
  font-size: 13px;
  min-height: 0;
}

window#waybar {
  background: transparent;
  /*    background-color: rgba(43, 48, 59, 0.5); */
  /*    border-bottom: 3px solid rgba(100, 114, 125, 0.5); */
  color: #ffffff;
  transition-property: background-color;
  transition-duration: .5s;
}

window#waybar.hidden {
  opacity: 0.2;
}

#waybar.empty #window {
  background-color: transparent;
}

#workspaces {
}

#window {
  margin: 2;
  padding-left: 8;
  padding-right: 8;
  background-color: rgba(0,0,0,0.3);
  font-size:14px;
  font-weight: bold;
}

button {
  /* Use box-shadow instead of border so the text isn't offset */
  box-shadow: inset 0 -3px transparent;
  /* Avoid rounded borders under each button name */
  border: none;
  border-radius: 0;
}

/* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
button:hover {
  background: inherit;
  border-top: 2px solid #c9545d;
}

#workspaces button {
  padding: 0 4px;
  /*    background-color: rgba(0,0,0,0.3); */
}

#workspaces button:hover {
}

#workspaces button.focused {
  /*    box-shadow: inset 0 -2px #c9545d; */
  background-color: rgba(0,0,0,0.3);
  color:#c9545d;
  border-top: 2px solid #c9545d;
}

#workspaces button.urgent {
  background-color: #eb4d4b;
}

#mode {
  background-color: #64727D;
  border-bottom: 3px solid #ffffff;
}

#clock,
#battery,
#cpu,
#memory,
#disk,
#temperature,
#backlight,
#network,
#pulseaudio,
#wireplumber,
#custom-media,
#tray,
#mode,
#idle_inhibitor,
#scratchpad,
#mpd {
  margin: 2px;
  padding-left: 4px;
  padding-right: 4px;
  background-color: rgba(0,0,0,0.3);
  color: #ffffff;
}

/* If workspaces is the leftmost module, omit left margin */
.modules-left > widget:first-child > #workspaces {
  margin-left: 0;
}

/* If workspaces is the rightmost module, omit right margin */
.modules-right > widget:last-child > #workspaces {
  margin-right: 0;
}

#clock {
  font-size:14px;
  font-weight: bold;
}

#battery icon {
  color: red;
}

#battery.charging, #battery.plugged {
  color: #ffffff;
  background-color: #26A65B;
}

@keyframes blink {
  to {
    background-color: #ffffff;
    color: #000000;
  }
}

#battery.warning:not(.charging) {
  background-color: #f53c3c;
  color: #ffffff;
  animation-name: blink;
  animation-duration: 0.5s;
  animation-timing-function: linear;
  animation-iteration-count: infinite;
  animation-direction: alternate;
}

#battery.critical:not(.charging) {
  background-color: #f53c3c;
  color: #ffffff;
  animation-name: blink;
  animation-duration: 0.5s;
  animation-timing-function: linear;
  animation-iteration-count: infinite;
  animation-direction: alternate;
}

label:focus {
  background-color: #000000;
}

#network.disconnected {
  background-color: #f53c3c;
}

#temperature.critical {
  background-color: #eb4d4b;
}

#idle_inhibitor.activated {
  background-color: #ecf0f1;
  color: #2d3436;
}

#tray > .passive {
  -gtk-icon-effect: dim;
}

#tray > .needs-attention {
  -gtk-icon-effect: highlight;
  background-color: #eb4d4b;
}

/*

window#waybar.solo {
background-color: #FFFFFF;
}

window#waybar.termite {
background-color: #3F3F3F;
}

window#waybar.chromium {
background-color: #000000;
border: none;
}
 */

  	'';
  };
}
