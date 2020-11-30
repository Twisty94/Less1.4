
# Nginx Dockerfile

# Выбираем образ Debian9
FROM debian:9 as build

# Установка nginx.
RUN \
#  add-apt-repository -y ppa:nginx/stable && \
  apt update && apt install -y wget gcc make && \
  wget https://nginx.org/download/nginx-1.19.3.tar.gz && \
  tar -zxvf nginx-1.19.3.tar.gz && \
  cd nginx-1.19.3 && \
# Модули nginx
  ./configure --without-http_gzip_module --without-http_rewrite_module && \
  make && \
  make install

# Выбираем образ
FROM debian:9

# Рабочий каталог.
WORKDIR /usr/local/nginx/sbin

# Копируем всё необходимое
COPY --from=build /usr/local/nginx/sbin/nginx .
COPY  nginx.conf /usr/local/nginx/sbin
# Команла Nginx.
RUN \
  mkdir ../logs ../conf && touch ../logs/error.log && chmod +x nginx && \
  apt update && apt install -y wget gcc make && \
  wget https://openresty.org/download/nginx-1.19.3.tar.gz && \
  tar -xzvf nginx-1.19.3.tar.gz && \
  cd nginx-1.19.3 && \
  export LUAJIT_LIB = / path / to / luajit / lib \
  export LUAJIT_INC = /path/to/luajit/include/luajit-2.0 \
  export LUAJIT_LIB = / path / to / luajit / lib \
  export LUAJIT_INC = /path/to/luajit/include/luajit-2.1 \
  ./configure --prefix=/usr/local/nginx/sbin --with-ld-opt="-Wl,-rpath,/path/to/luajit/lib" --add-module=/path/to/lua-nginx-module && \
  make -j2 && \
  make install
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off"]

# Монтируемый каталоги.
VOLUME ["/usr/local/nginx/sbin"]

# Используемые порты.
EXPOSE 80
EXPOSE 443


#Передаем во вторую сборку с
#FROM alpine:latest
