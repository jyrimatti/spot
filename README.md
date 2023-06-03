Pörssisähkön hinnat Suomessa
----------------------------

Yksinkertainen scriptikokoelma lataamaan pörssisähkön hintaa ja historiaa.

Sisältää niiden viemisen SQLite-tietokantaan saakka ja visualisoimisen pylväsgraafina, johon voi tehdä SQL-kyselyitä selaimesta (https://spot.lahteenmaki.net)

Jos haluat asentaa riippuvuudet jotenkin muuten kuin Nixillä, tipauta toki shebangit pois ja asenna tarvittavat riippuvuudet itse.

Cronjobiin esimerkiksi
```
0 18 * * * myuser cd /var/www/spot && ./load.sh | ./parse.sh | ./insert.sh
```
