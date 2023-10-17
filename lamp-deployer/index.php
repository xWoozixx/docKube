<?php
$maxStorageSize=10
 ?>
<html>
<head>
    <title>Déployez un LAMP</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <h1>Bienvenue sur le kubernetes du Vice-rectorat !</h1>
    <p>
        Ici vous pouvez déployer un environnement LAMP,
        <br><br>
        Les champs sans * sont facultatifs.
    </p>

<br><br>
<h1 id="error">
<?php
if (isset($_GET["erreur"]) && $_GET["erreur"] == 1) {
    echo "Veuillez respecter la taille maximale !";
}

// Récupérer l'URL à partir du paramètre GET
if (isset($_GET['url'])) {
    $url = $_GET['url'];
    echo "Voici l'URL de votre site : $url <br><br> Veuillez l'enregistrer";
}
?>
</h1>
<br><br>

<!-- Le reste de votre formulaire HTML -->


    <h1>Déploiement d'application</h1>
    <form method="POST" action="deploy.php">

        <input type="hidden" id="maxStorageSize" name="maxStorageSize" value="<?php echo $maxStorageSize; ?>">

        <label for="appName">Nom de l'application * :</label>
        <input type="text" id="appName" name="appName" pattern="^[a-z0-9]+(-[a-z0-9]+)*$" maxlength="50" required><br><br>

        <label for="storageSize">Taille du stockage en Gio (max = <?php echo($maxStorageSize) ?>) * :</label>
        <input type="text" id="storageSize" name="storageSize" pattern="^([1-9][0-9]?)$" required><br><br>

        <!-- Champ Git Repository facultatif -->
        <label for="gitRepository">Répertoire Git : </label>
        <input type="text" id="gitRepository" name="gitRepository"> (Uniquement les repos publiques) <br><br>

        <input type="submit" value="Déployer l'application">
    </form>
</body>
</html>


git clone https://gitlab-ci-token:iNQ-ASTzwDQRPA3yt-by@gitlab.in.ac-noumea.nc/dsi/bsi/ptidej.git
