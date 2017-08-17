# cgrates-docker
CGRates Docker Container embedded w/ mysql,redis


## Options
CGRateS comes with presets for the "big four" platforms. Use the ```TUTORIAL``` variable to define your platform of choice at execution time:

### Dev (vanilla)
```docker run -tid --name cgrates -p 2012:2012 qxip/cgrates-docker```

### Asterisk
```docker run -tid --name cgrates -e TUTORIAL='asterisk' -p 2012:2012 qxip/cgrates-docker```

### FreeSWITCH
```docker run -tid --name cgrates -e TUTORIAL='freeswitch' -p 2012:2012 qxip/cgrates-docker```

### OpenSIPS
```docker run -tid --name cgrates -e TUTORIAL='opensips' -p 2012:2012 qxip/cgrates-docker```

### Kamailio
```docker run -tid --name cgrates -e TUTORIAL='kamailio' -p 2012:2012 qxip/cgrates-docker```

## Docs
CGRateS and its Tutorials are documented in full detail at [http://cgrates.readthedocs.io/en/latest/tutorials.html](http://cgrates.readthedocs.io/en/latest/tutorials.html)
