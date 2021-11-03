#!/bin/bash
kill -9 $(ps aux | grep openvpn | grep -v grep | awk '{print $2}')
/usr/sbin/openvpn /etc/openvpn/client/lab_b0d.ovpn&
source $HOME/.zshrc
mkdir -p $TARGET_DIR/nmap
mkdir -p $TARGET_DIR/exploits
mkdir -p $TARGET_DIR/dir-enum
cd $TARGET_DIR
tmux new-session -s $TARGET_NAME -d "nmap -sC -sV -oA $TARGET_DIR/nmap/initial-tcp $TARGET;/usr/bin/zsh"
tmux new-session -s $TARGET_NAME -d "nmap -sC -sU -sV -oA $TARGET_DIR/nmap/initial-udp $TARGET;/usr/bin/zsh"
tmux split-window -v "nmap -sC -sV -oA $TARGET_DIR/nmap/full $TARGET -p-; /usr/bin/zsh"
tmux new-window 
tmux -2 attach-session -d

