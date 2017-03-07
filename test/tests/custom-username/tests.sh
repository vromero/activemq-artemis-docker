#!/bin/bash
set -e

setup(){
  dockerize -wait tcp://artemis:8161 \
    -wait tcp://artemis:61616 \
    -wait tcp://artemis:5445 \
    -wait tcp://artemis:5672 \
    -wait tcp://artemis:1883 \
    -wait tcp://artemis:61613 \
    -timeout 10s
}

#test_should_be_able_to_send_with_stomp_using_custom_username_and_password(){
#  mosquitto_pub -h artemis -i asdf -t /asdfasdf -m 'This is a test message' -u myuser -P otherpassword
#}

test_should_be_able_to_send_with_stomp_using_default_username_and_password(){
  sleep 5
  mosquitto_pub -h artemis -i asdf -t /asdfasdf -m 'This is a test message' -u artemis -P simetraehcapa
}
