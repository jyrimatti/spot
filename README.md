Electricity Spot prices in Finland
----------------------------

Simple scripts to load and provide electricity spot prices in Finland.

See https://spot.lahteenmaki.net

Includes:
- scripts to load data from
    - [Entsoe Transparency Platform](https://transparency.entsoe.eu/content/static_content/Static%20content/web%20api/Guide.html)
    - Nordpool internal API (don't use this, it's not a published API)
- store prices in a Sqlite database
- interactive bar chart
- OpenAPI spec with interactive Swagger-UI
- endpoints to get the current price, daily prices and cheapest windows
- responses in JSON and CSV

You don't need to use my API. This required practically no infrastructure, so you can run this on your own device.
Git pull to your server or for example to RaspberryPI if you want to minimize depending on the availability of Internet.

If you want to handle dependencies yourself instead of with Nix, go ahead and exclude the shebang lines.

Cron example:
```
0 * * * * myuser cd /var/spot && SECURITY_TOKEN=$(echo /home/myuser/.entsoe_token.txt) ./e_load.sh | ./e_parse.sh | ./e_insert.sh
```

Nginx example:
```
location ~ ^/.*[.]csv$ {
    root /var/spot;
    if (-f $request_filename) {
    fastcgi_pass unix:/run/fcgiwrap.sock;
    }
}
location ~ ^/.*[.]json$ {
    root /var/spot;
    if (-f $request_filename) {
    fastcgi_pass unix:/run/fcgiwrap.sock;
    }
}

location /spot.db {
    root /var/spot;
    gzip off;
}

location / {
    root /var/spot;
}
```
