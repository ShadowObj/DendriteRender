FROM debian:sid
WORKDIR /data
EXPOSE 80
RUN apt update -q\
 && apt -y -q install locales-all nginx postgresql\
# && locale -a\
 && su - postgres -s /bin/sh -c "export LANG=en_US.UTF-8;export LC_ALL=en_US.UTF-8;export LC_CTYPE=en_US.UTF-8\
 && /usr/lib/postgresql/15/bin/initdb -D /var/lib/postgresql/data \
 && /usr/lib/postgresql/15/bin/pg_ctl start -D /var/lib/postgresql/data"\
 && su - postgres -s /bin/sh -c "export LANG=en_US.UTF-8;export LC_ALL=en_US.UTF-8;export LC_CTYPE=en_US.UTF-8\
 && (createuser -P dendrite;sleep 5;echo 2c1c59f801a84e42bfb12e15d4aadcb1;sleep 5;echo 2c1c59f801a84e42bfb12e15d4aadcb1;sleep 1)"\
 && su - postgres -s /bin/sh -c "export LANG=en_US.UTF-8;export LC_ALL=en_US.UTF-8;export LC_CTYPE=en_US.UTF-8\
 && createdb -O dendrite -E UTF-8 dendrite"
COPY nginx.conf /etc/nginx/nginx.conf
COPY dendrite /data/
COPY dendrite.yaml /data/
COPY generate-keys /data/
CMD nginx && su - portgres -s /bin/sh -c "/usr/lib/postgresql/15/bin/pg_ctl start -D /var/lib/postgresql/data"\
 && /data/generate-keys -private-key matrix_key.pem\
 && /data/dendrite -http-bind-address=0.0.0.0:8008
