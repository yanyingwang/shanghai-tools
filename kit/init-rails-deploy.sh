#!/usr/bin/env bash

production=192.168.1.22
port=3333
apphome=/home/web/rails_demo

current_ip=$(/sbin/ip a s|sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}' |grep 172)


make_sure_production() {
    if [[ $current_ip != $production ]]
    then
        echo "this param only used for production server($production)!!!"
        exit 0
    fi
}

precompile() {
    RAILS_ENV=production bundle exec rake assets:precompile
}

stop() {
    test -f tmp/pids/server.pid && \
        kill -9 $(cat tmp/pids/server.pid)
}

start() {
    rails s -b 0.0.0.0 -p $port -d -e production
}

migrate() {
    rake db:migrate RAILS_ENV=production
}

pull() {
    git pull origin master
    git submodule foreach git pull origin master
}


case $1 in
    pull)
        make_sure_production
        pull
        ;;
    migrate)
        make_sure_production
        migrate
        ;;
    start)
        make_sure_production
        start
        ;;
    stop)
        make_sure_production
        stop
        ;;
    restart)
        make_sure_production
        stop
        sleep 3
        start
        ;;
    precompile)
        make_sure_production
        precompile
        ;;
    deploy)
        make_sure_production
        pull || exit 1
        bundle check
        [[ $? == 1 ]] && ( bundle || exit 1)
        migrate || exit 1
        precompile || exit 1
        stop
        sleep 3
        start
        ;;
    remote-deploy)
        ssh web@$production "cd $apphome; ./init.sh deploy"
        ;;
    remote-restart)
        ssh web@$production "cd $apphome; ./init.sh restart"
        ;;
    help)
        echo '
        pull         # git pull
        migrate      # rake db:migrate RAILS_ENV=production
        precompile   # RAILS_ENV=production bundle exec rake assets:precompile
        start        # rails s -b 0.0.0.0 -p 3344 -d -e production
        stop         # kill -9 $(cat tmp/pids/server.pid)
        restart      # kill and run server
        deploy       # run cmd above all
        remote-restart     # restart server app from local
        remote-deploy      # deploy server app from local
        '
        ;;
    *)
        echo "params error!!"
esac
