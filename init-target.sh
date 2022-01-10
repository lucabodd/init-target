#!/bin/bash
kill -9 $(ps aux | grep openvpn | grep -v grep | awk '{print $2}')
/usr/sbin/openvpn /etc/openvpn/client/lab_b0d.ovpn&
source $HOME/.zshrc
mkdir -p $TARGET_DIR/nmap
mkdir -p $TARGET_DIR/exploits
mkdir -p $TARGET_DIR/dir-enum
mkdir -p $TARGET_DIR/walkthroughs
cd $TARGET_DIR
tmux new-session -s $TARGET_NAME -d 
tmux new-window -t $TARGET_NAME -n "Nmap Recon" "nmap -sC -sV -oA $TARGET_DIR/nmap/initial-tcp $TARGET;/usr/bin/zsh"
tmux split-window -t $TARGET_NAME -h "nmap -sC -sU -sV -oA $TARGET_DIR/nmap/initial-udp $TARGET;/usr/bin/zsh"
tmux split-window -t $TARGET_NAME -v "nmap -sC -sV -oA $TARGET_DIR/nmap/full $TARGET -p-; /usr/bin/zsh"
tmux new-window -t $TARGET_NAME -n "Nmap VA" "nmap --script vuln -oA $TARGET_DIR/nmap/vulnerability-assesment $TARGET;/usr/bin/zsh" 
tmux -2 attach-session -d

