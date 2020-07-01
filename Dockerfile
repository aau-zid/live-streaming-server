ARG NGINX_VERSION=1.19.0

##########################
# Build the release image.
FROM ubuntu:bionic
ENV NGINX_VERSION=1.19.0

ENV TZ=Europe/Vienna
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y software-properties-common && apt-get update && add-apt-repository ppa:jonathonf/ffmpeg-4

RUN apt-get update && apt-get install -y \
  ffmpeg \
  build-essential \
  git \
  wget \
  gcc \
  make \
  libpcre3-dev \
  libssl-dev \
  zlib1g-dev \
  gettext-base \
  certbot

RUN cd /tmp && \
  git clone https://github.com/arut/nginx-rtmp-module.git && \
  wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
  tar xzf nginx-${NGINX_VERSION}.tar.gz && \
  cd /tmp/nginx-${NGINX_VERSION} && \
  ./configure \
  --prefix=/etc/nginx \
  --sbin-path=/usr/sbin/nginx \
  --conf-path=/etc/nginx/nginx.conf \
  --add-module=../nginx-rtmp-module \
  --conf-path=/etc/nginx/nginx.conf \
  --with-threads \
  --with-file-aio \
  --with-cc-opt="-O3" \
  --with-http_ssl_module \
  --with-debug && \
  make && make install

# Cleanup.
RUN rm -rf /var/cache/* /tmp/*

# Add NGINX path, config and static files.
ENV PATH "${PATH}:/usr/local/nginx/sbin"

RUN mkdir -p /live && mkdir -p /srv/www/html
RUN chmod -R 777 /live

RUN mkdir /var/lib/certbot

COPY templates /etc/nginx/templates
COPY ./static/crossdomain.xml /srv/www/html/crossdomain.xml
COPY ./static/stat.xsl /srv/www/html/stat/stat.xsl

ENV STREAMING_SERVER_DOMAIN _

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 1935

ENTRYPOINT [ "./entrypoint.sh" ]
