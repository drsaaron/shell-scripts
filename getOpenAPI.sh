#! /bin/sh

port=$(grep -E '^ *server.port' src/main/resources/prod.properties | awk -F= '{print $2}' | sed 's/ *$//')
curl http://localhost:$port/v3/api-docs
