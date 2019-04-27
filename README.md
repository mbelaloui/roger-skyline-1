Skip to content
 
Search or jump to…

Pull requests
Issues
Marketplace
Explore
 
@mbelaloui 
Code  Issues 0  Pull requests 0  Projects 0  Wiki  Pulse  Community
roger-skyline-1/reseau et secu
 Mehdi aissa BELALOUI 25-02-2019
5a8cd9a on Feb 25
307 lines (220 sloc)  7.82 KB
    
echo "set number
set smartindent
set autoindent
set ruler
syntax on" > ~/.vimrc

set sudo privilege to user : usermod -aG sudo username || ajout de user dans le group des sudoers et  <add user au fichier /etc/sudo sudoers>

-ssmpt <envoyer les mail>
{
	configurer les fichiers
		- /etc/ssmtp/revalises

root:42roger.skyline@gamil.com:smtp.gmail.com:587
user:42roger.skyline@gamil.com:smtp.gmail.com:587

		- /etc/sstmp/ssmtp.conf

root=42roger.skyline@gamil.com
mailhub=smtp.gmail.com:587
FromLineOverride=YES
UseSTARTTLS=YES
AuthUser=42roger.skyline
AuthPass=424242@424242
UseSTRATTLS=YES

		echo "Message Body" | mail -s "Message Subject" 42roger.skyline@gamil.com
}

cron su root
{


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
	" | mail -s "alerte" root
else
	md5sum /etc/crontab > "$MD5_TAB"
	DIFF=$(diff "$MD5_TAB" "$SAUV_MD5_TAB")
	if [  "$DIFF" ]
	then
		echo "	aletre /etc/crontab
		event dans le dossier /etc/crontab
	       	le fichier n'a pas la meme signature...." | mail -s "alerte" root
	fi
	rm "$MD5_TAB"
fi


echo "0 4 * * 1     (apt-get update && apt-get upgrade -y) >> /var/log/update_script.log
@reboot     (apt-get update && apt-get upgrade -y) >> /var/log/update_script.log
0 0 * * *     (sh /surveiller.sh)" >> script_ex02
crontab script_ex02
rm -f script_ex02
}

serveur web 
{
	apache2
	#nginx
	...
	copier le site web dans le dossier /var/www/html
}

ssl 
{
	openssl req -new -x509 -days 365 -nodes -out /etc/ssl/certs/mailserver.crt -keyout /etc/ssl/private/mailserver.key
	sudo chmod 440 /etc/ssl/private/mailserver.key
	a2enmod ssl
	sudo systemctl restart apache2

	# vhost https
	<VirtualHost *:443>
	DocumentRoot /var/www/webmail
	ServerName  webmail.mondomaine.com

	ServerSignature Off
	ErrorLog ${APACHE_LOG_DIR}/error_webmail.log      
	LogLevel info      
	CustomLog ${APACHE_LOG_DIR}/access_webmail.log combined      

	SSLEngine on
	SSLCertificateFile /etc/ssl/certs/mailserver.crt
	SSLCertificateKeyFile /etc/ssl/private/mailserver.key
	</VirtualHost>

	https://127.0.0.1:port
	https://www.vincentliefooghe.net/content/activer-un-accès-https-sur-apache
}


-fixer l'address ip
	modifier le ficheir /etc/network/interfaces
	{
		enp0s3
		enlever la ligne qui parametrer l'utilisation du dhcp
		et ajouter les lignes qui configure l'nterface de maniere static

		auto enp0s3s
		iface enp0s3 inet static
			address 10.0.2.1
			netmask 255.255.255.252
			gateway 10.0.2.2
			broadcast 10.0.2.3
	}
	pour le nat
		on a jout une redirection vers l'address ip du gest dans les paramteres network <127.0.0.1:4222 ==> 10.0.2.1:2424>




