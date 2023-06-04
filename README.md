Electricity Spot prices in Finland
----------------------------

Simple "service" to load and provide electricity spot prices in Finland.

See https://spot.lahteenmaki.net

Includes:
- load and store prices in an Sqlite database
- interactive bar chart
- services to get the current price and cheapest windows

If you want to handle dependencies yourself instead of with Nix, go ahead and exclude the shebang lines.

Git pull to your server or for example to RaspberryPI if you want to minimize depending on the availability of Internet.

Cron example:
```
0 18 * * * myuser cd /var/www/spot && ./load.sh | ./parse.sh | ./insert.sh
```
