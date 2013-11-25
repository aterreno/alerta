FROM  ubuntu

#Packages
RUN   apt-get update
RUN   apt-get install mongodb-server rabbitmq-server python-pip wget git build-essential supervisor -y

#RabbitMQ
RUN   /usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_stomp
RUN   /usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management
RUN   service rabbitmq-server restart

RUN   wget http://guest:guest@10.250.76.174:15672/cli/rabbitmqadmin && chmod +x rabbitmqadmin
RUN   ./rabbitmqadmin declare exchange name=alerts type=fanout

RUN pip install virtualenv virtualenvwrapper

RUN export WORKON_HOME=$HOME/.virtualenvs && mkdir -p $WORKON_HOME && source /usr/local/bin/virtualenvwrapper.sh && mkvirtualenv alerta


ADD . alerta
RUN cd alerta && sudo pip install -r requirements.txt && sudo python setup.py install

[DEFAULT]
log_dir = /tmp
mongo_username = alerta
mongo_password = 8l3rt8
api_host = x.x.x.x             <---- replace with actual IP address

[alerta-dashboard]
dashboard_dir = /path/to/alerta/dashboard/v2/assets/


#Add these to supervisord
[supervisord]
nodaemon=true

[program:alerta]
command=/root/alertavirtual/bin/alerta -f
stdout_logfile=/var/log/supervisor/%(program_name)s.log
stderr_logfile=/var/log/supervisor/%(program_name)s.log
autorestart=true


[program:alerta-api]
command=/root/alertavirtual/bin/alerta-api
stdout_logfile=/var/log/supervisor/%(program_name)s.log
stderr_logfile=/var/log/supervisor/%(program_name)s.log
autorestart=true



[program:alerta-dashboard]
command=/root/alertavirtual/bin/alerta-dashboard
stdout_logfile=/var/log/supervisor/%(program_name)s.log
stderr_logfile=/var/log/supervisor/%(program_name)s.log
autorestart=true

#Run these scripts from mongo command line console
$ mongo
MongoDB shell version: 2.0.4
connecting to: test
> use monitoring
switched to db monitoring
> db.addUser("alerta","8l3rt8", false)
