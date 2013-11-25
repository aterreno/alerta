#!/bin/bash

wget http://guest:guest@localhost:55672/cli/rabbitmqadmin && chmod +x rabbitmqadmin
./rabbitmqadmin declare exchange name=alerts type=fanout
mongo localhost/monitoring /alerta/docker/mongo-setup.js
