#!/usr/bin/with-contenv bashio
set -e

USER=$(bashio::config 'user')
TOKEN=$(bashio::config 'token')
SERVER=$(bashio::config 'server')
CLIENTID=$(bashio::config 'clientid')
TIMEOUT=$(bashio::config 'timeout')

# Start the client
bashio::log.info "Starting BoringProxy"

while true
do
  exec /root/boringproxy client \
      -server ${SERVER} \
      -token ${TOKEN} \
      -client-name ${CLIENTID} \
      -user "${USER}" \
      < /dev/null &

  PID=$!
  bashio::log.info "Launched new Client PID ${PID}"

  sleep ${TIMEOUT} &    # Set client-timeout
  PIDrenew=$!

  while ( kill -0 ${PIDrenew} &> /dev/null )
  do
    $(kill -0 ${PID} &> /dev/null) || break 3
    sleep 2
  done

  $(kill -9 ${PID} &> /dev/null) && bashio::log.info "Killed PID ${PID} by schedule."
  sleep 7s
done

bashio::log.info "BoringProxy-client addon has terminated."
