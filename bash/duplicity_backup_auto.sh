#!/bin/bash

# script de backup duplicity
# author: gsimar
# created : 22/04/2017

##Variables
LOG=/home/user/duplicity.log
FROM=/home/user/folder/to/save
TO=ftps://userftp:mdpftp@ftp.domaine.net/folder/destination/
PASSPHRASE=duplicitypassphrase
TIME=20D
#Functions
info()
{
    echo "---- $(date)----" >> $LOG 2>&1
}

init()
{
    echo "---- init ----"
    export PASSPHRASE
    echo "---- Ready to work ----"
}

normal()
{
    echo "---- LAUNCH BACKUP ----" >> $LOG 2>&1
    duplicity --log-file $LOG --progress $FROM $TO
    echo "---- FINISH ----" >> $LOG 2>&1
}

incremental()
{
    echo "---- LAUNCH INCREMENTAL BACKUP ----" >> $LOG 2>&1
    duplicity incremental --log-file $LOG --progress $FROM $TO
    echo "---- FINISH ----" >> $LOG 2>&1
}

remove-older()
{
    echo "---- Removing older backup ----"
    echo "time set : $TIME"
    duplicity remove-older-than $TIME $TO --force
    echo "done"
}

#Main
info
#incremental // => to force only incremental save
init
normal // => will do first one full then try incremental by default
remove-older
info
