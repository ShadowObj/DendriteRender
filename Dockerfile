FROM debian:sid
WORKDIR /data
EXPOSE 80
RUN sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'\
 && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -\
 && sudo apt-get update\
 && sudo apt -y install postgresql nginx\
 && sudo psql\
 && (sudo -u postgres createuser -P dendrite;sleep 5;echo 2c1c59f801a84e42bfb12e15d4aadcb1;sleep 5;echo 2c1c59f801a84e42bfb12e15d4aadcb1)\
 && sudo -u postgres createdb -O dendrite -E UTF-8 dendrite
COPY nginx.conf /etc/nginx/nginx.conf
COPY dendrite /data/
COPY generate-keys /data/
CMD nginx;psql;/data/generate-keys -private-key matrix_key.pem;/data/dendrite
