# Actualizador de IP publica para todos los domiios de deSEC con dnscontrol

## Requisitos
* jq
```bash
curl -sS https://webinstall.dev/jq | bash
```
* Ejecutar como root o sudo
* Token de acceso de deSEC

## Uso
* Clonar el repositorio
```bash
git clone https://github.com/develpudu/dnscontrol
cd dnscontrol
```
* Ejecutar setup y agregar el token de deSEC
```bash
./run.sh setup

# Si se quiere automatizar con cron
./run.sh setup auto
```
* Ejecutar para actualizar la IP publica de todos los dominios:
```bash
./run.sh update
```
* Ejecutar para ver los comandos disponibles:
```bash
./run.sh help
```

