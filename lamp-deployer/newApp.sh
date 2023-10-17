# Path vers le dossier lamp ex:"/home/user/lamp/"
path="/home/remi/lamp"

# Récupération des variables dans le fichier var.txt

# Vérifiez si le fichier var.txt existe
if [ -e "$path/var.txt" ]; then
    # Lisez les variables à partir du fichier var.txt
    while IFS= read -r line; do
        export "$line"
    done < $path/var.txt

    # Utilisez les variables dans votre script
#    echo "Nom de l'application : $appName"
#    echo "Taille du stockage : $storageSize"
#    echo "Repo Git : $gitRepository"

else
    echo "Erreur : le fichier var.txt n'existe pas dans le répertoire $path."
    exit 1
fi


mkdir ${path}/${appName}
# Création du fichier yaml et déploiement de l'appli
cat << EOF > ${path}/${appName}/${appName}.yaml
# app-pv.yaml

apiVersion: v1
kind: PersistentVolume
metadata:
  name: ${appName}-pv
spec:
  storageClassName: nfs-storage
  accessModes:
    - ReadWriteMany
  capacity:
    storage: ${storageSize}
  persistentVolumeReclaimPolicy: Retain
  nfs:
    server: 192.168.221.12
    path: "/export/volumes/lamp"

---

# app-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ${appName}-pvc
spec:
  storageClassName: nfs-storage
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: ${storageSize}

---

# app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${appName}-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ${appName}
  template:
    metadata:
      labels:
        app: ${appName}
    spec:
      volumes:
        - name: ${appName}-pvc
          persistentVolumeClaim:
            claimName: ${appName}-pvc
      containers:
        - name: ${appName}
          image: woozix/php7.2-apache-pdo:v1
          ports:
            - containerPort: 80
          volumeMounts:
            - name: ${appName}-pvc
              mountPath: /var/www/html
              subPath: ${appName}
          lifecycle:
            postStart:
              exec:
                command:
                  - "/bin/bash"
                  - "-c"
                  - |
                    apt update && apt install -y git ${gitRepository}

---

# app-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: ${appName}-service
spec:
  type: ClusterIP
  selector:
    app: ${appName}
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80

---

# app-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${appName}-ingress
spec:
  ingressClassName: nginx
  rules:
    - host: ${appName}.k.in.ac-noumea.nc
      http:
        paths:
          - pathType: Prefix
            path: "/"
            backend:
              service:
                name: ${appName}-service
                port:
                  number: 80
EOF

# echo "Dossier + Yaml crée"

# Appliquer le fichier YAML
sudo kubectl apply -f ${path}/${appName}/${appName}.yaml -n lamp

echo "Déploiement effectué"

cat << EOF > ${path}/${appName}/delete-${appName}.sh
kubectl delete service -n lamp ${appName}-service
kubectl delete deployments.apps -n lamp ${appName}-deployment
kubectl delete pvc -n lamp ${appName}-pvc
kubectl delete pv ${appName}-pv
kubectl delete ingress -n lamp ${appName}-ingress
sudo rm -r ${path}/${appName}
EOF
chmod +x ${path}/${appName}/delete-${appName}.sh
rm $path/var.txt
