SCRIPT_DIR="/jffs"
SCRIPT="$SCRIPT_DIR/add-routes.wanup"

mkdir -p $SCRIPT_DIR

echo Creating $SCRIPT

cat << "EOF" > $SCRIPT
#!/bin/sh

ROUTES="/jffs/routes"
echo Appending to $ROUTES
touch $ROUTES
chmod 666 $ROUTES

# dd-wrt selective domain routing
WAN_GW="$(nvram get wan_gateway)"

# list domains for selective class B or C routing
for domain in \
"netflix.com" \
"ichnaea.netflix.com" \
"movies.netflix.com" \
"www.netflix.com" \
"nflxext.com" \
"cdn1.nflxext.com" \
"nflximg.com" \
"nflxvideo.net" \
"ipv4_1.cxl0.c145.sjc002.ix.nflxvideo.net" \
"www3-ext-s.nflximg.net" \
"so-s.nflximg.net" \
"assets.nflxext.com" \
"customerevents.netflix.com" \
"amazonaws.com" \
"ipv4_1-cxl0-c241.1.atl001.ix.nflxvideo.net" \
"ipv4_1-cxl0-c239.1.atl001.ix.nflxvideo.net" \
"ipv4_1-cxl0-c260.1.atl001.ix.nflxvideo.net" \
"ipv4_1-cxl0-c156.1.atl001.ix.nflxvideo.net" \
"ipv4_1-lagg0-c085.1.atl001.ix.nflxvideo.net" \
"ipv4_1-lagg0-c076.1.atl001.ix.nflxvideo.net" \
"movies.netflix.com" \
"cbp-us.nccp.netflix.com" \
"movies1.netflix.com" \
"movies2.netflix.com" \
"netflix.com" \
"moviecontrol.netflix.com" \
"api-global.netflix.com" \
"api-us.netflix.com" \
"api.netflix.com" \
"www2.netflix.com" \
"redirects-us.nccp.netflix.com" \
"redirects-eu.nccp.netflix.com" \
"nccp-nrdp-31.cloud.netflix.net" \
"ios.nccp.netflix.com" \
"atv.nccp.netflix.com" \
"uiboot.netflix.com" \
"signup.netflix.com" \
"iphone-api.netflix.com" \
"nccp-fuji.netflix.com" \
"nccp-fuji.cloud.netflix.net" \
"nccp-nato.cloud.netflix.net" \
"nccp-nato.netflix.com" \
"mcdn.netflix.com" \
"secure.netflix.com" \
"htmltvui-api.netflix.com" \
"nccp-ps3.netflix.com" \
"nccp-ps3.cloud.netflix.net" \
"api-user.netflix.com" \
"mobile-api.netflix.com" \
"api-public.netflix.com" \
"dvd.netflix.com" \
"fls-na.amazon.com" \
"atv-ps.amazon.com" \
"avodassets-a.akamaihd.net" \
"s3.lvlt.dash.us.aiv-cdn.net" \
"www.amazon.com" \
"images-na.ssl-images-amazon.com" \
"view.yahoo.com" \
"ibdp.videovore.com" \
"viewport.videovore.com" \
"t2.hulu.com" \
"t.hulu.com" \
"secure.hulu.com" \
"sb.scorecardresearch.com" \
"s.hulu.com" \
"play.hulu.com" \
"mozart.hulu.com" \
"ib.huluim.com" \
"hulu.com" \
"geo.yahoo.com" \
"geo.query.yahoo.com" \
"csp.yahoo.com" \
"api.view.yahoo.com" 
do
  # extract ip addresses
  echo Looking up $domain
  for ip in $(nslookup $domain | awk '/^Name:/,0{if (/^Addr/)print $3}'); do
    # add class c route for each ip address to wan gateway
    # echo ip route add `echo $ip | cut -d . -f 1,2`.0.0/16 via $WAN_GW >> $ROUTES
	
    # OR add class d route for each ip address to wan gateway
    echo ip route add `echo $ip | cut -d . -f 1,2,3`.0/24 via $WAN_GW >> $ROUTES
  done
done

# list domains for selective routing
for domain in \
"whatsmyip.org" \
"208.67.222.222" \
"208.67.220.220" \
"updates.dnsomatic.com"
do
  # extract ip addresses
  echo Looking up $domain
  for ip in $(nslookup $domain | awk '/^Name:/,0{if (/^Addr/)print $3}'); do
    # add the individual IP address
    echo ip route add $ip via $WAN_GW >> $ROUTES
  done
done

sort $ROUTES | uniq > $ROUTES.new
mv $ROUTES.new $ROUTES

echo Creating $ROUTES.sh
echo "#!/bin/sh" > $ROUTES.sh
cat $ROUTES >> $ROUTES.sh
chmod +x $ROUTES.sh
$ROUTES.sh
 
# flush cache
ip route flush cache
EOF

chmod +x $SCRIPT
sleep 60
$SCRIPT
