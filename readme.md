# Actualizador de IP publica para deSEC con dnscontrol via docker
## Requisitos docker docker-compose jq y ejecutar como root o que el user pueda usar docker sin sudo
```bash
curl -sS https://webinstall.dev/jq | bash
```
## Uso
* Copiar/Renombrar creds-deSEC.json a creds.json y en "auth-token": "" poner el token de deSEC
* Ejecutar para generar el contenedor:
```bash
./run.sh setup
```
* Ejecutar para actualizar la IP publica de todos los dominios:
```bash
./run.sh update
```
* Ejecutar para ver los comandos disponibles:
```bash
./run.sh help
```

