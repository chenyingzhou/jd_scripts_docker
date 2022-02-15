#!/bin/bash

for s in `ls /scripts |grep '\.[jt]s$'`;do
  tsc $s >/dev/null 2>&1
  script=${s:0:-3}
  rand=$(($RANDOM % 60))
  echo "$rand * * * * export \$(cat /crontab.env) && node /scripts/$script >>/logs/$script.log 2>&1" >> /crontab.cron
done

env >/crontab.env
crontab /crontab.cron
cron -f
