# This IBREST image relies on an IB Gateway accessible at port 4003 (intead of 4001).  Use ibheadless for that and link.
# Assume our ibheadless container is called `ibgw`
# ...so be sure to `link` this container to ibheadless accordingly

# To build docker image:
# docker build -t ibrest .

# To run docker image, use:
# `docker run -d --restart=always --name ibrest --link ibgw -e "ID_SECRET_KEY=mysecret" -p 443:443 ibrest`

# To run while developing, map your local app folder to /app as a volume on the container:
# `docker run -d --restart=always --name ibrest --link ibgw -e "ID_SECRET_KEY=mysecret" -p 443:443 -v /home/jhaury/ibrest:/app ibrest`
# or maybe
# `docker run -d --restart=always --name ibrest --link ibgw -e "ID_SECRET_KEY=mysecret" -p 443:443 -v /home/jhaury/ibrest/app:/app ibrest`



FROM tiangolo/uwsgi-nginx-flask:flask
MAINTAINER Jason Haury "jason.haury@gmail.com"
RUN apt-get update -y
RUN apt-get install -y python-pip
 #python-dev build-essential
RUN pip install --upgrade pip

#TODO for production, do this:
#COPY ./app /app
#TODO for development, do this instead:
VOLUME /app

COPY requirements.txt /
# To enable HTTPS, we need to copy certs and a new nginx.conf
COPY ./etc/nginx.conf /etc/nginx/conf.d/
# TODO be sure to create your certs!
COPY ./etc/ibrest.crt /etc/ssl/
COPY ./etc/ibrest.key /etc/ssl/

RUN pip install -r /requirements.txt
# Be sure to set environment params: IBGW_HOST and IBGW_PORT for how to connect to ibgw if you aren't linking per the "run" examples

