### BEGIN INIT INFO
# Provides: unicorn_idigitallsports
# Required-Start: $local_fs $remote_fs $network
# Required-Stop: $local_fs $remote_fs $network
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: start and stop unicorn for idigitallsports.com
### END INIT INFO

# Source function library.
. /lib/lsb/init-functions

APP_NAME=idigitallsports
PATH=/usr/local/rvm/wrappers/$APP_NAME:/usr/local/sbin:/usr/local/bin:$PATH
prog=unicorn
DAEMON_NAME=$prog"_$APP_NAME"
RAILS_ROOT=/home/apps/$APP_NAME/current
UNICORN_CONF=$RAILS_ROOT/config/unicorn.rb
lockfile=/var/lock/unicorn.lock
pidfile=$RAILS_ROOT/tmp/pids/unicorn.pid
SLEEPMSEC=100000
RETVAL=0
ENV=production
BUNDLE="bundle"

start() {
    log_daemon_msg "Starting $prog for $APP_NAME"
    cd $RAILS_ROOT
    $BUNDLE exec $prog -c $UNICORN_CONF -E $ENV -D
    RETVAL=$?
    [ $RETVAL = 0 ] && touch ${lockfile}
    log_end_msg $RETVAL
    return $RETVAL
}

stop() {
    log_daemon_msg "Stopping $prog for $APP_NAME"
    killproc -p ${pidfile} ${prog} -QUIT
    RETVAL=$?
    [ $RETVAL = 0 ] && rm -f ${lockfile} ${pidfile}
    log_end_msg $RETVAL
}

restart() {
    log_daemon_msg "Restarting $prog for $APP_NAME"
    killproc -p ${pidfile} ${prog} -USR2
    RETVAL=$?
    log_end_msg $RETVAL
}

reload() {
    log_daemon_msg "Reloading $prog for $APP_NAME"
    killproc -p ${pidfile} ${prog} -HUP
    RETVAL=$?
    log_end_msg $RETVAL
}

status() {
    status_of_proc -p ${pidfile} ${prog}
}
 
# See how we were called.
case "$1" in
    start)
        status >/dev/null 2>&1 && exit 0
        start
        ;;
    stop)
        stop
        ;;
    status)
        status
        RETVAL=$?
        ;;
    restart|upgrade)
        restart
        ;;
    force-restart)
        if status >/dev/null 2>&1; then
            stop
            start
        fi
        ;;
    force-reload|reload)
        reload
        ;;
    *)
        echo $"Usage: $prog {start|stop|restart|upgrade|force-restart|reload|force-reload|status|help}"
        RETVAL=2
esac

exit $RETVAL