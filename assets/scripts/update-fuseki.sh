#!/bin/bash
cd /data/fuseki/databases
sudo -u fuseki /opt/apache-jena/bin/tdb2.tdbloader --loc cz-br-new --loader=parallel /data/www/soubor/or.trig /data/www/soubor/or-ebg.trig /data/www/soubor/or-ebg-nuts.trig /data/www/soubor/nace-cz.trig /data/www/soubor/or-ebg-nace.trig
mv cz-br cz-br-old
mv cz-br-new cz-br
rm -rf cz-br-old
service fuseki restart