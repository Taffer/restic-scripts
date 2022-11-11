#!/bin/sh
#
# Back up to local restic repo.

# Nonsense for notify-send...
export DISPLAY=:0.0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

# TODO: Edit this! Put your B2 bucket name and the name you'd like for your
# restic repository (it'll show up as a directory in your B2 bucket).
#
# Set B2_ACCOUNT_ID and B2_ACCOUNT_KEY to your B2 application key ID and the
# B2 application key. See the restic docs for details.
#
# I keep the B2 account key and my restic repo password in files under
# ~/config that are only readable by me. This isn't super secure; keep
# important/valuable passwords in a password manager.
export RESTIC_REPOSITORY=b2:put-your-b2-bucket-name-here:put-your-restic-repository-name-here
export B2_ACCOUNT_ID=put-your-account-ID-here
export B2_ACCOUNT_KEY=$(cat $HOME/.config/restic-b2-key)
export RESTIC_PASSWORD_FILE=$HOME/.config/restic-password

restic $@ \
    --exclude-caches \
    --exclude-file=$HOME/.config/restic-excludes \
    backup ~

if [ $? -ne 0 ] ; then
    notify-send -a "B2 Backup" -h "string:desktop-entry:org.kde.konsole" FAILED "B2 backup failed, check the logs."
    exit 1
fi

notify-send -a "B2 Backup" -h "string:desktop-entry:org.kde.konsole" Completed "B2 backup has finished."

restic $@ check

restic $@ forget --prune \
    --keep-daily 7 \
    --keep-weekly 4 \
    --keep-monthly 3
