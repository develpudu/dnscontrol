#!/bin/bash
# Ejecutar como root o que el user pueda usar docker sin sudo

case $1 in
    setup)
    # Creamos el contenedor con docker-compose
    echo "--> Creando contenedor"
    docker-compose up -d
    echo "--> Contenedor creado. Ejecutar: ./run.sh update para actualizar los dns de los dominios."
    ;;
    update)
    echo "--> Actulizando IP publica"
    curl -o ip.json 'https://api.ipgeolocation.io/getip'
    echo "--> ip.json actualizado"
    echo "--> Actualizando lista de dominios"

    echo "--> domains.json actualizado"
    echo "--> Actualizando DNS con nueva IP"
    docker-compose run --rm dnscontrol dnscontrol preview
    echo "--> Aplicando los cambios a deSEC"
    docker-compose run --rm dnscontrol dnscontrol push
    echo "DNS de dominios actualizados"
    ;;
    domains)
    echo "--> Actualizando lista de dominios"
    auth=`jq -r '.desec."auth-token"' creds.json`
    curl -o domains.json -X GET https://desec.io/api/v1/domains/ --header "Authorization: Token $auth"
    echo "--> domains.json actualizado"
    ;;
    token)
    auth=`jq -r '.desec."auth-token"' creds.json`
    echo "--> Token: $auth"
    ;;
    terminal)
    docker-compose run dnscontrol bash
    ;;
    help)
    echo "./run.sh setup: Crea el contenedor con docker-compose"
    echo "./run.sh update: Actualiza la IP publica y los DNS de los dominios"
    echo "./run.sh domains: Actualiza la lista de dominios"
    echo "./run.sh token: Muestra el token de autenticacion"
    echo "./run.sh terminal: Abre una terminal en el contenedor"
    echo "./run.sh help: Muestra esta ayuda"
    ;;
    *)
    echo "--> Comando no reconocido usar help para ver los comandos disponibles"
    ;;
esac