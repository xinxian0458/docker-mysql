# base image
FROM ubuntu:latest

# set environment
ENV DEBCONF_FILE /tmp/mysql-pw
ENV MYSQL_ROOT_PASSWORD password

# install mysql and supervisor
RUN \
	apt-get update && \
	apt-get clean && \
	sh -c 'echo "debconf mysql-server/root_password password ${MYSQL_ROOT_PASSWORD}" > ${DEBCONF_FILE}' && \
	sh -c 'echo "debconf mysql-server/root_password_again password ${MYSQL_ROOT_PASSWORD}" >> ${DEBCONF_FILE}' && \
	debconf-set-selections ${DEBCONF_FILE} && \
	apt-get install -y mysql-server && \
	chown -R mysql:mysql /var/lib/mysql && \
	sed -i 's/bind-address.*/bind-address\=0\.0\.0\.0/g' /etc/mysql/my.cnf

# set work dir
WORKDIR /home/ubuntu

# set volume
VOLUME /var/lib/mysql

# copy start script
ADD scripts/start.sh /home/ubuntu/
ADD scripts/upgrade.sh /home/ubuntu/
RUN chmod +x /home/ubuntu/*.sh 

# expose 3306 port
EXPOSE 3306

# start the container via start.sh
ENTRYPOINT ["/bin/bash"]
CMD ["./start.sh"]

