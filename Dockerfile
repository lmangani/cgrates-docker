FROM qxip/docker-devuan:latest
MAINTAINER Lorenzo Mangani, lorenzo.mangani@gmail.com

# set mysql password
RUN echo 'mysql-server mysql-server/root_password password CGRateS.org' | debconf-set-selections && echo 'mysql-server mysql-server/root_password_again password CGRateS.org' | debconf-set-selections \

# install dependencies
&& apt-get -y update && apt-get -y install git redis-server mysql-server python-pycurl python-mysqldb sudo wget vim zsh tmux rsyslog ngrep curl \

# add cgrates user
&& useradd -c CGRateS -d /var/run/cgrates -s /bin/false -r cgrates \

# install golang
&& wget -qO- https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz | tar xzf - -C /root/ \

#install glide
&& GOROOT=/root/go GOPATH=/root/code /root/go/bin/go get github.com/Masterminds/glide \

#install oh-my-zsh
&& TERM=xterm sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"; exit 0 \

# change shell for tmux
&& chsh -s /usr/bin/zsh \

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

# prepare zshrc
&& echo 'export GOROOT=/root/go; export GOPATH=/root/code; export PATH=$GOROOT/bin:$GOPATH/bin:$PATH'>>/root/.zshrc

COPY entrypoint.sh /entrypoint.sh

# set start command
CMD entrypoint.sh
