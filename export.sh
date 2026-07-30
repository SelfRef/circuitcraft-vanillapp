#!/bin/sh

SERVER_URL=https://meta.fabricmc.net/v2/versions/loader/26.2/0.19.3/1.1.2/server/jar

rm -rf mods server/mods
pakku-mc fetch
mv mods server/

rm -f server/*.jar
curl -o server/server-fabric.jar "$SERVER_URL"

cd server
zip -r ../server.zip .