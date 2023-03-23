FROM debian:sid
WORKDIR /data
EXPOSE 80
RUN sudo apt-get update\
 && sudo apt -y install postgresql nginx\
# && (sudo -u postgres createuser -P dendrite;sleep 5;echo 2c1c59f801a84e42bfb12e15d4aadcb1;sleep 5;echo 2c1c59f801a84e42bfb12e15d4aadcb1)\
# && sudo -u postgres createdb -O dendrite -E UTF-8 dendrite
COPY nginx.conf /etc/nginx/nginx.conf
COPY dendrite /data/
COPY generate-keys /data/
CMD nginx;sleep 3650d
