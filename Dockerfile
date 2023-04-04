FROM debian:sid
WORKDIR /data
EXPOSE 80
RUN apt update > /dev/null 2>&1\
 && apt -y install locales-all nginx postgresql wget > /dev/null 2>&1\
 && wget https://nodejs.org/dist/v18.15.0/node-v18.15.0-linux-x64.tar.xz\
 && tar -xvf node-v18.15.0-linux-x64.tar.xz\
 && mv ./node-v18.15.0-linux-x64 /usr/local\
 && export PATH=$PATH:/usr/local/node-v18.15.0-linux-x64/bin\
 && npm install --global yarn\
 && yarn global add wetty\
 && su - postgres -s /bin/sh -c "export LANG=en_US.UTF-8;export LC_ALL=en_US.UTF-8;export LC_CTYPE=en_US.UTF-8\
 && /usr/lib/postgresql/15/bin/initdb -D /var/lib/postgresql/data\
 && /usr/lib/postgresql/15/bin/pg_ctl -D /var/lib/postgresql/data -l /dev/null start"\
 && su - postgres -s /bin/sh -c "export LANG=en_US.UTF-8;export LC_ALL=en_US.UTF-8;export LC_CTYPE=en_US.UTF-8\
 && createuser dendrite"\
 && su - postgres -s /bin/sh -c "export LANG=en_US.UTF-8;export LC_ALL=en_US.UTF-8;export LC_CTYPE=en_US.UTF-8\
 && createdb -O dendrite -E UTF-8 dendrite"
COPY nginx.conf /data/nginx/nginx.conf
COPY dendrite /data/
COPY dendrite.yaml /data/
COPY generate-keys /data/
CMD nohup wetty -p 8888 >> /var/log/wetty.log 2>&1 &\
 && cp /data/nginx/nginx.conf /etc/nginx/nginx.conf && nginx\
 && su - postgres -c "/usr/lib/postgresql/15/bin/pg_ctl -D /var/lib/postgresql/data -l /dev/null start"\
 && /data/generate-keys -private-key matrix_key.pem\
 && /data/dendrite
