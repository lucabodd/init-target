#!/usr/bin/zsh
# term colors for vared
RED='%B%F{red}'
GREEN='%B%F{green}'
BLUE='%B%F{blue}'
NC='%f%b' # No Color
# term colors for bash
BASH_RED='\033[0;31m'
BASH_GREEN='\033[0;32m'
BASH_BLUE='\033[0;34m'
BASH_NC='\033[0m' # No Color

# Scan all by default
init_tcp=1
init_udp=1
full_quick=1
full=1
va=1
overwrite_all=0

kill -9 $(ps aux | grep openvpn | grep -v grep | awk '{print $2}') 2> /dev/null
source $HOME/.zshrc
mkdir -p $TARGET_DIR/nmap
mkdir -p $TARGET_DIR/exploits
mkdir -p $TARGET_DIR/dir-enum
mkdir -p $TARGET_DIR/walkthroughs
mkdir -p $TARGET_DIR/www
cp /opt/pspy/pspy64 $TARGET_DIR/www
cp /opt/PEASS-ng/linPEAS/linpeas.sh $TARGET_DIR/www
cd $TARGET_DIR

if [ -f "$TARGET_DIR/nmap/initial-tcp.nmap" ] && \
	 [ -f "$TARGET_DIR/nmap/initial-udp.nmap" ] && \
	 [ -f "$TARGET_DIR/nmap/full-quick.nmap" ] && \
	 [ -f "$TARGET_DIR/nmap/full.nmap" ] && \
	 [ -f "$TARGET_DIR/nmap/vulnerability-assesment.nmap" ]; then
		 vared -p "[${RED}!${NC}] Scan files has ben found in $TARGET_DIR/nmap. Do you want to overwrite? [y/${GREEN}N${NC}]: " -c overwrite;
		 if [[ "$overwrite" == "N" ]] || [ -z "$overwrite" ]; then
 				init_tcp=0
				init_udp=0
				full=0
				full_quick=0
				va=0
		else
			overwrite_all=1
 		fi
fi

if [[ $overwrite_all -ne 1 ]]; then
	if [ $init_tcp -ne 0 ]; then
		if test -f "$TARGET_DIR/nmap/initial-tcp.nmap"; then
			  unset overwrite
				vared -p "[${RED}!${NC}] Scan file ${BLUE}initial-tcp.nmap${NC} already exists, do you want to overwrite? [y/${GREEN}N${NC}]: " -c overwrite;
				if [[ "$overwrite" == "N" ]] || [ -z "$overwrite" ]; then
						init_tcp=0
				fi
		fi
	fi
	if [ $full_quick -ne 0 ]; then
		if test -f "$TARGET_DIR/nmap/full-quick.nmap"; then
				unset overwrite
				vared -p "[${RED}!${NC}] Scan file ${BLUE}full-quick.nmap${NC} already exists, do you want to overwrite? [y/${GREEN}N${NC}]: " -c overwrite;
				if [[ "$overwrite" == "N" ]] || [ -z "$overwrite" ]; then
						full_quick=0
				fi
		fi
	fi
	if [ $full -ne 0 ]; then
		if test -f "$TARGET_DIR/nmap/full.nmap"; then
			  unset overwrite
				vared -p "[${RED}!${NC}] Scan file ${BLUE}full.nmap${NC} already exists, do you want to overwrite? [y/${GREEN}N${NC}]: " -c overwrite;
				if [[ "$overwrite" == "N" ]] || [ -z "$overwrite" ]; then
						full=0
				fi
		fi
	fi
	if [ $va -ne 0 ]; then
		if test -f "$TARGET_DIR/nmap/vulnerability-assesment.nmap"; then
			  unset overwrite
				vared -p "[${RED}!${NC}] Scan file ${BLUE}vulnerability-assesment.nmap${NC} already exists, do you want to overwrite? [y/${GREEN}N${NC}]: " -c overwrite;
				if [[ "$overwrite" == "N" ]] || [ -z "$overwrite" ]; then
						va=0
				fi
		fi
	fi
	if [ $init_udp -ne 0 ]; then
		if test -f "$TARGET_DIR/nmap/initial-udp.nmap"; then
				unset overwrite
				vared -p "[${RED}!${NC}] Scan file ${BLUE}initial-udp.nmap${NC} already exists, do you want to overwrite? [y/${GREEN}N${NC}]: " -c overwrite;
				if [[ "$overwrite" == "N" ]] || [ -z "$overwrite" ]; then
						init_udp=0
				fi
		fi
	fi
