#!/bin/sh
#
# Back up to local restic repo.

# Nonsense for notify-send...
export DISPLAY=:0.0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

# TODO: Edit this! My NAS backup target is a Samba share; "a-directory" is the
# name of a directory inside the share. The share might not be mounted, so we
# bail early if we can't find the directory used for the restic repo.
BACKUP_LOCATION=/path/to/share/a-directory

if [ ! -d $BACKUP_LOCATION ] ; then
    echo "Unable to find $BACKUP_LOCATION"
    exit 1
fi

# TODO: Edit this! This is the directory that will contain your restic
# repo.
#
# I keep my restic repo password in a file under ~/config that is only readable
# by me. This isn't super secure; keep important/valuable passwords in a
# password manager.
export RESTIC_REPOSITORY=$BACKUP_LOCATION
export RESTIC_PASSWORD_FILE=$HOME/.config/restic-password

restic $@ \
    --exclude-caches \
    --exclude-file=$HOME/.config/restic-excludes \
    backup ~

if [ $? -ne 0 ] ; then
    notify-send -a "Local Backup" -h "string:desktop-entry:org.kde.konsole" FAILED "NAS backup failed, check the logs."
    exit 1
fi

notify-send -a "Local Backup" -h "string:desktop-entry:org.kde.konsole" Completed "NAS backup has finished."

restic $@ check

restic $@ forget --prune \
    --keep-daily 7 \
    --keep-weekly 4 \
    --keep-monthly 3
