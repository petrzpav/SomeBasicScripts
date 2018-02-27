#!/bin/bash
DEFAULT="$PWD"
SUCCESS=0
ALL=0
cd ${DEFAULT}
for i in $(ls) ; do
   if [ -d "$i" ]
	then
     cd ${DEFAULT}/${i}
	   git pull >/dev/null 2>/dev/null
	   if [ $? -eq 0 ]
	   then
	    ((SUCCESS++))
	   else
	    echo "ERROR while pulling ${i}"
	   fi
	   ((ALL++))
	fi
   cd ${DEFAULT}
 done

 echo -e "\n$SUCCESS" "/" "$ALL" "was successfully pulled"
