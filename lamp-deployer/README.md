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



# Guide Utilisateur
Se connecter à l'url : 
http://lamp-deployer/
Renseignez le nom de l'appli/ du déploiement en respectant ces restrictions : 
- 50 caractères max
- lettres minuscules, chiffres et le caractère " - " sont autorisés

Renseignez la taille de stockage voulu, respectez la taille maximale indiquée et n'entrez que des nombres

Le champ Répertoire Git est facultatif, laissez le vide sauf si besoin.
Cependant si vous souhaitez le renseigner, l'option fonctionne uniquement pour les répertoires publiques
Il vous suffit de déposer l'url du repo sous cette forme : "https://github.com/xWoozixx/docKube.git" (exemple pour ce repo)

Une fois les champs renseignées, cliquez sur le bouton pour déployer l'application.
l'url qui permet d'accéder à votre site apparaitra sur le site, une fois le déploiement réalisé.

# ! Attention à ne pas quitter la page avant d'avoir copié et enregistré l'url !

Il est possible, si vous avez renseigné un repo git, qu'il nécessite un peut de temps pour la copie du répertoire, 
il vous suffit d'attendre avant d'accéder à l'url.

# Sans repo Git
Dans ce cas la, connectez-vous à la machine d-kube-storage, 
un dossier au nom de votre déploiement à été crée, il se trouve dans /export/lamp/<le nom de votre site>

C'est ici que vous devez mettre les fichiers de vottre site php, dont un fichier index.php ou .html 
qui sera la page d'entrée affichée quand vous entrerez l'url du site.  
