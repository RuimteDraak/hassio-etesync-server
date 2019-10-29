ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache \
  git \
  python3 \
  python3-dev \
  py-pip \
  build-base \
  net-tools \
  nginx \
  uwsgi-python3 \
  supervisor \
  && pip install virtualenv \
  && cd /etc \
  && git clone https://github.com/etesync/server.git \
  && cd server \
  && virtualenv --python=/usr/bin/python3 venv \
  && source venv/bin/activate \
  && pip install -r requirements.txt \
  \
  && adduser -D -s /bin/bash EtesyncUser \
  && ./manage.py collectstatic \
  && chown -R root:www-data \static \
  && rm -f /etc/nginx/fastcgi.conf /etc/nginx/fastcgi_params \
  && rm -f /etc/nginx/snippets/fastcgi-php.conf

### COPY's are handled by 1 rootfs copy
# COPY nginx/ssl /etc/nginx/ssl

COPY ./rootfs /

#TODO Run through supervisord

WORKDIR /etc/server

COPY ./files ./

CMD source venv/bin/activate && exec sh run.sh