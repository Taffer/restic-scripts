# restic-scripts - Restic backup scripts and systemd files

These are the simple (and hopefully straightforward) `bash` scripts that I
use to keep backups sane on my system; hopefully they can serve as an example
for setting up your own regular backups!

I'm using a multi-tiered approach:

* hourly local backups to a secondary physical disk
* daily NAS backups
* weekly-ish cloud backups to Backblaze's B2 service

I keep the last seven daily backup snapshots, last four weekly, and last
three monthly in each. Obviously that doesn't jive with my B2 schedule, but
that one's still being run by hand while I figure out how I want it to work.

*NOTE:* You'll have to edit these scripts before you can use them yourself,
I've replaced all the paths and API keys and whatnot that are specific to my
setup.

## Things You Need

You'll need a few things to set up a similar system:

* `restic` - Your distro probably has this available, but it also works on
  macOS and Windows: https://restic.net/
* `systemd` - If your OS doesn't use `systemd`, you'll have to set up your own
  periodic runs using `cron` or whatever.
* A local target for backups. If you don't have a second physical device for
  this, a separate partition will still protect you from filesystem disasters
  on your root partition.
* A network target for backups. Totally optional, but handy if your main
  system dies and you don't want to wait to download your data from the cloud.
  This protects you from computer disasters like a dying hard drive.
* A cloud target for backups. Again, totally optional, but it protects you
  from major disasters like your house burning down. I'm using Backblaze B2
  because I really like their backup service on macOS and Windows, and it's
  really cheap for this type of storage. Sure wish they had a Linux client for
  the backup service though.
  [Here](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html#backblaze-b2)
  is the `restic` documentation for using B2.

## The Scripts

The `bin` directory contains the `bash` scripts I use for doing backups. I
keep them in `$HOME/bin` and they don't require any special permissions.

The `systemd` directory contains the `.service` and `.timer` files. These go
in `$HOME/.config/systemd/user` and are enabled via `systemctl` commands like:

```sh
$ systemctl --user enable backup-local.service
$ systemctl --user enable backup-local.timer
```

I haven't set up a service/timer for the cloud backup script yet because I'm
still figuring out how I want it to work.

The intent of enabling the `.service` is to have it run when I log in, but also
when the timer goes off. Maybe I'm doing it wrong, I'm new to `systemd`.

The `restic-excludes` file also lives in `$HOME/.config`; it lists directories
that I don't want to back up, generally because I can just download the
contents again via cloud services.

## License

This is all MIT-licensed, so go nuts.
