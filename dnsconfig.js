var REG_NONE = NewRegistrar('none', 'NONE');    // No registrar.
var deSEC = NewDnsProvider('desec', 'DESEC');  // deSEC

// Traemos la ip publica
// 'https://api.ipgeolocation.io/getip'
var publicip = require('./ip.json');
var ip = publicip.ip;

// ejecutar con --allow-fetch
//FETCH('https://api.ipgeolocation.io/getip', {
//}).then(function(response) {
//  return response.json();
//}).then(function(data) {
// var ip = data.ip;
//});

// Sacamos la lista de dominios
var domains = require('./domains.json');
for (var domain in domains){
        D(domains[domain].name, REG_NONE, DnsProvider(deSEC),
            A('@',ip,TTL(60))
);
}
