# term colors
RED='\033[0;31m'
GREEN='\033[0;32m'                                                                                                    BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Vars
walkthrough_dir=$TARGET_DIR/walkthroughs
target_file_path=$walkthrough_dir/clipboard-capture-$(date +%Y%m%d%H%M%S).log

echo -e "[${BLUE}*${NC}] Saving clipboard content..."
clipboard_content=$(/usr/bin/xclip -o 2>/dev/null)
if [ ! -z $clipboard_content ]; then
	echo "$clipboard_content"
fi
echo $clipboard_content > $target_file_path

# Output
if [ $? -eq 0 ]; then
	echo -e "[${GREEN}+${NC}] Clipboard content saved to $target_file_path"
else
	echo -e "[${RED}!${NC}] Error occurred while saving clipboard content. Clipboard might be empty"
fi
