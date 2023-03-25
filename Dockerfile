FROM debian:sid
WORKDIR /data
EXPOSE 80
RUN apt update > /dev/null 2>&1\
 && apt -y install locales-all nginx postgresql > /dev/null 2>&1\
# && locale -a\
 && su - postgres -s /bin/sh -c "export LANG=en_US.UTF-8;export LC_ALL=en_US.UTF-8;export LC_CTYPE=en_US.UTF-8\
 && /usr/lib/postgresql/15/bin/initdb -D /var/lib/postgresql/data \
 && /usr/lib/postgresql/15/bin/pg_ctl -D /var/lib/postgresql/data -l /dev/null start"\
 && su - postgres -s /bin/sh -c "export LANG=en_US.UTF-8;export LC_ALL=en_US.UTF-8;export LC_CTYPE=en_US.UTF-8\
 && createuser dendrite"\
 && su - postgres -s /bin/sh -c "export LANG=en_US.UTF-8;export LC_ALL=en_US.UTF-8;export LC_CTYPE=en_US.UTF-8\
 && createdb -O dendrite -E UTF-8 dendrite"
COPY nginx.conf /data/nginx/nginx.conf
COPY dendrite /data/
COPY dendrite.yaml /data/
COPY generate-keys /data/
CMD cp /data/nginx/nginx.conf /etc/nginx/nginx.conf\
 && nginx\
 && su - postgres -c "/usr/lib/postgresql/15/bin/pg_ctl -D /var/lib/postgresql/data -l /dev/null start"\
 && /data/generate-keys -private-key matrix_key.pem\
 && /data/dendrite -http-bind-address=127.0.0.1:8008
