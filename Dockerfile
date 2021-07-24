FROM ubuntu:20.04

RUN apt-get update \
    && sh -c '/bin/echo -e "6\n70" | apt-get install -y tzdata' \
    && apt-get install -y nodejs npm cron \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 需要将jd_scripts项目放到这个目录，无论通过任何方式
# git clone git@github.com:JDHelloWorld/jd_scripts.git
COPY ./jd_scripts /scripts
COPY ./crontab_list.cron /crontab_list.cron
RUN crontab /crontab_list.cron

RUN npm install typescript -g \
    && npm install ts-node -g \
    && cd /scripts \
    && npm install

CMD ["cron", "-f"]
