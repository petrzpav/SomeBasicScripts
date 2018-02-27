#!/bin/bash

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
SENDSTATUS=0
MAILSENT=0
DOWNSTATUS=0
TARGET=""			#Target IP
COMMENT=""			#Target Name
MAIL="@"			#Mail for informing when target is down
LOG=""

while true
do
	STATUS=$(ping "$TARGET" -c 1 -W 1 >/dev/null ; echo $?)
	if [ "$STATUS" -ne 0 ]
	then
		((DOWNSTATUS++))
		NOW=$(date +'%d-%m-%Y %T')
		LOG+="["$NOW"] - "$TARGET" - "$COMMENT" - DOWN - "$DOWNSTATUS"~"

		if [ "$DOWNSTATUS" -gt 9 -a "$MAILSENT" -eq 0 ]
		then
			SENDSTATUS=$(echo -e "$LOG" | tr '~' '\n' | mail -s "Checked host seems to be DOWN!" "$MAIL" >/dev/null ; echo $?)
			if [ "$SENDSTATUS" -eq 0 ]
			then
				MAILSENT=1
				#echo "Mail was sent..."
			fi
		fi
	else
		sleep 1
		DOWNSTATUS=0
		MAILSENT=0
                NOW=$(date +'%d-%m-%Y %T')
                LOG+="["$NOW"] - "$TARGET" - "$COMMENT" - UP~"
	fi
	LOG=$(echo -n "$LOG" | tr '~' '\n' | tail -n50 | tr '\n' '~')
	#echo -e "$LOG" | tr '~' '\n'
	sleep 9
done
