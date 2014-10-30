#!/bin/bash
# Script use to save the database collections

homedir=~
origin=`pwd`
userdir=.sxcmd
ep="[sxcmd-install]"
sourceurl="https://github.com/startxfr/sxcmd/archive/"
sourcefile="master.zip"

echo $ep ""
echo $ep "  +-----------------+"
echo $ep "  | SXCMD Installer |"
echo $ep "  +-----------------+"
echo $ep ""

if [ ! -d $homedir/$userdir ]; then
    echo $ep "adding $userdir directory"
    mkdir $homedir/$userdir
fi;

cd $homedir/$userdir
echo $ep "downloading source file "
curl $sourceurl/$sourcefile > $homedir/$userdir/$sourcefile
if [ -e $homedir/$userdir/$sourcefile ]; then
    echo $ep "extracting program "
    unzip $sourcefile &> /dev/null
    if [ -d $homedir/$userdir/sxcmd-master ]; then
        cd sxcmd-master
        echo $ep "cleanup installation "
        rm -f install.sh .gitignore
        mv * ../
        cd -
        rm -f $sourcefile
        cd $origin &> /dev/null
        rm -f install.sh
        echo $ep "register program"
        echo "" >> $homedir/.bashrc
        echo "export PATH=\$PATH:$homedir/$userdir/bin"  >> $homedir/.bashrc
        . ~/.bashrc
        echo $ep "SUCCESS : Installation is completed and you can start to use the 'sxcmd' from the commande line (if it doesn't work, start a new terminal !)"
        exit;
    else
        rm -f $homedir/$userdir/$sourcefile
        echo $ep "ERROR : Could not find sxcmd-master in source code"
        exit;
    fi;
else
    echo $ep "FATAL : Could not download sources from server"
    exit;
fi;