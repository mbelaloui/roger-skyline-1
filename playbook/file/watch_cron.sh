# {{ ansible_managed }}
#!/bin/bash

SAUV_MD5_TAB=sauv_md5
MD5_TAB=md5
FILE_WATCHED={{ url_file | default('/etc/crontab', True) }}
TO_MAIL={{ to_mail | default('root', True) }}

if [ ! -f "$SAUV_MD5_TAB" ]
then
	md5sum $FILE_WATCHED > "$SAUV_MD5_TAB"
	echo "Alert Watcher $FILE_WATCHED
       	No ref file to compare the signature...
	
	Probably the first execution of the $FILE_WATCHED file monitoring script

	A ref file has just been created for the next time.
	" | mail -s "Warningte" $TO_MAIL
else
	md5sum $FILE_WATCHED > "$MD5_TAB"
	DIFF=$(diff "$MD5_TAB" "$SAUV_MD5_TAB")
	if [  "$DIFF" ]
	then
		echo "Alert Watcher $FILE_WATCHED
		
		
		Warning, the file $FILE_WATCHED has been modified...
		" | mail -s "Alert" $TO_MAIL
	fi
	rm "$MD5_TAB"
fi
