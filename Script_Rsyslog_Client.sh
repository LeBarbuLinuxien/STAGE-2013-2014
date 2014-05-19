#!/bin/bash
#####################################
# VERIFICATION PROFIL UTILISATEUR : #
#####################################

if [ `whoami` != root ]; then
 echo "L'utilisateur ne dispose pas des droits nécessaires pour exécuter le script"
 exit
fi

########################################
# RECUPERATION DE L'OPERATING SYSTEM : #
########################################

OS=$(awk '/DISTRIB_ID=/' /etc/*-release | sed 's/DISTRIB_ID=//' | tr '[:upper:]' '[:lower:]')
VERSION=$(awk '/DISTRIB_RELEASE=/' /etc/*-release | sed 's/DISTRIB_RELEASE=//' | sed 's/[.]0/./')
if [ -z "$OS" ]; then
    OS=$(awk '{print $1}' /etc/*-release | tr '[:upper:]' '[:lower:]')
fi

if [ -z "$VERSION" ]; then
    VERSION=$(awk '{print $3}' /etc/*-release)
fi
echo $OS 

#######################################
# Configuration des clients Rsyslog : #
#######################################

if [ $OS = "ubuntu" ]; then
	 echo "*** Rsyslog - OS Client : Ubuntu ***"
	 echo "- INSTALLATION RSYSLOG -"
	 apt-get install rsyslog -y
	 
	 # 1- Récupération du certificat permettant TLS : #
	 mkdir /etc/ssl/pki
	 #scp thomas.maret@5.135.189.106:/etc/ssl/pki/ca.pm /etc/ssl/pki/   ==+> A déployer avec fabric (PUT)
	 # Créer dossier avec la commande mkdir avec fabric
	  
	 # 2- Configuration TLS sur les clients : #

	 echo "$DefaultNetstreamDriver gtls

	 $DefaultNetstreamDriverCAFile /etc/pki/ca.pem

	 $DefaultNetstreamDriverCertFile /etc/pki/server-cert.pem

	 $DefaultNetstreamDriverKeyFile /etc/pki/server-privkey.pem

	 $ModLoad /usr/lib/rsyslog/imtcp

	 $InputTCPServerStreamDriverMode 1 # TLS only mode

	 $InputTCPServerSTreamDriverAuthMode anon # client not authenticated

	 $InputTCPServerRun 10514" >> /etc/rsyslog.d/tls-serveur.conf
	 
	 # 4 - Si LE TLS ne marche pas on peut toujours envisager une configuration "normale"
	 echo "== CONFIGURATION RSYSLOG =="
	 echo "#TCP configuration
	 *.* @5.135.189.106:514
	 #UDP configuration
	 *.* @@(o)5.135.189.106:514
	 local6.info @@5.135.189.106:10514" >> /etc/rsyslog.conf
	  
##########################
# Configuration APACHE : #
##########################
	 
	 echo "*** Configuration APACHE ***"
	 echo "Modification de apache2.conf" 
	 echo "
	 CustomLog "|/usr/bin/logger -t apache_access -p local6.info" combined
	 ErrorLog "|/usr/bin/logger -t apache_error -p local7.err" ">> /etc/apache2/apache2.conf
	 echo "Modification de rsyslog.conf"
	 echo "local6.info@5.135.189.106:10514" >> rsyslog.conf 

	 echo "Configuration terminée."
	 
##################
# VirtualHosts : #
##################
	echo "** Configuration des VH ***"
	echo "Création de la liste VH"
	ls -Alc /etc/apache2/sites-enabled | awk '{print $9}'> /tmp/listVH
	

#########################
# Modification des VH : #
#########################

	while read line
		do
			  echo -e "$line"
			  echo "- Recuperation du nom -"
			  nom=$(sed -rn 's/.*ServerName[ \t]*(.*)\.([^.]*)\.([^.]*)$/\1/p' /etc/apache2/sites-enabled/$line)
			  echo "- Recuperation avec succes -"
			  echo "- Modification du fichier -"
			  sed -i '1 a\CustomLog "|/usr/bin/logger -t apache_access_'$nom' -p local6.info" combined' /etc/apache2/sites-enabled/$line
			  sed -i '1 a\CustomLog /var/log/apache2/'$nom'.access.log combined' /etc/apache2/sites-enabled/$line
			  echo "- Modification reussie -"
		done < /tmp/listVH	
else 

	 echo "*** Rsyslog - OS Client : REDHAT, FEDORA, CENTOS ***"
	 echo "- INSTALLATION RSYSLOG -"
	 yum install rsysog -y
	 # 1- Récupération du certificat permettant TLS : #

	 #scp thomas.maret@5.135.189.106:/etc/ssl/pki/ca.pm /etc/ssl/pki/

	 # 2- Configuration TLS sur les clients : #

	 echo "$DefaultNetstreamDriver gtls

	 $DefaultNetstreamDriverCAFile /etc/pki/ca.pem

	 $DefaultNetstreamDriverCertFile /etc/pki/server-cert.pem

	 $DefaultNetstreamDriverKeyFile /etc/pki/server-privkey.pem

	 $ModLoad /usr/lib/rsyslog/imtcp

	 $InputTCPServerStreamDriverMode 1 # TLS only mode

	 $InputTCPServerSTreamDriverAuthMode anon # client not authenticated

	 $InputTCPServerRun 10514" >> /etc/rsyslog.d/tls-serveur.conf
	 
	 echo "#TCP configuration
	 *.* @5.135.189.106:10514
	 #UDP configuration
	 *.* @@(o)5.135.189.106:10514" >> /etc/rsyslog.conf
	 
##########################
# Configuration APACHE : #
##########################
	 
	 echo "Modification de httpd.conf" 
	 echo "
	 CustomLog "|/usr/bin/logger -t apache_access -p local6.info" combined
	 ErrorLog "|/usr/bin/logger -t apache_error -p local7.err" ">> /etc/apache2/apache2.conf
	 echo "Modification de rsyslog.conf"
	 echo "local6.info@5.135.189.106:10514" >> rsyslog.conf 
	 echo "Configuration terminée APACHE. "
	 
##################
# VirtualHosts : #
##################

	 ls -Alc /etc/apache2/sites-enabled | awk '{print $9}'> /tmp/listVH # Récupération de la liste des VH dans un dossier temporaire 

#########################
# Modification des VH : #
#########################

	while read line
		do
		  echo -e "$line"
		  echo "- Recuperation du nom -"
		  nom=$(sed -rn 's/.*ServerName[ \t]*(.*)\.([^.]*)\.([^.]*)$/\1/p' /etc/apache2/sites-enabled/$line)
		  echo "- Recuperation avec succes -"
		  echo "- Modification du fichier -"
		  sed -i '1 a\CustomLog "|/usr/bin/logger -t apache_access_'$nom' -p local6.info" combined' /etc/apache2/sites-enabled/$line
		  sed -i '1 a\CustomLog /var/log/apache2/'$nom'.access.log combined' /etc/apache2/sites-enabled/$line
		  echo "- Modification reussie -"
	done < /tmp/listVH	
fi


















