# Actualizador de IP publica para deSEC con dnscontrol via docker
## Requisitos
* docker.io 
* docker-compose
* jq
```bash
curl -sS https://webinstall.dev/jq | bash
```
* Ejecutar como root o que el user pueda usar docker sin sudo
## Uso
* Cloran el repositorio
```bash
git clone https://github.com/develpudu/dnscontrol
cd dnscontrol
```
* Copiar/Renombrar creds-deSEC.json a creds.json y en "auth-token" agregar el token de deSEC
```bash
cp creds-deSEC.json creds.json
sed -i 's/auth-token": ""/auth-token": "TOKEN"/g' creds.json
```
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

