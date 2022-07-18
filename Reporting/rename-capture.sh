# term colors                                                                                                         
RED='\033[0;31m'                          
GREEN='\033[0;32m'                                                                                                                                                                                                                          
BLUE='\033[0;34m'                                                                                                     
NC='\033[0m' # No Color 

# Vars
walkthrough_dir=$TARGET_DIR/walkthroughs
latest_capture=$(ls -ltrA $walkthrough_dir | tail -n -1 | awk '{print $9}')
target_file_path=$walkthrough_dir/$latest_capture

mv $target_file_path $walkthrough_dir/$1.md

# Output
if [ $? -eq 0 ]; then
	echo -e "[${GREEN}+${NC}] Capture renamed to $walkthrough_dir/$1.md"
else
	echo -e "[${RED}!${NC}] Error occurred while renaming the capture"
fi
