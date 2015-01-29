<?php

$VERSION = "dev/cl";
$SXCMD_PATH = "~/.sxcmd";
$EP = "[sxcmd]";
$cwd = trim(shell_exec("pwd"));

function ask($q) {
    return trim(shell_exec("read -p '$q ' q\necho \$q"));
}

function displayIntro() {
    global $EP, $VERSION, $cwd;
    echo "$EP\n";
    echo "$EP   +-----------------------------------+\n";
    echo "$EP   | SXCMD : STARTX command line tools |\n";
    echo "$EP   +-----------------------------------+\n";
    echo "$EP    Version : $VERSION\n";
    echo "$EP    Chemin  : $cwd\n";
}

function displayMenuPrincipal() {
    global $EP;
    echo "$EP\n";
    echo "$EP -- Menu principal\n";
    echo "$EP    Choisissez une option parmis les actions suivantes :\n";
    echo "$EP\n";
    echo "$EP 1. Projet\n";
    echo "$EP 8. Test\n";
    echo "$EP 9. Exit\n";
    echo "$EP\n";
    switch (ask("$EP    Votre choix : ")) {
        case "1":
            displayMenuProject();
            break;
        case "8":
            displayMenuTest();
            break;
        case "9":
            exit;
            break;
        default:
            displayMenuPrincipal();
            break;
    }
}

function displayMenuProject() {
    global $EP, $cwd;
    if (file_exists($cwd . '/.startx/sxcmd')) {
        system($cwd . '/.startx/sxcmd');
    } elseif (file_exists($cwd . '/.sxcmd/sxcmd')) {
        system($cwd . '/.sxcmd/sxcmd');
    } else {
        echo "$EP\n";
        echo "$EP -- Menu projet\n";
        echo "$EP    Le dossier courant n'est pas un projet sxcmd\n";
        echo "$EP    Veuillez créer un dossier .startx et un script\n";
        echo "$EP    de commande\n$EP\n";
        echo "$EP    Appuyez sur entrée\n";
        switch (ask("$EP")) {
            default:
                displayMenuPrincipal();
                break;
        }
    }
}

function displayMenuTest() {
    global $EP;
    echo "$EP\n";
    echo "$EP -- Menu Test\n";
    echo "$EP    Choisissez une option parmis les actions suivantes :\n";
    echo "$EP\n";
    echo "$EP 9. Retour menu principal\n";
    switch (ask("$EP    Votre choix : ")) {
        case "9":
            displayMenuPrincipal();
            break;
        default:
            displayMenuTest();
            break;
    }
}

if (file_exists($cwd . '/.startx/sxcmd')) {
    system($cwd . '/.startx/sxcmd');
} elseif (file_exists($cwd . '/.sxcmd/sxcmd')) {
    system($cwd . '/.sxcmd/sxcmd');
} else {
    displayIntro();
    displayMenuPrincipal();
}
