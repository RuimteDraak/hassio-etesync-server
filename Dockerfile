ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache \
  git \
  build-base \
  net-tools \
  nginx \
  uwsgi-python3 \
  supervisor \
  \
  && pip install chevron \
  && cd /etc \
  && git clone https://github.com/etesync/server.git \
  && cd server \
  && pip install -r requirements.txt \
  \
  && adduser -D -s /bin/bash EtesyncUser \
  && mkdir /etc/server/etesync_server/static \
  && ln -s /etc/server/etesync_server/static ./static \
  && ./manage.py collectstatic \
  && chown -R root:www-data ./ \
  && chmod -R 754 ./ \
  && rm -f /etc/nginx/fastcgi.conf /etc/nginx/fastcgi_params \
  && rm -f /etc/nginx/snippets/fastcgi-php.conf

COPY ./rootfs /

WORKDIR /etc/server
RUN chmod +x ./run.sh

CMD exec ./run.sh
