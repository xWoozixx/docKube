# docKube
# Installer le serveur NFS
Exécuter le script installNFS.sh sur votre serveur linux
# Installer Kubernetes (k8s)
Exécuter le script install.sh sur tous les noeuds (nodes) de votre cluster
# Installer le Control Plane (CP)
Choisissez le noeud que vous souhaitez pour qu'il controle le cluster (c'est ici que seront exécutés les commandes).
A la ligne 17 du script installCP.sh, vous pouvez définir le pool d'adresses IP qui seronts attribuées aux pods ( value: "10.254.0.0\/16" )
Exécuter le script installCP.sh sur le CP