fi

/usr/sbin/openvpn --verb 0 --syslog --config /etc/openvpn/client/lab_b0d.ovpn&
atom --no-sandbox $TARGET_DIR

tmux new-session -s $TARGET_NAME -d
if [ $init_tcp -eq 1 ]; then
	tmux new-window -t $TARGET_NAME -n "Nmap Recon" "echo -e \"[${BASH_BLUE}*${BASH_NC}] Initial TCP Scan Started at $(date)\";\
	 																								 nmap -sC -sV -oA $TARGET_DIR/nmap/initial-tcp $TARGET;\
																									 echo -e \"[${BASH_GREEN}+${BASH_NC}] Initial TCP Scan Completed at $(date)\";
																									 /usr/bin/zsh"
fi
if [ $full_quick -eq 1 ]; then
	tmux split-window -t $TARGET_NAME -h "echo -e \"[${BASH_BLUE}*${BASH_NC}] Full Quick (No Default Scripts) TCP Scan Queued at $(date)\";\
	 																			sleep 10;\
																				echo -e \"[${BASH_BLUE}*${BASH_NC}] Full Quick (No Default Scripts) TCP Scan Started at $(date)\";\
																				nmap -oA $TARGET_DIR/nmap/full-quick $TARGET -p-; \
																				echo -e \"[${BASH_GREEN}+${BASH_NC}] Full Quick (No Default Scripts) TCP Scan Completed at $(date)\";\
																				echo -e \"[${BASH_BLUE}*${BASH_NC}] Starting Script Enumeration For Discovered Open Ports at $(date)\";\
																				nmap -sC -sV -oA $TARGET_DIR/nmap/full-quick-scripts $TARGET -p $(cat $TARGET_DIR/nmap/full-quick.xml | xq | tr -d '@' | jq '.nmaprun .host .ports .port[] | .portid' | tr -d '\"' | tr '\n' ',');\
																				echo -e \"[${BASH_GREEN}+${BASH_NC}] Full Quick TCP Scan With Default Scripts Completed at $(date)\";\
																				/usr/bin/zsh"
fi
if [ $full -eq 1 ]; then
	tmux split-window -t $TARGET_NAME -v "echo -e \"[${BASH_BLUE}*${BASH_NC}] Full TCP Scan Queued at $(date)\";\
	 																			sleep 60;\
																				echo -e \"[${BASH_BLUE}*${BASH_NC}] Full TCP Scan Started at $(date)\";\
																				nmap -sC -sV -oA $TARGET_DIR/nmap/full $TARGET -p-; \
																				echo -e \"[${BASH_GREEN}+${BASH_NC}] Full TCP Scan Completed at $(date)\";\
																				/usr/bin/zsh"
fi
if [ $va -eq 1 ]; then
	tmux split-window -t $TARGET_NAME -v "echo -e \"[${BASH_BLUE}*${BASH_NC}] Nmap Vulnerability Assesment Queued at $(date)\";\
																				sleep 120;
																				echo -e \"[${BASH_BLUE}*${BASH_NC}] Nmap Vulnerability Assesment Scan Started at $(date)\";\
																				nmap --script vuln -oA $TARGET_DIR/nmap/vulnerability-assesment $TARGET -p-;\
																				echo -e \"[${BASH_GREEN}+${BASH_NC}] Nmap Vulnerability Assesment Scan Completed at $(date)\";\
																				/usr/bin/zsh"
fi
if [ $init_udp -eq 1 ]; then
	tmux split-window -t $TARGET_NAME -v "echo -e \"[${BASH_BLUE}*${BASH_NC}] Initial UDP Scan Queued at $(date)\";\
	 																			sleep 180; \
																				echo -e \"[${BASH_BLUE}*${BASH_NC}] Initial UDP Scan Started at $(date)\";\
																				nmap -sC -sU -sV -oA $TARGET_DIR/nmap/initial-udp $TARGET;\
																				echo -e \"[${BASH_GREEN}+${BASH_NC}] Initial UDP Scan Completed at $(date)\"; \
																				/usr/bin/zsh"
fi

if [ $init_tcp -eq 1 ] && \
	 [ $full_quick -eq 1 ] && \
	 [ $full -eq 1 ] && \
	 [ $va -eq 1 ] && \
	 [ $init_udp -eq 1 ] ; then
		 tmux kill-window -t $TARGET_NAME -t 0
		 tmux move-window -s $TARGET_NAME -t 0
		 tmux new-window -t $TARGET_NAME
fi
tmux -2 attach-session -d
