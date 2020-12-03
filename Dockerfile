
# Nginx Dockerfile

# Выбираем образ Debian9
FROM debian:9 as build

# Установка nginx из исходников и необхидимые пакеты.
RUN \
  apt update && apt install -y wget gcc make && \
  apt install -y build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev zlib1g zlib1g-dev && \
  wget https://nginx.org/download/nginx-1.19.3.tar.gz && \
  tar -zxvf nginx-1.19.3.tar.gz && \
  cd nginx-1.19.3 && \
# Модули nginx cтандартные
  ./configure  && \
  make && \
  make install

# Выбираем образ Debian9
FROM debian:9

# Рабочий каталог.
WORKDIR /usr/local/nginx/sbin

# Копируем всё необходимое из 1 стейджа
COPY --from=build /usr/local/nginx/sbin/nginx .
COPY  nginx.conf /usr/local/nginx/sbin

# Установка LuaJIT
#RUN \
#  apt update && apt install -y wget gcc make && \
#  cd /usr/local/src && \
#  wget https://github.com/openresty/luajit2/archive/v2.1-20201027.tar.gz && \
#  tar xf v2.1-20201027.tar.gz && \
#  cd luajit2-2.1-20201027 && \
#  make && \
#  make PREFIX=/usr/local/luajit install

#RUN \
# Установка nginx c lua-nginx-module
# Необходимые packet
#  apt install -y build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev zlib1g zlib1g-dev && \
# Загрузка исходников
#  export LUAJIT_LIB=/usr/local/luajit/lib && \
#  export LUAJIT_INC=/usr/local/luajit/include/luajit-2.1 && \
#  cd /usr/local/src && \
#  wget https://github.com/vision5/ngx_devel_kit/archive/v0.3.1.tar.gz && \
#  wget https://github.com/openresty/lua-nginx-module/archive/v0.10.19.tar.gz && \
#  wget https://nginx.org/download/nginx-1.19.3.tar.gz -O nginx-1.19.3.tar.gz && \
# Pазпаковка
#  tar -xzvf v0.3.1.tar.gz && \
#  tar -xzvf v0.10.19.tar.gz && \
#  tar -xzvf nginx-1.19.3.tar.gz && \
#  cd nginx-1.19.3 && \


#  ./configure --prefix=/usr/local/nginx/sbin --with-ld-opt="-Wl,-rpath,$LUAJIT_LIB" --add-module=/usr/local/src/ngx_devel_kit-0.3.1 --add-module=/usr/local/src/lua-nginx-module-0.10.19 && \
#  make && \
#  make install

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off"]

# Монтируемый каталоги.
VOLUME ["/usr/local/nginx/sbin"]

# Используемые порты.
EXPOSE 80
EXPOSE 443
#https://github.com/danday74/docker-nginx-lua/blob/master/Dockerfile
