###
#   Dockerfile for Fossil 
#
#   Although it works fine, there is a one little thing which is not 100%
#   correct: the fossil repository is created at Docker image creation time,
#   which means everyone using the same docker image will have the same
#   server ID and project ID.
#
# This is a fork of nijtmans/fossil, changed to use ubuntu & apt-get
# and with a VOLUME directive to persist data.
# The fossil commands have also been changed to work with v1.27
#
###
FROM ubuntu

### Now install some additional parts we will need for the build
RUN apt-get update -y  && apt-get clean all
RUN apt-get install -y fossil && apt-get clean all

RUN groupadd -r fossil -g 433 && useradd -u 431 -r -g fossil -d /opt/fossil -s /sbin/nologin -c "Fossil user" fossil

VOLUME /opt/fossil

RUN mkdir -p /opt/fossil
RUN chown fossil:fossil /opt/fossil

USER fossil

ENV HOME /opt/fossil

RUN fossil new -A admin /opt/fossil/fossil.fossil
RUN fossil user password -R /opt/fossil/fossil.fossil admin admin
#RUN fossil cache init -R /opt/fossil/fossil.fossil

EXPOSE 8080

CMD ["/usr/bin/fossil", "server", "/opt/fossil/fossil.fossil"]

