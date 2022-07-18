#!/bin/bash
# term colors                                                                                                         
RED='\033[0;31m'                          
GREEN='\033[0;32m'                                                                                                                                                                                                                          
BLUE='\033[0;34m'                                                                                                     
NC='\033[0m' # No Color 

# Vars
walkthrough_dir="$REPOS/htb-walkthroughs/*"

if [ -z $1 ]; then
        echo -e "[${RED}!${NC}] Error: no arguments provived."
	echo -e "    Usage: note-search [search arg 1] [filter results]"
	exit 1
fi

if [ -z $2 ]; then
	grep -ri --color $1 $walkthrough_dir
	matches=$(grep -ri $1 $walkthrough_dir | wc -l)
else
	grep -ri --color $1 $walkthrough_dir | grep -i --color $2
	matches=$(grep -ri $1 $walkthrough_dir | grep -i $2 | wc -l)
fi

# Output
if [ $matches -ne 0 ]; then
        echo -e "[${GREEN}+${NC}] Found $matches Matches"
else
        echo -e "[${RED}!${NC}] No Matches Found"
fi

