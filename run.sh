#!/bin/bash
#
# Ejecutar como root o que el user pueda usar docker sin sudo
if [[ $EUID -ne 0 ]]; then
   echo "Este script se debe ejecutar como root o sudoer" 1>&2
   exit 1
fi

case $1 in
    setup)
    if [ -f "creds.json" ]; then
        echo "--> Ya existe el archivo de credenciales"
        while true; do
            read -p "Actualizar el archivo: (y/n)" yn
            case $yn in
                [Yy]*) 
                read -p "--> Token de deSEC: " TOKEN
                cp creds-deSEC.json creds.json
                sed -i 's/auth-token": ""/auth-token": "'$TOKEN'"/g' creds.json
                echo "--> Ejecute ./run.sh update para actualizar los dns."
                break
                ;;
                [Nn]*) 
                exit
                ;;
                *) echo "Opciones validas (y/n)";;
            esac
        done
    else
        cp creds-deSEC.json creds.json
        read -p "--> Token de deSEC: " TOKEN
        sed -i 's/auth-token": ""/auth-token": "'$TOKEN'"/g' creds.json
    fi    
    ;;
    update)
    if [ ! -f "creds.json" ]; then
        echo "--> No existe el archivo de credenciales"
        echo "--> Ejecute el ./run.sh setup"
        exit 1
    fi
    echo "--> Actulizando IP publica"
    curl -o ip.json 'https://api.ipgeolocation.io/getip'
    echo "--> ip.json actualizado"
    echo "--> Actualizando lista de dominios"
    auth=`jq -r '.desec."auth-token"' creds.json`
    # FIXME: Usamos -k x tema de ssl
    curl -o domains.json -k -X GET https://desec.io/api/v1/domains/ --header "Authorization: Token $auth"
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
    # FIXME: Usamos -k x tema de ssl
    ssl= curl -v --silent https://desec.io/api/v1/domains/ 2>&1 | sed -n '/expired/p' # no logro hacer q funciones asi que queda x defecto con -k
    if [[ -z $ssl ]]; then
        curl -o domains.json -k -X GET https://desec.io/api/v1/domains/ --header "Authorization: Token $auth"
    else
        curl -o domains.json -X GET https://desec.io/api/v1/domains/ --header "Authorization: Token $auth"
    fi 
    echo "--> domains.json actualizado"
    ;;
    token)
    auth=`jq -r '.desec."auth-token"' creds.json`
    echo "--> Token: $auth"
    ;;
    terminal)
    docker-compose run --rm dnscontrol sh
    ;;
    help)
    echo "./run.sh setup: Crea el archivo creds.json con credenciales de deSEC"
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