-iptables : pour voir les port utiliser <netstat -ltunp>
	{
		iptbales est un moyen qui va permettre de gerer les requetes entrante et sortante d'une machine
		iptables nous permet de configurer Netfilter
		pour manipuler iptables il faut les droits root


		iptables [ACDIRLSFZNXPEh] <INPUT, FORWARD, OUTPUT> -[4, 6, p, s, d, m, j, g, i, o, f, c, v, w, n, x] -j [ACCEPT, DROP,RETURN]
		
		-A : ajouter une regles a une cyble

		-P : modifier la valeur par defaut de la polique de gestion de packet d'une cyble definit <INPUT, OUTPUT, FORWARD, ...>

		-F : supprime toute les regles ajouter



		-d : port de destination

		-i : interface de destination

		-s : ip sources, peut etre une ip reseau

		-p : our cybler un protocole bien definit, si cette option n'est pas specifie tout les protocoles sont concernes
			<tcp, udp, udplite, icmp, icmpv6, esp, ah, sctp, mh>

		-j : cette option permet de specifer ce qu'il faut faire si il ya un match entre le packet et la regle.

		-i : pour specifier une interface reseau sur laquel on va appliquer la regle

echo "#!/bin/sh
#
# firewall.rull

# Nous vidons les chaines predefinies :
iptables -F

# Nous supprimons les regles des chaines personnelles :
iptables -X

# Nous les faisons pointer par déut sur DROP
iptables -P INPUT DROP
#iptables -P OUTPUT DROP
iptables -P FORWARD DROP

#Autorise les rénses
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
#iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#(Facultatif : autoriser l'accés au serveur sdepuis l'extérieur)
iptables -A INPUT -p TCP --dport 2424 -i enp0s3 -j ACCEPT
iptables -A INPUT -p TCP --dport ssh -i enp0s3 -j ACCEPT
iptables -A INPUT -p TCP --dport http -i enp0s3 -j ACCEPT

# Mail SMTP:25
#iptables -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
#iptables -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT

# Mail POP3:110
#iptables -t filter -A INPUT -p tcp --dport 110 -j ACCEPT
#iptables -t filter -A OUTPUT -p tcp --dport 110 -j ACCEPT

# Mail IMAP:143
#iptables -t filter -A INPUT -p tcp --dport 143 -j ACCEPT
#iptables -t filter -A OUTPUT -p tcp --dport 143 -j ACCEPT

# Mail POP3
#iptables -A INPUT -p tcp --dport 995 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -p tcp --sport 995 -m conntrack --ctstate ESTABLISHED -j ACCEPT

# Mail POP3S
#iptables -A INPUT -p tcp --dport 993 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -p tcp --sport 993 -m conntrack --ctstate ESTABLISHED -j ACCEPT

# anti scan
iptables -A INPUT -i enp0s3 -p tcp --tcp-flags FIN,URG,PSH FIN,URG,PSH -j DROP
iptables -A INPUT -i enp0s3 -p tcp --tcp-flags ALL ALL -j DROP
iptables -A INPUT -i enp0s3 -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -i enp0s3 -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A INPUT -i enp0s3 -p tcp --tcp-flags SYN,ACK,FIN,RST RST -j DROP

#incoming malformed XMAS packets
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

#Incoming malformed NULL packets
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

#Autoriser DNS
#iptables -A OUTPUT --protocol udp --destination-port 53 -j ACCEPT

#Sortie web
#iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -j ACCEPT

# Mail SMTP:25
#iptables -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
#iptables -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT

#Regles de secu
iptables -A INPUT -p all -j DROP
#iptables -A OUTPUT -p all -j DROP
iptables -A FORWARD -p all -j DROP" > /home/user/firewall.rules


echo "
		#FLUSH
		iptables -F

		#Polique
		iptables -P INPUT ACCEPT
		#iptables -P OUTPUT ACCEPT
		iptables -P FORWARD ACCEPT
" > /home/user/firewall.clean


		voir ufw pour une interface plus simple pour manipuler une iptable
		mettre le tout dans un fichier /home/user/firewall
	}

	ajouter a /etc/network/interface la line suivante
	{
		sudo sh firewall.rules
		iptables-save > /home/user/firewall.restor

		add to /etc/network/interface
		pre-up iptables-restore < /home/user/firewall.restor
	}




an port portsentry
{
	https://www.it-connect.fr/bloquer-les-individus-qui-scannent-votre-machine-avec-portsentry/


	Modification du fichier /etc/default/portsentry :
		Remplacer
			TCP_MODE="tcp"
			UDP_MODE="udp"

		Par
			TCP_MODE="atcp"
			UDP_MODE="audp"

	Modification du fichier /etc/portsentry/portsentry.conf
		Remplacer
			BLOCK_UDP="0"
			BLOCK_TCP="0"

		Par
			BLOCK_UDP="1"
			BLOCK_TCP="1"

	dans le fichier /etc/portsentry/portsentry.conf 
		<commentez toutes les lignes commençant par "KILL_ROUTE" sauf>
			KILL_ROUTE="/sbin/iptables -I INPUT -s $TARGET$ -j DROP"

	sudo service portsentry restart


}







-ssh caracteristique :
	PermitRootLogin no
	public key
	{
		1- generer la public rsa key cote client <ssh-keygen -t rsa -q>
			les fichiers sont sauvegerger dans ~/.ssh/
		2- transfert des clefs vers le clients <ssh-copy-id user@127.0.0.1 -p2424>
	}
	modifier le fichier /etc/ssh/sshd_config pour le reste 
	[
		port p2424
		PermitRootLogin : no
		PasswordAuthentication no ****** optionelle je la garde pour pouvoir tester le ban avec fail2ban
	]



https://www.digitalocean.com/community/tutorials/iptables-essentials-common-firewall-rules-and-commands
