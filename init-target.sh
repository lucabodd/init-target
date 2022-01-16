#!/usr/bin/zsh
# term colors
RED='%B%F{red}'
GREEN='%B%F{green}'
BLUE='%B%F{blue}'
NC='%f%b' # No Color
# Scan all by default
init_tcp=1
init_udp=1
full=1
va=1
overwrite_all=0

kill -9 $(ps aux | grep openvpn | grep -v grep | awk '{print $2}') 2> /dev/null
source $HOME/.zshrc
mkdir -p $TARGET_DIR/nmap
mkdir -p $TARGET_DIR/exploits
mkdir -p $TARGET_DIR/dir-enum
mkdir -p $TARGET_DIR/walkthroughs
cd $TARGET_DIR

if [ -f "$TARGET_DIR/nmap/initial-tcp.nmap" ] && \
	 [ -f "$TARGET_DIR/nmap/initial-udp.nmap" ] && \
	 [ -f "$TARGET_DIR/nmap/full.nmap" ] && \
	 [ -f "$TARGET_DIR/nmap/vulnerability-assesment.nmap" ]; then
		 vared -p "[${RED}!${NC}] Scan files has ben found in $TARGET_DIR/nmap. Do you want to overwrite? [y/${GREEN}N${NC}]: " -c overwrite;
		 if [[ "$overwrite" == "N" ]] || [ -z "$overwrite" ]; then
 				init_tcp=0
				init_udp=0
				full=0
				va=0
		else
			overwrite_all=1
 		fi
fi

if [[ $overwrite_all -ne 1 ]]; then
	if [ $init_tcp -ne 0 ]; then
		if test -f "$TARGET_DIR/nmap/initial-tcp.nmap"; then
			  unset overwrite
				vared -p "[${RED}!${NC}] Scan file ${BLUE}initial-tcp.namp${NC} already exists, do you want to overwrite? [y/${GREEN}N${NC}]: " -c overwrite;
				if [[ "$overwrite" == "N" ]] || [ -z "$overwrite" ]; then
						init_tcp=0
				fi
		fi
	fi
	if [ $init_udp -ne 0 ]; then
		if test -f "$TARGET_DIR/nmap/initial-udp.nmap"; then
			  unset overwrite
				vared -p "[${RED}!${NC}] Scan file ${BLUE}initial-udp.namp${NC} already exists, do you want to overwrite? [y/${GREEN}N${NC}]: " -c overwrite;
				if [[ "$overwrite" == "N" ]] || [ -z "$overwrite" ]; then
						init_udp=0
				fi
		fi
	fi
	if [ $full -ne 0 ]; then
		if test -f "$TARGET_DIR/nmap/full.nmap"; then
			  unset overwrite
				vared -p "[${RED}!${NC}] Scan file ${BLUE}full.namp${NC} already exists, do you want to overwrite? [y/${GREEN}N${NC}]: " -c overwrite;
				if [[ "$overwrite" == "N" ]] || [ -z "$overwrite" ]; then
						full=0
				fi
		fi
	fi
	if [ $va -ne 0 ]; then
		if test -f "$TARGET_DIR/nmap/vulnerability-assesment.nmap"; then
			  unset overwrite
				vared -p "[${RED}!${NC}] Scan file ${BLUE}vulnerability-assesment.namp${NC} already exists, do you want to overwrite? [y/${GREEN}N${NC}]: " -c overwrite;
				if [[ "$overwrite" == "N" ]] || [ -z "$overwrite" ]; then
						va=0
				fi
		fi
	fi
fi

/usr/sbin/openvpn --verb 0 --syslog --config /etc/openvpn/client/lab_b0d.ovpn&
atom --no-sandbox $TARGET_DIR $REPOS/htb-walkthroughs

tmux new-session -s $TARGET_NAME -d
if [ $init_tcp -eq 1 ]; then
	tmux new-window -t $TARGET_NAME -n "Nmap Recon" "nmap -sC -sV -oA $TARGET_DIR/nmap/initial-tcp $TARGET;/usr/bin/zsh"
fi
if [ $init_udp -eq 1 ]; then
	tmux split-window -t $TARGET_NAME -h "nmap -sC -sU -sV -oA $TARGET_DIR/nmap/initial-udp $TARGET;/usr/bin/zsh"
fi
if [ $full -eq 1 ]; then
	tmux split-window -t $TARGET_NAME -v "nmap -sC -sV -oA $TARGET_DIR/nmap/full $TARGET -p-; /usr/bin/zsh"
fi
if [ $va -eq 1 ]; then
	tmux new-window -t $TARGET_NAME -n "Nmap VA" "nmap --script vuln -oA $TARGET_DIR/nmap/vulnerability-assesment $TARGET;/usr/bin/zsh"
fi
tmux -2 attach-session -d
