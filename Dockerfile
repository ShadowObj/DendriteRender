FROM debian:sid
WORKDIR /data
EXPOSE 80
RUN apt update 2>&1 > /dev/null\
 && apt -y install nginx postgresql 2>&1 > /dev/null\
# && apt -y install nginx postgresql\
RUN su - postgres -c "psql"\
 && su - postgres -c "(createuser -P dendrite;sleep 5;echo 2c1c59f801a84e42bfb12e15d4aadcb1;sleep 5;echo 2c1c59f801a84e42bfb12e15d4aadcb1;sleep 1)"\
 && su - postgres -c "createdb -O dendrite -E UTF-8 dendrite"
COPY nginx.conf /etc/nginx/nginx.conf
COPY dendrite /data/
COPY dendrite.yaml /data/
COPY generate-keys /data/
CMD nginx && su - portgres -c "psql"\
 && /data/generate-keys -private-key matrix_key.pem\
 && /data/dendrite -http-bind-address=0.0.0.0:8008
