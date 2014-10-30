#!/bin/bash
# Script use to save the database collections

homedir=~
userdir=.sxcmd
ep="[sxcmd-install]"
sourceurl="https://api.github.com/startxfr/sxcmd/download"
sourcefile="master.tar.gz"

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
curl -LSs $sourceurl/$sourcefile &> /dev/null
if [ ! -d $homedir/$userdir/$sourcefile ]; then
    echo $ep "extracting program "
    tar xzvf $sourcefile &> /dev/null
    echo $ep "cleanup installation "
    rm -f install.sh .gitignore
    cd - &> /dev/null
    rm -f install.sh
    echo $ep "register program"
    echo "" >> $homedir/.bashrc
    echo "export PATH=\$PATH:$homedir/$userdir/bin"  >> $homedir/.bashrc
    . $homedir/.bashrc &> /dev/null
    echo $ep "SUCCESS : Installation is completed and you can start to use the 'sxcmd' from the commande line"
    exit;
else
    echo $ep "FATAL : Could not download sources from server"
    exit;
fi;




echo "print('_ ' + db.getCollectionNames())" > $tmp_file
cols=`mongo $db $tmp_file | grep '_' | awk '{print $2}' | tr ',' ' '`
rm $tmp_file
echo_prefix="[pre-commit hook]"

# execute doc-generate and comit-push to github
function dumpDatabases {
   echo -e "$echo_prefix Start dumping database"
   for c in $cols
    do
        if [[ $c != "logs" ]] && [[ $c != "startx.logs" ]] && [[ $c != "sxapi.session" ]] ; then
        echo -e "$echo_prefix Exporting $c "
        mongoexport -d $db -c $c -o "$out_dir/dump_${db}_${c}.json" --jsonArray &> /dev/null
        fi
   done
   git add $out_dir/*
   echo -e "$echo_prefix End dumping database"
}


echo -e "$echo_prefix Start pre-commit process"
# Allows us to read user input below, assigns stdin to keyboard
exec < /dev/tty
while true; do
    read -p "$echo_prefix Do you wan't to dump database(s) ? (Y/n) " yn
    if [ "$yn" = "" ]; then
       yn='Y'
    fi
    case $yn in
       [Yy] ) dumpDatabases; exit 0;;
       [Nn] ) exit 0;;
       * ) echo -e "$echo_prefix Please answer y or n for yes or no.";;
    esac
done
echo -e "$echo_prefix End pre-commit process"
