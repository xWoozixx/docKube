<?php
$path="/home/remi/lamp";
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $maxStorageSize = $_POST["maxStorageSize"];
    $appName = $_POST["appName"];
    $storageSize = $_POST["storageSize"];
    $gitRepository = $_POST["gitRepository"];

//    echo "gitRepository raw :$gitRepository <br>";


    if($storageSize>$maxStorageSize){

        // Redirection vers la page d'accueil avec un message d'erreur
        header("Location: index.php?erreur=1");
        exit; // Redirection vers le formulaire avec un message d'erreur
}
    $url=$appName.".k.in.ac-noumea.nc";
    if($gitRepository!=""){
        $fileName= parse_url($gitRepository, PHP_URL_PATH);
        $fileName= pathinfo($fileName, PATHINFO_FILENAME); //on récupère le nom du dossier
        $url=$url."/".$fileName; //on prépare l'url du site pour la donner à l'utilisateur

        $gitRepository="&& git clone ".$gitRepository;

}
//    echo "gitRepository modified :$gitRepository <br>";

    // Sauvegarde des données dans le fichier var.txt

    $storageSize=$storageSize."Gi";
    $varFileContent = "appName=$appName\nstorageSize=$storageSize\ngitRepository=$gitRepository";
    $output = shell_exec("cat << EOF > $path/var.txt
$varFileContent
EOF");

//    echo "Texte écrit : <br> $varFileContent";

    // Exécution du script newApp.sh
    $output = shell_exec("$path/newApp.sh");

    // Afficher le résultat de l'exécution du script
//    echo "<pre>$output</pre>";


// Rediriger automatiquement vers index.php avec l'URL générée
header("Location: index.php?url=" . urlencode($url));
exit;
}
?>
