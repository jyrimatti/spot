INSERT INTO spot(instant, centsPerKWh) VALUES (unixepoch('2000-01-01 23:00:00+02:00'), 1.0);
INSERT INTO spot(instant, centsPerKWh) VALUES (unixepoch('2000-01-02 00:00:00+02:00'), 2.0);
INSERT INTO spot(instant, centsPerKWh) VALUES (unixepoch('2000-01-02 01:00:00+02:00'), 3.0);

INSERT INTO spotvat(start, end, percent) VALUES (unixepoch('2000-01-01 00:00:00+02:00'), unixepoch('2000-01-02 00:00:00+02:00'), 10);
INSERT INTO spotvat(start,      percent) VALUES (unixepoch('2000-01-02 00:00:00+02:00'),                                         20);

INSERT INTO transfervat(start, end, percent) VALUES (unixepoch('2000-01-01 00:00:00+02:00'), unixepoch('2001-01-01 00:00:00+02:00'), 10);
INSERT INTO transfervat(start,      percent) VALUES (unixepoch('2001-01-01 00:00:00+02:00'),                                         20);

INSERT INTO electricitytax(start, end, centsPerKWh) VALUES (unixepoch('2000-01-01 00:00:00+02:00'), unixepoch('2001-01-01 00:00:00+02:00'), 1.0);
INSERT INTO electricitytax(start,      centsPerKWh) VALUES (unixepoch('2001-01-01 00:00:00+02:00'),                                         2.0);

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour, start) VALUES ('Test Oy', 'Yleissiirto', 3.0, null,    null,    unixepoch('2000-01-01 00:00:00+02:00'));
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour, start) VALUES ('Test Oy', 'Yösiirto',    2.0, '07:00', '22:00', unixepoch('2000-01-01 00:00:00+02:00'));
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour, start) VALUES ('Test Oy', 'Yösiirto',    1.0, '22:00', '07:00', unixepoch('2000-01-01 00:00:00+02:00'));
