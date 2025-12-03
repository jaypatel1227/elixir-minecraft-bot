#!/bin/bash

# Patch server.properties after it's created
patch_server_properties() {
    if [ -f server.properties ]; then
        sed -i 's/enable-rcon=false/enable-rcon=true/' server.properties
        sed -i "s/^rcon.password=.*/rcon.password=${RCON_PASSWORD:-minecraft}/" server.properties
        sed -i 's/white-list=false/white-list=true/' server.properties
        sed -i 's/enforce-whitelist=false/enforce-whitelist=true/' server.properties
    fi
}

(
    while [ ! -f server.properties ]; do sleep 1; done
    patch_server_properties
) &

exec bash -c "./start.sh || ./startserver.sh || ./run.sh || java -Xmx${MAX_MEMORY:-8G} -jar server.jar nogui"
