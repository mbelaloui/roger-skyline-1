#!/bin/bash

SAUV_MD5_TAB=sauv_md5_crontab.txt
MD5_TAB=md5_crontab.txt

if [ ! -f "$SAUV_MD5_TAB" ]
then
	md5sum /etc/crontab > "$SAUV_MD5_TAB"
	echo "aletre /etc/crontab
	pas de fichier ref pour comparer la signature....
	probablement la premier execution du script...
	un fichier sauvgarde va etre cree...
	" | mail -s "alerte" 42roger.skyline@gamil.com
else
	md5sum /etc/crontab > "$MD5_TAB"
	DIFF=$(diff "$MD5_TAB" "$SAUV_MD5_TAB")
	if [  "$DIFF" ]
	then
		echo "	aletre /etc/crontab
		event dans le dossier /etc/crontab
		le fichier n'a pas la meme signature...." | mail -s "alerte" 42roger.skyline@gamil.com
	fi
	rm "$MD5_TAB"
fi

