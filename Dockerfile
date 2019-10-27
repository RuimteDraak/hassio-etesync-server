ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache \
  git \
  python3 \
  python3-dev \
  py-pip \
  build-base \
  && pip install virtualenv \
  && git clone https://github.com/etesync/server-skeleton.git \
  && cd server-skeleton \
  && virtualenv --python=/usr/bin/python3 venv \
  && source venv/bin/activate \
  && pip install -r requirements.txt

COPY ./files /server-skeleton

WORKDIR /server-skeleton

CMD ["run.sh"]