#!/bin/zsh
# Purpose: automatically install any pkg file put into a certain folder
#
# From:	Tj Luo.ma
# Mail:	luomat at gmail dot com
# Web: 	http://RhymesWithDiploma.com
# Date:	2013-12-11

	# variable to refer to script name without path
NAME="$0:t:r"

	# directory to check for pkg or mpkg files
DIR="$HOME/Action/AutoInstallPKG"

	# where do you want files to be moved after they are installed
SUCCESS_MOVE_TO="$HOME/.Trash/"


	# where do you want files to be moved if they FAIL to be installed
ERROR_MOVE_TO="$HOME/Desktop/"

	# log our output here
LOG="$HOME/Library/Logs/AutoInstallPKG.log"

	# quick function to
log () {

	echo "$NAME: $@" | tee -a "$LOG"

	if (( $+commands[terminal-notifier] ))
	then

		# if terminal-notifier exists, use it

		terminal-notifier -group "$NAME" \
				-sender com.apple.installer \
				-subtitle "Click to show folder $DIR:t" \
				-title "$NAME via launchd" \
				-message "$@"
	fi
}

die () { log "FATAL ERROR: $@" ; exit 1 }

if [ ! -d "$DIR" ]
then
		die "DIR is not a directory: $DIR"
fi

[[ ! -d "$SUCCESS_MOVE_TO" ]] && mkdir -p "$SUCCESS_MOVE_TO"

[[ ! -d "$ERROR_MOVE_TO" ]] && mkdir -p "$ERROR_MOVE_TO"

cd "$DIR" || die "Failed to chdir to $DIR"

	# remove .DS_Store file if it exists, so it won't keep launching `launchd`
rm -f .DS_Store

command ls -1 | while read line
do

	EXT="$line:e"

	case "$EXT" in
		pkg|mpkg)
					log "Installing $line"
					sudo installer -verboseR -pkg "$line" -target / -lang en 2>&1 | tee -a "$LOG"

					EXIT="$?"

					if [ "$EXIT" = "0" ]
					then
							log "$line installed!"

							command mv -n "$line" "$SUCCESS_MOVE_TO" ||\
							command mv -n "$line" "$ERROR_MOVE_TO"

					else
							log "Failed to install $line"
							command mv -n "$line" "$ERROR_MOVE_TO"
					fi
		;;

		*)
					log "$line is not a pkg or mpkg file"
					command mv -n "$line" "$ERROR_MOVE_TO"
		;;
	esac
done


exit
#
#EOF
