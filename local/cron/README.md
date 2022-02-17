# cron

## how to setup
``` bash
crontab ./crontab
```

## gms-daemon
### how to setup
``` bash
go get -u github.com/umaumax/gms
```

### crontab setting
```
*/5 * * * * $HOME/dotfiles/local/cron/gms-daemon.sh
```
