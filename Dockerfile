FROM debian:sid
WORKDIR /data
EXPOSE 80
RUN apt-get update\
 && apt -y install nginx postgresql
RUN psql\
 && su postgres\
 && (createuser -P dendrite;sleep 5;echo 2c1c59f801a84e42bfb12e15d4aadcb1;sleep 5;echo 2c1c59f801a84e42bfb12e15d4aadcb1)\
 && createdb -O dendrite -E UTF-8 dendrite
COPY nginx.conf /etc/nginx/nginx.conf
COPY dendrite /data/
COPY generate-keys /data/
CMD nginx;psql;\
/data/generate-keys -private-key matrix_key.pem;\
/data/dendrite -http-bind-address=0.0.0.0:8008
