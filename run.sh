#!/bin/sh
echo Detectando IP
curl -o ip.json 'https://api.ipgeolocation.io/getip'
echo IP actualizada a ip.json
echo Ejecutando dnscontrol preview
docker run -it -v /home/dyna/docker/dnscontrol/:/dns/ stackexchange/dnscontrol dnscontrol preview
echo Aplicando los cambios a deSEC
docker run -it -v /home/dyna/docker/dnscontrol/:/dns/ stackexchange/dnscontrol dnscontrol push
echo DNS de dominios actualizados
