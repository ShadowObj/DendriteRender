FROM debian:sid
WORKDIR /data
EXPOSE 80
RUN echo "deb http://apt.postgresql.org/pub/repos/apt apricot-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
RUN apt-get update 2>&1 > /dev/null\
 && apt -y install nginx postgresql-15 2>&1 > /dev/null\
 && psql && su postgres\
 && (createuser -P dendrite;sleep 5;echo 2c1c59f801a84e42bfb12e15d4aadcb1;sleep 5;echo 2c1c59f801a84e42bfb12e15d4aadcb1)\
 && createdb -O dendrite -E UTF-8 dendrite
COPY nginx.conf /etc/nginx/nginx.conf
COPY dendrite /data/
COPY generate-keys /data/
CMD nginx;psql;\
/data/generate-keys -private-key matrix_key.pem;\
/data/dendrite -http-bind-address=0.0.0.0:8008
