#!/bin/bash

# Setup auto registration for agents.
AGENT_KEY="${AGENT_KEY:-123456789abcdef}"
[[ -n "$AGENT_KEY" ]] && sed -i -e 's/agentAutoRegisterKey="[^"]*" *//' -e 's#\(<server\)\(.*artifactsdir.*\)#\1 agentAutoRegisterKey="'$AGENT_KEY'"\2#' /etc/go/cruise-config.xml

tail --follow=name /var/log/go-server/*.log | sed -u -e 's/.*/LOG: &/' &

/bin/su - go -c /usr/share/go-server/server.sh
