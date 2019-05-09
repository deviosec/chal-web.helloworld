#!/bin/sh

# simple script to start mysql and apache2, and just run
# grep every 60 secounds to see if it works (but do nothing if it doesn't)
# could be done much better, using https://github.com/just-containers/s6-overlay
# but used example from here instead - https://docs.docker.com/config/containers/multi-service_container/

# plant our flag and destroy all evidence!
sed -i "s/{{FLAG}}/${FLAG}/g" /var/www/html/index.html
unset FLAG
if [ ! -z $FLAG ]; then
    unset FLAG
    exec sh /init.sh
fi

#start nginx
/usr/sbin/nginx
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start nginx: $status"
  exit $status
fi

while sleep 60; do
  ps aux |grep apache |grep -q -v grep
  NGINX_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $NGINX_STATUS -ne 0 ]; then
    echo "Nginx has already exited."
    exit 1
  fi
done
