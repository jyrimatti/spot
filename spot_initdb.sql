INSERT INTO spotvat(       end, percent) VALUES (                                        unixepoch('1994-06-01 00:00:00+03:00'), 0);
INSERT INTO spotvat(start, end, percent) VALUES (unixepoch('1994-06-01 00:00:00+03:00'), unixepoch('2010-07-01 00:00:00+03:00'), 22);
INSERT INTO spotvat(start, end, percent) VALUES (unixepoch('2010-07-01 00:00:00+03:00'), unixepoch('2013-01-01 00:00:00+02:00'), 23);
INSERT INTO spotvat(start, end, percent) VALUES (unixepoch('2013-01-01 00:00:00+02:00'), unixepoch('2022-12-01 00:00:00+02:00'), 24);
INSERT INTO spotvat(start, end, percent) VALUES (unixepoch('2022-12-01 00:00:00+02:00'), unixepoch('2023-05-01 00:00:00+03:00'), 10);
INSERT INTO spotvat(start, end, percent) VALUES (unixepoch('2023-05-01 00:00:00+03:00'), unixepoch('2024-09-01 00:00:00+03:00'), 24);
INSERT INTO spotvat(start,      percent) VALUES (unixepoch('2024-09-01 00:00:00+03:00'),                                         25.5);

INSERT INTO transfervat(       end, percent) VALUES (                                        unixepoch('1994-06-01 00:00:00+03:00'), 0);
INSERT INTO transfervat(start, end, percent) VALUES (unixepoch('1994-06-01 00:00:00+03:00'), unixepoch('2010-07-01 00:00:00+03:00'), 22);
INSERT INTO transfervat(start, end, percent) VALUES (unixepoch('2010-07-01 00:00:00+03:00'), unixepoch('2013-01-01 00:00:00+02:00'), 23);
INSERT INTO transfervat(start, end, percent) VALUES (unixepoch('2013-01-01 00:00:00+02:00'), unixepoch('2024-09-01 00:00:00+03:00'), 24);
INSERT INTO transfervat(start,      percent) VALUES (unixepoch('2024-09-01 00:00:00+03:00'),                                         25.5);

INSERT INTO electricitytax(       end, centsPerKWh) VALUES (                                        unixepoch('2002-01-01 00:00:00+02:00'), 0);
INSERT INTO electricitytax(start, end, centsPerKWh) VALUES (unixepoch('2002-01-01 00:00:00+02:00'), unixepoch('2003-01-01 00:00:00+02:00'), 0.85766);
INSERT INTO electricitytax(start, end, centsPerKWh) VALUES (unixepoch('2003-01-01 00:00:00+02:00'), unixepoch('2008-01-01 00:00:00+02:00'), 0.90646);
INSERT INTO electricitytax(start, end, centsPerKWh) VALUES (unixepoch('2008-01-01 00:00:00+02:00'), unixepoch('2011-01-01 00:00:00+02:00'), 1.07726);
INSERT INTO electricitytax(start, end, centsPerKWh) VALUES (unixepoch('2011-01-01 00:00:00+02:00'), unixepoch('2013-01-01 00:00:00+02:00'), 2.09469);
INSERT INTO electricitytax(start, end, centsPerKWh) VALUES (unixepoch('2013-01-01 00:00:00+02:00'), unixepoch('2014-01-01 00:00:00+02:00'), 2.11172);
INSERT INTO electricitytax(start, end, centsPerKWh) VALUES (unixepoch('2014-01-01 00:00:00+02:00'), unixepoch('2015-01-01 00:00:00+02:00'), 2.35972);
INSERT INTO electricitytax(start, end, centsPerKWh) VALUES (unixepoch('2015-01-01 00:00:00+02:00'), unixepoch('2024-09-01 00:00:00+03:00'), 2.79372);
INSERT INTO electricitytax(start,      centsPerKWh) VALUES (unixepoch('2024-09-01 00:00:00+03:00'),                                         2.827515);



INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Alajärven sähkö', 'Yleissiirto', 4.67, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Alajärven sähkö', 'Yösiirto', 4.27, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Alajärven sähkö', 'Yösiirto', 2.70, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Alva sähköverkko', 'Yleissiirto', 1.93, null, null);

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Caruna', 'Yleissiirto', 5.07, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Caruna', 'Yösiirto', 4.92, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Caruna', 'Yösiirto', 3.01, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Caruna Espoo', 'Yleissiirto', 2.96, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Caruna Espoo', 'Yösiirto', 2.88, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Caruna Espoo', 'Yösiirto', 1.54, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour, end)   VALUES ('Elenia', 'Yleissiirto', 5.62, null,    null,    unixepoch('2024-09-01 00:00:00+03:00'));
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour, end)   VALUES ('Elenia', 'Yösiirto',    4.33, '07:00', '22:00', unixepoch('2024-09-01 00:00:00+03:00'));
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour, end)   VALUES ('Elenia', 'Yösiirto',    2.64, '22:00', '07:00', unixepoch('2024-09-01 00:00:00+03:00'));
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour, start) VALUES ('Elenia', 'Yleissiirto', 5.89, null,     null,   unixepoch('2024-09-01 00:00:00+03:00'));
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour, start) VALUES ('Elenia', 'Yösiirto',    4.53, '07:00', '22:00', unixepoch('2024-09-01 00:00:00+03:00'));
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour, start) VALUES ('Elenia', 'Yösiirto',    2.76, '22:00', '07:00', unixepoch('2024-09-01 00:00:00+03:00'));

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('ESE-verkko', 'Yleissiirto', 3.40, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('ESE-verkko', 'Yösiirto', 4.26, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('ESE-verkko', 'Yösiirto', 1.33, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Esse elektro-kraft', 'A Yleissiirto', 5.32, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Esse elektro-kraft', 'B Yleissiirto', 4.94, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Esse elektro-kraft', 'Yösiirto', 4.94, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Esse elektro-kraft', 'Yösiirto', 3.87, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Forssan verkkopalvelut', 'Yleissiirto', 3.28, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Forssan verkkopalvelut', 'Yösiirto', 3.25, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Forssan verkkopalvelut', 'Yösiirto', 1.53, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Haukiputaan sähköosuuskunta', 'Yleissiirto', 3.48, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Haukiputaan sähköosuuskunta', 'Yleissiirto 2', 2.74, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Haukiputaan sähköosuuskunta', 'Yösiirto', 2.87, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Haukiputaan sähköosuuskunta', 'Yösiirto', 2.01, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Helen sähköverkko', 'Yleissiirto', 4.07, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Helen sähköverkko', 'Yösiirto', 2.59, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Helen sähköverkko', 'Yösiirto', 1.35, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Herrfors nät', 'Yleissiirto', 3.34, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Herrfors nät', 'Yösiirto', 2.91, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Herrfors nät', 'Yösiirto', 1.61, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Iin energia', 'Yleissiirto', 3.65, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Iin energia', 'Yösiirto', 3.47, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Iin energia', 'Yösiirto', 2.41, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Imatran seudun sähkönsiirto', 'Yleissiirto', 3.94, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Imatran seudun sähkönsiirto', 'Yösiirto', 4.30, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Imatran seudun sähkönsiirto', 'Yösiirto', 1.44, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Jeppo kraft andelslag', 'Yleissiirto', 4.48, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Jeppo kraft andelslag', 'Yösiirto', 3.94, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Jeppo kraft andelslag', 'Yösiirto', 2.87, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Jylhän sähköosuuskunta', 'Yleissiirto', 4.90, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Jylhän sähköosuuskunta', 'Yösiirto', 4.50, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Jylhän sähköosuuskunta', 'Yösiirto', 3.90, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Järvisuomen energia', 'Yleissiirto', 4.71, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Järvisuomen energia', 'Yösiirto', 4.02, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Järvisuomen energia', 'Yösiirto', 2.62, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kajave', 'Yleissiirto', 5.43, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kajave', 'Yösiirto', 4.93, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kajave', 'Yösiirto', 3.03, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kemin energia ja vesi', 'Yleissiirto', 3.68, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kemin energia ja vesi', 'Yleissiirto 2', 2.81, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kemin energia ja vesi', 'Yösiirto', 3.22, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kemin energia ja vesi', 'Yösiirto', 1.44, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Keminmaan energia', 'Yleissiirto', 3.06, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Keminmaan energia', 'Yleissiirto 2', 2.40, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Keminmaan energia', 'Yösiirto', 3.25, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Keminmaan energia', 'Yösiirto', 1.79, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Keravan energia', 'Yleissiirto', 2.30, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Keravan energia', 'Yösiirto', 2.30, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Keravan energia', 'Yösiirto', 1.30, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Keuruun sähkö', 'Yleissiirto', 5.42, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Keuruun sähkö', 'Yösiirto', 5.47, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Keuruun sähkö', 'Yösiirto', 2.82, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Koillis-Lapin sähkö', 'Yleissiirto', 4.10, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Koillis-Lapin sähkö', 'Yösiirto', 3.89, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Koillis-Lapin sähkö', 'Yösiirto', 2.07, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Koillis-Satakunnan sähkö', 'Yleissiirto', 4.35, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Koillis-Satakunnan sähkö', 'Yösiirto', 5.36, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Koillis-Satakunnan sähkö', 'Yösiirto', 2.66, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kokemäen sähkö', 'Yleissiirto', 5.05, null, null);

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kokkolan energiaverkot', 'Yleissiirto', 4.30, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kokkolan energiaverkot', 'Yösiirto', 4.30, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kokkolan energiaverkot', 'Yösiirto', 1.92, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kronoby elverk', 'Yleissiirto', 4.86, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kronoby elverk', 'Yösiirto', 4.18, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kronoby elverk', 'Yösiirto', 2.76, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('KSS verkko', 'Yleissiirto', 3.76, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('KSS verkko', 'Yösiirto', 3.04, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('KSS verkko', 'Yösiirto', 1.38, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kuopion sähköverkko', 'Yleissiirto', 3.17, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kuopion sähköverkko', 'Yösiirto', 2.25, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kuopion sähköverkko', 'Yösiirto', 1.34, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kuoreveden sähkö', 'Yleissiirto', 3.70, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kuoreveden sähkö', 'Yösiirto', 3.70, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kuoreveden sähkö', 'Yösiirto', 1.55, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kymenlaakson sähköverkko', 'Yleissiirto', 2.60, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kymenlaakson sähköverkko', 'Yösiirto', 2.58, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Kymenlaakson sähköverkko', 'Yösiirto', 0.89, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Köyliön-Säkylän sähkö', 'Yleissiirto', 4.44, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Köyliön-Säkylän sähkö', 'Yösiirto', 4.57, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Köyliön-Säkylän sähkö', 'Yösiirto', 2.93, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Lammaisten energia', 'Yleissiirto', 4.42, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Lammaisten energia', 'Yösiirto', 4.70, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Lammaisten energia', 'Yösiirto', 2.53, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Lankosken sähkö', 'Yleissiirto', 5.20, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Lankosken sähkö', 'Yösiirto', 4.88, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Lankosken sähkö', 'Yösiirto', 2.72, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Lappeenrannan energiaverkot', 'Yleissiirto', 4.09, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Lappeenrannan energiaverkot', 'Yösiirto', 3.38, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Lappeenrannan energiaverkot', 'Yösiirto', 2.19, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('LE-sähköverkko', 'Yleissiirto', 3.47, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('LE-sähköverkko', 'Yösiirto', 3.97, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('LE-sähköverkko', 'Yösiirto', 1.67, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Lehtimäen sähkö', 'Yleissiirto', 4.80, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Lehtimäen sähkö', 'Yösiirto', 4.20, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Lehtimäen sähkö', 'Yösiirto', 2.90, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Leppäkosken sähkö', 'Yleissiirto', 4.35, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Leppäkosken sähkö', 'Yösiirto', 4.65, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Leppäkosken sähkö', 'Yösiirto', 2.70, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Muonion sähköosuuskunta', 'Yleissiirto', 5.90, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Muonion sähköosuuskunta', 'Yösiirto', 5.94, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Muonion sähköosuuskunta', 'Yösiirto', 4.05, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Naantalin energia', 'Yleissiirto', 4.20, null, null);

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Nivos energia', 'Yleissiirto', 4.34, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Nivos energia', 'Yösiirto', 4.34, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Nivos energia', 'Yösiirto', 2.84, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Nurmijärven sähköverkko', 'Yleissiirto', 2.97, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Nurmijärven sähköverkko', 'Yösiirto', 2.56, '06:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Nurmijärven sähköverkko', 'Yösiirto', 1.79, '22:00', '06:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Nykarleby kraftverk', 'Yleissiirto', 6.87, null, null);

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Oulun energia siirto ja jakelu', 'Yleissiirto', 2.81, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Oulun energia siirto ja jakelu', 'Yösiirto', 2.37, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Oulun energia siirto ja jakelu', 'Yösiirto', 1.45, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Oulun seudun sähkö', 'Yleissiirto', 2.48, null, null);

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Outokummun energia', 'Yleissiirto', 4.83, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Outokummun energia', 'Yösiirto', 4.84, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Outokummun energia', 'Yösiirto', 2.29, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Paneliankosken voima', 'Yleissiirto', 4.33, null, null);

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Parikkalan valo', 'Yleissiirto', 3.40, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Parikkalan valo', 'Yösiirto', 3.40, '06:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Parikkalan valo', 'Yösiirto', 2.00, '22:00', '06:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('PKS sähkösiirto', 'Yleissiirto', 4.841, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('PKS sähkösiirto', 'Yösiirto', 5.300, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('PKS sähkösiirto', 'Yösiirto', 2.069, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Pori energia sähköverkot', 'Yleissiirto', 2.95, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Pori energia sähköverkot', 'Yösiirto', 2.95, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Pori energia sähköverkot', 'Yösiirto', 1.50, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Porvoon sähköverkko', 'Yleissiirto', 2.90, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Porvoon sähköverkko', 'Yösiirto', 2.90, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Porvoon sähköverkko', 'Yösiirto', 1.70, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Raahen energia', 'Yleissiirto', 5.35, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Raahen energia', 'Yösiirto', 4.90, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Raahen energia', 'Yösiirto', 2.45, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Rantakairan sähkö', 'Yleissiirto', 2.86, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Rantakairan sähkö', 'Yösiirto', 2.60, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Rantakairan sähkö', 'Yösiirto', 1.36, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Rauman energia sähköverkko', 'Yleissiirto', 2.80, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Rauman energia sähköverkko', 'Yösiirto', 3.90, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Rauman energia sähköverkko', 'Yösiirto', 1.74, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Rovaniemen verkko', 'Yleissiirto', 2.25, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Rovaniemen verkko', 'Yösiirto', 2.25, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Rovaniemen verkko', 'Yösiirto', 1.04, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Sallila sähkönsiirto', 'Yleissiirto', 4.30, null, null);

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Savon voima', 'Yleissiirto', 4.85, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Savon voima', 'Yösiirto', 6.15, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Savon voima', 'Yösiirto', 2.67, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Seiverkot', 'Yleissiirto', 3.21, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Seiverkot', 'Yösiirto', 2.69, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Seiverkot', 'Yösiirto', 1.69, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Sipoon energia', 'Yleissiirto', 2.10, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Sipoon energia', 'Yösiirto', 2.00, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Sipoon energia', 'Yösiirto', 1.30, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Tammisaaren energia', 'Yleissiirto', 4.14, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Tammisaaren energia', 'Yösiirto', 4.14, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Tammisaaren energia', 'Yösiirto', 2.51, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Tampereen sähköverkko', 'Yleissiirto', 2.9264, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Tampereen sähköverkko', 'Yösiirto', 3.1000, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Tampereen sähköverkko', 'Yösiirto', 1.3268, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Tenergia', 'Yleissiirto', 4.38, null, null);

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Tornion energia', 'Yleissiirto', 3.534, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Tornion energia', 'Yösiirto', 3.534, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Tornion energia', 'Yösiirto', 1.848, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Tornionlaakson sähkö', 'Yleissiirto', 3.05, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Tornionlaakson sähkö', 'Yösiirto', 3.83, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Tornionlaakson sähkö', 'Yösiirto', 1.52, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Tunturiverkko', 'Yleissiirto', 2.88, null, null);

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Turku energia sähköverkot', 'Yleissiirto', 1.75, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Turku energia sähköverkot', 'Yösiirto', 1.71, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Turku energia sähköverkot', 'Yösiirto', 0.82, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Vaasan sähköverkko', 'Yleissiirto', 4.28, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Vaasan sähköverkko', 'Yösiirto', 3.82, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Vaasan sähköverkko', 'Yösiirto', 1.29, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Vakka-Suomen voima', 'Yleissiirto', 4.00, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Vakka-Suomen voima', 'Yösiirto', 4.00, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Vakka-Suomen voima', 'Yösiirto', 2.00, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Valkeakosken energia', 'Yleissiirto', 4.06, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Valkeakosken energia', 'Yösiirto', 3.95, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Valkeakosken energia', 'Yösiirto', 1.86, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Vantaan energia sähköverkot', 'Yleissiirto', 2.90, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Vantaan energia sähköverkot', 'Yösiirto', 3.20, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Vantaan energia sähköverkot', 'Yösiirto', 1.40, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Vatajankoski sähkö', 'Yleissiirto', 4.66, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Vatajankoski sähkö', 'Yösiirto', 4.85, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Vatajankoski sähkö', 'Yösiirto', 2.91, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Verkko korpela', 'Yleissiirto', 4.00, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Verkko korpela', 'Yösiirto', 3.56, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Verkko korpela', 'Yösiirto', 1.84, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Vetelin energia', 'Yleissiirto', 4.821, null, null);

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Vimpelin voima', 'Yleissiirto', 4.34, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Vimpelin voima', 'Yösiirto', 3.92, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Vimpelin voima', 'Yösiirto', 2.76, '22:00', '07:00');

INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Äänekosken energia', 'Yleissiirto', 4.14, null, null);
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Äänekosken energia', 'Yösiirto', 3.84, '07:00', '22:00');
INSERT INTO transfer(provider, product, centsPerKWh, fromHour, toHour) VALUES ('Äänekosken energia', 'Yösiirto', 1.83, '22:00', '07:00');
