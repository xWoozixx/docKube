# Guide de déploiement
# Le dossier lamp
Une fois le cluster fonctionnel,créez un dossier lamp et mettez-y le script newApp.sh,
indiquer dans le script le chemin vers le dossier lamp, 
#Path vers le dossier lamp ex:"/home/user/lamp/"
path="/home/remi/lamp"
# Apache
Installez apache sur le CP.
Indiquer aussi le chemin vers le dossier lamp dans le fichier deploy.php
Indiquer la valeur de stockage max en Gio dans le fichier index.php
Mettez les 3 fichiers (deploy.php, index.php et style.css) dans le dossier /var/www/html/
