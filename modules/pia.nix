{ config, lib, pkgs, ... }:

# Mostly translated from https://aur.archlinux.org/packages/private-internet-access-vpn

with lib;

let
  cfg = config.services.privateInternetAccess;
  
  # Create a package for python-pia
  pythonPia = pkgs.python3Packages.buildPythonPackage rec {
    pname = "python-pia";
    version = "3.4";
    
    src = pkgs.fetchFromGitHub {
      owner = "flamusdiu";
      repo = "python-pia";
      rev = "v${version}";
      sha256 = "472tfXswMrU34fjQJFFABSpT9dDikrH3+cNvFwqbomk="; # Replace with actual hash
    };
    
    propagatedBuildInputs = with pkgs.python3Packages; [
      docopt
      setuptools
    ];
    
    doCheck = false;
  };
  
  # Create a package for openvpn-update-resolv-conf
  updateResolvConf = pkgs.stdenv.mkDerivation {
    name = "openvpn-update-resolv-conf";
    
    src = pkgs.fetchFromGitHub {
      owner = "masterkorp";
      repo = "openvpn-update-resolv-conf";
      rev = "master"; # Use appropriate commit or tag
      sha256 = "INKdjtnhyu8qmYeCtCZPXoNLlUTKJofIXmh5qBSpPY4="; # Replace with actual hash
    };
    
    installPhase = ''
      mkdir -p $out/bin
      cp update-resolv-conf.sh $out/bin/update-resolv-conf
      chmod +x $out/bin/update-resolv-conf
    '';
  };
  
  # Download and extract VPN configurations
  vpnConfigs = pkgs.stdenv.mkDerivation rec {
    name = "pia-vpn-configs";
    version = "3.4";
    
    srcs = [
      (pkgs.fetchurl {
        url = "https://www.privateinternetaccess.com/openvpn/openvpn.zip";
        sha256 = "bc38427782aedc90cb65b322cd6f9d74af4e988cc5b3c884e43236ed7a5e4491";
      })
      (pkgs.fetchurl {
        url = "https://www.privateinternetaccess.com/openvpn/openvpn-strong.zip";
        sha256 = "38758f393590c51ec1566aba19beaed7c4fa8bd6f7c323f44ab00b9eb9fd7577";
      })
    ];
    
    nativeBuildInputs = [ pkgs.unzip ];
    
    unpackPhase = ''
      mkdir -p $out/etc/openvpn/client
      mkdir -p $out/etc/private-internet-access
      
      unzip ${builtins.elemAt srcs 0} "*.pem" "*.crt" -d $out/etc/openvpn/client
      unzip ${builtins.elemAt srcs 1} "*.pem" "*.crt" -d $out/etc/openvpn/client
      
      mkdir vpn-configs
      unzip ${builtins.elemAt srcs 0} "*.ovpn" -d vpn-configs
    '';
    
    buildPhase = ''
      cd vpn-configs
      touch $out/etc/private-internet-access/vpn-hosts.txt
      
      grep -Eo "\s(.*\.privacy\.network)\s" *.ovpn | \
        sed 's/_/ /g;s/.ovpn//;s/: /,/;s/[^ ]\+/\L\u&/g;s/\b\([a-z]\{2\}\)\s/\U&/gi' \
        >> $out/etc/private-internet-access/vpn-hosts.txt
      
      # Copy OVPN files to output
      cp *.ovpn $out/etc/openvpn/client/
    '';
    
    installPhase = ''
      # Create example config files
      cat > $out/etc/private-internet-access/login-example.conf << EOF
your-username
your-password
EOF

      cat > $out/etc/private-internet-access/pia-example.conf << EOF
[pia]
openvpn_auto_login = True

[configure]
apps = cm
hosts = US East, US West, Japan, UK London
port = 80
EOF
    '';
  };
  
  # Create vpn.sh script
  vpnSleepScript = pkgs.writeScriptBin "vpn-sleep" ''
    #!/bin/sh
    if [ "$1" == "pre" ]
    then
      ${pkgs.procps}/bin/killall openvpn
    fi
  '';

in {
  options.services.privateInternetAccess = {
    enable = mkEnableOption "Private Internet Access VPN service";
    
    autoStart = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to auto-start the VPN connection at boot";
    };
    
    region = mkOption {
      type = types.str;
      default = "US East";
      description = "PIA region to connect to";
    };
    
    username = mkOption {
      type = types.str;
      description = "PIA username";
    };
    
    password = mkOption {
      type = types.str;
      description = "PIA password";
    };
    
    port = mkOption {
      type = types.int;
      default = 1198;
      description = "Port to use for VPN connection";
    };
    
    protocol = mkOption {
      type = types.enum [ "udp" "tcp" ];
      default = "udp";
      description = "Protocol to use for VPN connection";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pythonPia
      vpnSleepScript
      pkgs.openvpn
    ];
    
    # Create login.conf file with credentials
    system.activationScripts.piaSetup = ''
      mkdir -p /etc/private-internet-access
      cat > /etc/private-internet-access/login.conf << EOF
${cfg.username}
${cfg.password}
EOF
      chmod 600 /etc/private-internet-access/login.conf
      chown root:root /etc/private-internet-access/login.conf
    '';
    
    # Copy configuration files
    system.activationScripts.piaConfigs = ''
      mkdir -p /etc/openvpn/client
      cp -r ${vpnConfigs}/etc/openvpn/client/* /etc/openvpn/client/
      cp -r ${vpnConfigs}/etc/private-internet-access/* /etc/private-internet-access/
      cp ${updateResolvConf}/bin/update-resolv-conf /etc/openvpn/update-resolv-conf
      chmod 755 /etc/openvpn/update-resolv-conf
    '';
    
    # Create systemd service for OpenVPN
    systemd.services.openvpn-pia = {
      description = "Private Internet Access VPN";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = mkIf cfg.autoStart [ "multi-user.target" ];
      
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.openvpn}/bin/openvpn --config /etc/openvpn/client/${builtins.replaceStrings [" "] ["_"] (lib.toLower cfg.region)}.ovpn --auth-user-pass /etc/private-internet-access/login.conf --script-security 2 --up /etc/openvpn/update-resolv-conf --down /etc/openvpn/update-resolv-conf";
        Restart = "always";
        RestartSec = "5s";
      };
    };
    
    # Add systemd sleep hook
    systemd.services.pia-sleep = {
      description = "PIA VPN sleep hook";
      wantedBy = [ "sleep.target" ];
      before = [ "sleep.target" ];
      
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${vpnSleepScript}/bin/vpn-sleep pre";
      };
    };
    
    # Add NetworkManager support if it's enabled
    # networking.networkmanager.packages = mkIf config.networking.networkmanager.enable [
    #   pythonPia
    # ];
  };
}