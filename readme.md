# Actualizador de IP publica para deSEC con dnscontrol via docker
## Requisitos
* docker.io 
* docker-compose
* jq
```bash
curl -sS https://webinstall.dev/jq | bash
```
* Ejecutar como root o que el user pueda usar docker sin sudo
* Token de acceso de deSEC
## Uso
* Cloran el repositorio
```bash
git clone https://github.com/develpudu/dnscontrol
cd dnscontrol
```
* Ejecutar setup y agregar el token de deSEC
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

