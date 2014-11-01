#!/bin/bash
# Script use to save the database collections

VERSION="0.1"
HOME=~
ORIGIN=`pwd`
SXCMD_DIRNAME=.sxcmd
SXCMD_PATH=$HOME/$SXCMD_DIRNAME
CMDS_REQUIRED="tar git curl"
EP="[sxcmd-install]"
SOURCE_URL="https://github.com/startxfr/sxcmd/tarball/versions/$VERSION"
SOURCE_FILE="source.tar.gz"

echo $EP ""
echo $EP "  +-----------------+"
echo $EP "  | SXCMD Installer |"
echo $EP "  +-----------------+"
echo $EP "    version : " $VERSION
echo $EP ""


# Test if mandatory bin exists on this system
for i in $CMDS_REQUIRED
do
    command -v $i &> /dev/null && continue || { echo "$i command not found. Try yum install $i and restart this installer."; exit 1; }
done

# Create the sxcmd user directory
if [ ! -d $SXCMD_PATH ]; then
    echo $EP "adding $SXCMD_DIRNAME directory"
    mkdir $SXCMD_PATH
fi;

# Download and install
cd $SXCMD_PATH
rm -rf *
echo $EP "downloading source file "
curl -LkSs $SOURCE_URL -o $SXCMD_PATH/$SOURCE_FILE
if [ -e $SXCMD_PATH/$SOURCE_FILE ]; then
    echo $EP "extracting program "
    tar xzvf $SOURCE_FILE &> /dev/null
    mv startxfr-*/* . > /dev/null
    rm -rf startxfr-* > /dev/null
    echo $EP "cleanup installation "
    REMOVE="install.sh .gitignore"
    for i in $REMOVE; do
        rm -f $i > /dev/null
    done   
    cd - > /dev/null
    rm -f $SOURCE_FILE > /dev/null
    cd $ORIGIN > /dev/null
    rm -f install.sh > /dev/null
    echo $EP "register program"
    echo "" >> $HOME/.bashrc
    echo "export PATH=\$PATH:$SXCMD_PATH/bin"  >> $HOME/.bashrc
    source ~/.bashrc
    echo $EP "SUCCESS : Installation is completed and you can start to use the 'sxcmd' from the commande line (if it doesn't work, start a new terminal !)"
    exit;
else
    echo $EP "FATAL : Could not download sources from server"
    exit;
fi;
