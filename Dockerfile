FROM qxip/docker-devuan:latest
MAINTAINER Lorenzo Mangani, lorenzo.mangani@gmail.com

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

# set mysql password
RUN echo 'mysql-server mysql-server/root_password password CGRateS.org' | debconf-set-selections && echo 'mysql-server mysql-server/root_password_again password CGRateS.org' | debconf-set-selections \

&& echo "deb http://repo.mysql.com/apt//debian/ jessie mysql-apt-config" >> /etc/apt/sources.list && \
  echo "deb http://repo.mysql.com/apt//debian/ jessie mysql-5.7" >> /etc/apt/sources.list && \
  echo "deb http://repo.mysql.com/apt//debian/ jessie connector-python-2.0 connector-python-2.1 router-2.0 mysql-utilities-1.5 mysql-tools" >> /etc/apt/sources.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8C718D3B5072E1F5 && apt-get update && apt-get -y --no-install-recommends install mysql-community-server libmysqlclient20 \
  # service mysql start \

# install dependencies
&& apt-get -y update && apt-get -y install git redis-server python-pycurl python-mysqldb sudo wget vim zsh tmux rsyslog ngrep curl \

# add cgrates user
&& useradd -c CGRateS -d /var/run/cgrates -s /bin/false -r cgrates \

# install golang
&& wget -qO- https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz | tar xzf - -C /root/ \

#install glide
&& GOROOT=/root/go GOPATH=/root/code /root/go/bin/go get github.com/Masterminds/glide \

# cleanup
&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \

# get cgrates from github
&& mkdir -p /root/code/src/github.com/cgrates; cd /root/code/src/github.com/cgrates; git clone https://github.com/cgrates/cgrates.git \

# create link to cgrates dir
&& ln -s /root/code/src/github.com/cgrates/cgrates /root/cgr \

# get deps
&& cd /root/cgr; GOROOT=/root/go GOPATH=/root/code PATH=$GOROOT/bin:$GOPATH/bin:$PATH glide install \

# build cgrates
&& cd /root/cgr; GOROOT=/root/go GOPATH=/root/code PATH=$GOROOT/bin:$GOPATH/bin:$PATH ./build.sh \

# create links
&& ln -s /root/code/bin/cgr-engine /usr/bin/ \
&& ln -s /root/code/bin/cgr-loader /usr/bin/ \
&& ln -s /root/code/src/github.com/cgrates/cgrates/data /usr/share/cgrates \
&& echo 'export GOROOT=/root/go; export GOPATH=/root/code; export PATH=$GOROOT/bin:$GOPATH/bin:$PATH'>>/root/.bashrc

COPY entrypoint.sh /entrypoint.sh

# set start command
CMD entrypoint.sh
