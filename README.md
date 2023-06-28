Electricity Spot prices in Finland
----------------------------------

Simple scripts to load and provide electricity spot prices in Finland.

See https://spot.lahteenmaki.net

Functionality
=============

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

Setup
=====
- git clone this repo
- store your Entsoe credentials to `/home/myuser/.entsoe_token.txt`
- create database: `./createdb.sh`
- setup cronjobs
- setup Nginx or another CGI server
- ~~profit!~~
Dependencies
============

Just install Nix, it handles all the dependencies for you.

However, constantly running nix-shell has a lot of overhead, so you might want to install all the required dependencies globally, and bypass nix-shell when executing scripts from within other processes (cron, cgi, homebridge...):

For example, installing with Nix:
```
> nix-env -f https://github.com/NixOS/nixpkgs/archive/nixos-23.05-small.tar.gz -i sqlite websocat curl jq yq htmlq getoptions bc
```

Then create somewhere a symlink named `nix-shell` pointing to just the regular shell:
```
> mkdir ~/.local/nix-override
> ln -s /bin/sh ~/.local/nix-override/nix-shell
```

after which you can override nix-shell with PATH:
```
PATH=~/.local/nix-override:$PATH ./current.sh
```

Cron
====

```
0 * * * * myuser export PATH=/var/nix-override:$PATH; cd /var/spot && SECURITY_TOKEN=$(echo /home/myuser/.entsoe_token.txt) ./e_load.sh | ./e_parse.sh | ./e_insert.sh
```

Python CGI server (for testing)
===============================

Note that the scripts have to be in `/cgi-bin` or `/htbin`.
```
nix-shell -p python3.pkgs.httpserver --run "python -m http.server --cgi"
```

Nginx (for production use)
==========================

```
http {
    # set PATH to wherever global binaries are installed, and override nix-shell:
    fastcgi_param PATH /var/nix-override:/run/current-system/sw/bin/;
    
    # allow caching of fastcgi responses (based on Cache-Control)
    fastcgi_cache_path /var/cache/nginx/fastcgi1 keys_zone=fastcgi1:50m max_size=400m inactive=7d;
    fastcgi_cache_path /var/cache/nginx/fastcgi2 keys_zone=fastcgi2:50m max_size=400m inactive=7d;
    fastcgi_cache_key "$scheme$request_method$host$request_uri";

    server {
        # allow .csv and .json as fastcgi endpoints:
        location ~ ^/[^/]*[.]csv$ {
            root /var/spot;
            fastcgi_cache fastcgi1;
            add_header X-Cache-status $upstream_cache_status;
            if (-f $request_filename) {
            fastcgi_pass unix:/run/fcgiwrap.sock;
            }
        }
        location ~ ^/[^/]*[.]json$ {
            root /var/spot;
            fastcgi_cache fastcgi2;
            add_header X-Cache-status $upstream_cache_status;
            if (-f $request_filename) {
            fastcgi_pass unix:/run/fcgiwrap.sock;
            }
        }

        # publish sqlite database for the browser:
        location /spot.db {
            root /var/spot;
            gzip off;
        }

        location / {
            root /var/spot;
        }
    }
}
```
