FROM alpine:3.12

RUN set -ex \
    && apk update \
    && apk upgrade \
    && apk add --no-cache tzdata git nodejs moreutils npm curl jq openssh-client \
    && rm -rf /var/cache/apk/* \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && npm config set registry https://registry.npm.taobao.org

# 需要将jd_scripts项目放到这个目录，如：git clone -b main git@github.com:JDHelloWorld/jd_scripts.git
COPY ./jd_scripts /scripts
COPY ./crontab_list.cron /crontab_list.cron

RUN cd /scripts \
    && npm install \
    && npm install typescript \
    && npm install ts-node \
    && ln -s /scripts/node_modules/ts-node/dist/bin.js /usr/bin/ts-node

WORKDIR /scripts

RUN { \
        echo "#!/bin/sh"; \
        echo "crontab /crontab_list.cron"; \
        echo "crond -f"; \
    } | tee /start.sh \
    && chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
