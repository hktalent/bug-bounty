# responder launcher
# set -x
# Usage:
# ./responderd /path/to/responder interface responder_options

# port list
# Everything -> tcp:21 tcp:80 tcp:25 udp:53 tcp:88 udp:137 udp:138 tcp:139 tcp:143 tcp:443 tcp:445 tcp:110 tcp:389 tcp:1433 tcp:3141 udp:5353 udp:5355
PORT_LIST=(tcp:21 udp:53 tcp:88 udp:137 udp:138 tcp:139 tcp:143 tcp:445 tcp:389 tcp:1433 udp:5353 udp:5355)
SVC_LIST=()

# check for running processes and kill them one by one
# looping over everything rather than doing a mass kill because some processes may be 
# children and may not need to be killed
for port in ${PORT_LIST[@]}; do
	PROC=$(lsof +c 0 -i $port | grep -m 1 -v 'launchd\|COMMAND' | cut -d' ' -f1)
	if [ -n "$PROC" ]; then
        AGENT=$(sudo launchctl list | grep -m 1 $PROC | cut -f3 | sed 's/.reloaded//g')

        # load/unload are listed as "legacy" in 10.10+ may need to change this someday
		echo "Stopping $PROC"
        sudo launchctl unload -w /System/Library/LaunchDaemons/$AGENT.plist

        # append killed service to new array
        SVC_LIST+=($AGENT)
	fi
done

# get IP address
IP=$(ifconfig $2 | grep 'inet ' | cut -d' ' -f2)

# Launch responder
python $1 $3 -i $IP

# restore stopped services
for agent in ${SVC_LIST[@]}; do
	echo "Starting $agent"
		sudo launchctl load -w /System/Library/LaunchDaemons/$agent.plist

done
