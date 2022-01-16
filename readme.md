# Actualizador de IP publica para deSEC con dnscontrol via docker
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
