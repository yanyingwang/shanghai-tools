#!/usr/bin/env bash

PORT=8000

start_app()
{
    APP_ENV=development start_server --port $PORT -- clackup --server :woo app.lisp
}


watch_app()
{
    PID=$(lsof -i:8000 |grep "start_ser"|awk '{print $2}')

    while true; do
        watch -g 'git diff' && kill -HUP $PID
        PID=$(lsof -i:$PORT |grep "start_ser"|awk '{print $2}')
        [[ -z $PID ]] && exit
    done
}


case $1 in
    start)
        start_app
        ;;
    watch)
        watch_app
        ;;
    help)
        echo '
        start         # use development env and start app
        watch         # watch start-app, when code changed, then restart it
        '
        ;;
    *)
        echo "params error!!"
esac
