FROM ubuntu:20.04

RUN apt-get update \
    && sh -c '/bin/echo -e "6\n70" | apt-get install -y tzdata' \
    && apt-get install -y curl xz-utils cron \
    # install nodejs npm
    && curl -o node-v16.5.0-linux-x64.tar.xz https://nodejs.org/dist/v16.5.0/node-v16.5.0-linux-x64.tar.xz \
    && xz -d node-v16.5.0-linux-x64.tar.xz \
    && tar -xf node-v16.5.0-linux-x64.tar \
    && cp -r /node-v16.5.0-linux-x64/* /usr/ \
    && rm -rf /node-v16.5.0-linux-x64* \
    # clean
    && apt-get purge curl xz-utils -y \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 需要将jd_scripts项目放到这个目录，如：git clone -b main git@github.com:JDHelloWorld/jd_scripts.git
COPY ./jd_scripts /scripts
RUN cd /scripts \
    && npm config set registry https://registry.npm.taobao.org \
    && npm install \
    && npm install typescript -g \
    && tsc *.ts

COPY ./crontab.cron /crontab.cron
RUN { \
        echo "#!/bin/sh"; \
        echo "env >/crontab.env"; \
        echo "crontab /crontab.cron"; \
        echo "cron -f"; \
    } | tee /start.sh \
    && chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
