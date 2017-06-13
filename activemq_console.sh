#!/usr/bin/env bash

activemq console $@ 'broker:amqp://localhost:5672?persistent=true'

exit $?
