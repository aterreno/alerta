#!/bin/bash

docker run -h=alerta -e=ALERTA_CONF=/root/alerta.conf -d  aterreno/alerta
