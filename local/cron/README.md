# cron

## how to setup
```
crontab ./crontab
```

----

## umauma.github.io-md
### how to setup
```
mkdir -p $HOME/github.com/
go get -u github.com/umaumax/gms
# NOTE: gms bin path is $HOME/go/bin/gms
git clone https://github.com/umaumax/umaumax.github.io-md.git -O $HOME/github.com/
```

### how to run
```
*/5 * * * * $HOME/github.com/umauma.github.io-md/daemon.sh
```

## gms-daemon
### how to setup
included in this dofiles repo

### how to run
```
*/5 * * * * $HOME/dotfiles/local/cron/gms-daemon.sh
```
