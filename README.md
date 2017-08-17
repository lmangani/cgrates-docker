<img src="http://www.cgrates.org/img/bg/logo.png" />

# cgrates-docker
CGRates Docker Container w/ mysql, redis

## About
[CGRateS](http://www.cgrates.org) is a very fast and easily scalable (charging, rating, accounting, lcr, mediation, billing, authorization) ENGINE targeted especially for ISPs and Telecom Operators.

It is written in Go programming language and is accessible from any programming language via JSON RPC. 

## Docs
CGRateS and its Tutorials are documented in full detail at [http://cgrates.readthedocs.io](http://cgrates.readthedocs.io/en/latest/tutorials.html)

## Usage
CGRateS ships with presets for Asterisk, FreeSWITCH, OpenSIPS, Kamailio.

Use the ```TUTORIAL``` variable to define your platform of choice at execution time:

#### Asterisk
```
docker run -tid --name cgrates -e TUTORIAL='asterisk' -p 2012:2012 qxip/cgrates-docker
```

#### FreeSWITCH
```
docker run -tid --name cgrates -e TUTORIAL='freeswitch' -p 2012:2012 qxip/cgrates-docker
```

#### OpenSIPS
```
docker run -tid --name cgrates -e TUTORIAL='opensips' -p 2012:2012 qxip/cgrates-docker
```

#### Kamailio
```
docker run -tid --name cgrates -e TUTORIAL='kamailio' -p 2012:2012 qxip/cgrates-docker
```

#### Vanilla/Dev
```
docker run -tid --name cgrates -p 2012:2012 qxip/cgrates-docker
```
