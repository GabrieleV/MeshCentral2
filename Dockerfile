FROM node:buster
LABEL Lawrence Stubbs <technoexpressnet@gmail.com>

RUN apt-get update && apt-get -y install sudo
RUN apt-get -y install sudo dirmngr gnupg apt-transport-https software-properties-common ca-certificates curl
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
RUN sudo add-apt-repository 'deb https://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main'
RUN sudo apt-get -y update
RUN apt-get -y install mongodb-org

COPY startmeshcentral.sh /
RUN adduser --quiet meshserver \
    && mkdir -p /home/meshserver/meshcentral-data \
    && chmod +x /startmeshcentral.sh \
	&& mv -f /startmeshcentral.sh /home/meshserver/meshcentral-data/startmeshcentral.sh

COPY package.json /home/meshserver/
COPY config.json /home/meshserver/meshcentral-data/
RUN su - meshserver \
	&& cd /home/meshserver \
    && npm install meshcentral 
    
ENV PORT 443  
ENV REDIRPORT 80  
ENV MPSPORT 4443
ENV EMAIL mail@host
ENV HOST host.ltd
ENV SMTP smtp.host.ltd
ENV USER smtp@user
ENV PASS smtppass!
ENV DB netdb
ENV MONGODB "mongodb://127.0.0.1:27017/meshcentral"
ENV MONGODBCOL "meshcentral"

EXPOSE 25 80 443 4443 27017 27018

ENTRYPOINT ["/home/meshserver/meshcentral-data/startmeshcentral.sh"]
