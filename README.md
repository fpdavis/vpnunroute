# vpnunroute
Scripts to automate the bypassing of VPN software for specified routes

This is based on scripts written by Eibgrad and extended by Dahosepipe... https://www.dd-wrt.com/phpBB2/viewtopic.php?t=291005&postdays=0&postorder=asc&start=0

This script is useful if you are running your router traffic through a Virtual Private Network (VPN) and need to automatically bypass the VPN for specified routes. This is especially necessary when Netflix, Amazon, Hulu, Yahoo and other streaming services block traffic even though the you may be accessing legitmit content for your country through a VPN exit node in your country (for example, a US user connecting to Netflix through a US vpn gateway attempting to access US content is still blocked). So we need a solution to selectively route this type of traffic (i.e. Netflix, Amazon, etc) traffic over the regular ISP network (non-vpn), while still sending all other traffic over the vpn tunnel. 

This would be much easier if the specified services released a list of hosts that customers could use to route around their VPNs.

This script allows for

     Multiple Netflix (and other) server domains
     Class D routes
     Class C routes... uncomment to catch a wider net of IPs 
     With a startup delay at boot time to allow network connections to complete 

It is necessary to remove any 'Policy Based Routing' commands (including comments!) from the VPN setup page in DD-WRT. 
It is necessary to have Services->Services->JFFS2 enabled.

For DD-WRT place Startup.sh in the Administrations->Commands->Commands edit box and click "Save Startup"

Modify the list of domains for selective class B or C routing as needed. This section should include host names used by your streaming service providers. It may be fine to leave this list as is and continue to fine tune it as necessary for the entire community.

Modify the list of domains for selective routing. WhatsMyIP.org is included in this list for testing purposes to confirm that the route exclusions are working properly. When visiting WhatsMyIP.org you should see the IP address assigned to your router by your internet provider. You may also need to add your DNS servers to this list. If you use any dynamic DNS service you will need to include exclusons for that service here as well.
