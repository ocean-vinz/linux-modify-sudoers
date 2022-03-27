#!/bin/bash

match_user=t810776
new_user=t821453
linux_folder=/etc/sudoers.d/*               #/etc/sudoers.d/*
sunos_folder=/usr/local/etc/sudoers         #/usr/local/etc/sudoers
aix_folder=/etc/sudoers                     #/etc/sudoers


append_sudoers() {
    grep -ld skip $match_user $linux_folder | while read filename
    do
        onlyfilename=$(basename -- $filename)
        (grep -q $new_user $filename)              #test for duplicate
        if [ $? != 0 ]
        then
            chmod 0660 $filename
            cp $filename ~/$onlyfilename\_sudoers_backup_$(date "+%Y%m%d-%H%M.%S") #backup to ~/homefolder
            sed -i "s/\<${match_user}\>/&,${new_user}/" $filename
            chmod 0440 $filename
            visudo -cf $filename
            sleep 1
        fi
    done
}

append_sudoers_SOLARIS() {
    grep -l $match_user $1 | while read filename
    do
        (grep $new_user $filename)              #test for duplicate
        if [ $? != 0 ]
        then
            chmod 0660 $filename
            cp $filename ~/sudoers_backup_$(date "+%Y%m%d-%H%M.%S") #backup to ~/homefolder
            sed "s/\<${match_user}\>/&,${new_user}/" $filename > $filename\-temp
            mv $filename\-temp $filename
            chmod 0440 $filename
            #visudo -cf $filename
            sleep 1
        fi
    done
}

append_sudoers_AIX() {
    grep -l $match_user $1 | while read filename
    do
        (grep $new_user $filename)              #test for duplicate
        if [ $? != 0 ]
        then
            chmod 0660 $filename
            cp $filename ~/sudoers_backup_$(date "+%Y%m%d-%H%M.%S") #backup to ~/homefolder
            sed "s/${match_user}/&,${new_user}/" $filename > $filename\-temp
            mv $filename\-temp $filename
            chmod 0440 $filename
            #visudo -cf $filename
            sleep 1
        fi
    done
}

if [ $(uname) == 'Linux' ]
then
    append_sudoers
elif [ $(uname) == 'SunOS' ]
then
    append_sudoers_SOLARIS $sunos_folder
elif [ $(uname) == 'AIX' ]
then
    append_sudoers_AIX $aix_folder
else
    echo "OS NOT RECOGNISE"
fi
