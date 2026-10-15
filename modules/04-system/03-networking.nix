/*
  @menu
  displayname = "Networking";
  icon = "network-wireless-symbolic";
  order = 30;
  description = "NetworkManager and firewall";
  category = "System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-networking = { config, pkgs, ... }: {

    # @option widget = "switch"; label = "NetworkManager"; group = "Network";
    networking.networkmanager.enable = true;

    # @option widget = "switch"; label = "Wi-Fi power saving"; group = "Wi-Fi"; visibleWhen.path = "networking.networkmanager.enable"; visibleWhen.equals = true; description = "Disable to fix stuttering on some Wi-Fi cards.";
    networking.networkmanager.wifi.powersave = true;

    # @option widget = "list"; label = "DNS servers"; group = "DNS"; description = "Static resolvers; leave empty to use DHCP.";
    networking.nameservers = [ ];

    # @option widget = "text"; label = "Domain"; group = "DNS"; description = "Local DNS search domain.";
    networking.domain = "";

    # @option widget = "text"; label = "Ethernet MAC address"; group = "Ethernet"; hidden = true; description = "Spoof the MAC of wired devices, e.g. 02:00:00:00:00:01.";
    networking.networkmanager.ethernet.macAddress = "stable";

    # @option widget = "switch"; label = "Predictable interface names"; group = "Ethernet"; hidden = true; description = "Use names like enp1s0 instead of eth0.";
    networking.usePredictableInterfaceNames = true;

    # @option widget = "switch"; label = "Firewall"; group = "Firewall";
    networking.firewall.enable = true;

    # @option widget = "switch"; label = "Log refused connections"; group = "Firewall"; visibleWhen.path = "networking.firewall.enable"; visibleWhen.equals = true; hidden = true;
    networking.firewall.logRefusedConnections = true;

    # @option widget = "list"; label = "Open TCP ports"; group = "Firewall"; visibleWhen.path = "networking.firewall.enable"; visibleWhen.equals = true;
    networking.firewall.allowedTCPPorts = [ ];

    # @option widget = "list"; label = "Open UDP ports"; group = "Firewall"; visibleWhen.path = "networking.firewall.enable"; visibleWhen.equals = true;
    networking.firewall.allowedUDPPorts = [ ];

    # @option widget = "list"; label = "Trusted interfaces"; group = "Firewall"; visibleWhen.path = "networking.firewall.enable"; visibleWhen.equals = true;
    networking.firewall.trustedInterfaces = [ "virbr0" ];

    # Static host entries: networking.hosts = { "192.168.1.10" = [ "nas" ]; };
    # Add them here when the machine needs them.

  };

}
