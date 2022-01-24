#!/bin/bash
#
VERSION="0.7.0"
RUN_PATH=$(dirname "$BASH_SOURCE")
LOG_FILE=$RUN_PATH/dnscontrol.log

logger(){
    if [ $# -eq 0 ]
    then cat - | while read -r message
        do
            echo "$(date +"[%F %T %Z] -") $message" | tee -a $LOG_FILE
        done
    else
        echo -n "$(date +'[%F %T %Z]') - " | tee -a $LOG_FILE
        echo $* | tee -a $LOG_FILE
    fi
}

case $1 in
    setup)
    cd "$RUN_PATH"
    # TODO: Agregar que descargue la ultima version de dnscontrol desde git
    if [ -f "creds.json" ]; then
        echo "--> Ya existe el archivo de credenciales"
        while true; do
            read -p "Actualizar el archivo: (y/n)" yn
            case $yn in
                [Yy]*) 
                read -p "--> Token de deSEC: " TOKEN
                cp creds.dist.json creds.json
                cp config.dist.json config.json
                sed -i 's','auth-token": ""','auth-token": "'$TOKEN'"','g' creds.json
                sed -i 's','install_path": ""','install_path": "'$RUN_PATH'"','g' config.json
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
        cp creds.dist.json creds.json
        cp config.dist.json config.json
        read -p "--> Token de deSEC: " TOKEN
        sed -i 's','auth-token": ""','auth-token": "'$TOKEN'"','g' creds.json
        sed -i 's','install_path": ""','install_path": "'$RUN_PATH'"','g' config.json
        echo "--> Ejecute ./run.sh update para actualizar los dns."
    fi
    if [ "$2" == "auto" ]; then
        sed -i 's','install_path',''$RUN_PATH'','g' dnscontrol.crontab
        crontab -u $USER dnscontrol.crontab
        echo "--> Se agrego dnscontrol.crontab a crontab"
    fi
    ;;
    update)
    cd "$RUN_PATH"
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
    ./dnscontrol preview
    echo "--> Aplicando los cambios a deSEC"
    ./dnscontrol push | logger
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
    cd "$RUN_PATH"
    auth=`jq -r '.desec."auth-token"' creds.json`
    echo "--> Token: $auth"
    ;;
    version)
    echo "--> Version: $VERSION"
    ;;    
    help)
    echo "./run.sh setup: Crea el archivo creds.json con credenciales de deSEC"
    echo "./run.sh setup auto: Crea el archivo creds.json con credenciales de deSEC y genera el crontab"
    echo "./run.sh update: Actualiza la IP publica y los DNS de los dominios"
    echo "./run.sh domains: Actualiza la lista de dominios"
    echo "./run.sh token: Muestra el token de autenticacion"
    echo "./run.sh version: Muestra la version"
    echo "./run.sh help: Muestra esta ayuda"
    ;;
    *)
    echo "--> Comando no reconocido usar help para ver los comandos disponibles"
    ;;
esac
