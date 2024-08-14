create table spot (instant     INTEGER PRIMARY KEY,
                   centsPerKWh REAL    NOT NULL -- excluding VAT
                  );

create table spotvat (start   INTEGER DEFAULT 0          NOT NULL,
                      end     INTEGER DEFAULT 2147400000 NOT NULL,
                      percent REAL                       NOT NULL);

create table transfervat (start   INTEGER DEFAULT 0          NOT NULL,
                          end     INTEGER DEFAULT 2147400000 NOT NULL,
                          percent REAL                       NOT NULL);

create table electricitytax (start       INTEGER DEFAULT 0          NOT NULL,
                             end         INTEGER DEFAULT 2147400000 NOT NULL,
                             centsPerKWh REAL                       NOT NULL -- including VAT
                            );

create table transfer (provider    TEXT                       NOT NULL,
                       product     TEXT                       NOT NULL,
                       start       INTEGER DEFAULT 0          NOT NULL,
                       end         INTEGER DEFAULT 2147400000 NOT NULL,
                       fromHour    TEXT,
                       toHour      TEXT,
                       centsPerKWh REAL                       NOT NULL -- including VAT
                       );
