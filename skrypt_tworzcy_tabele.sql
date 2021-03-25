create table gracz
(
    id_gracz int identity (1,1) primary key,
    imie     varchar(30),
    naziwsko varchar(50),
    nick     varchar(20) not null unique check (len(nick) > 3)
);

create table przyjaciele
(
    id_gracz1 int not null references gracz (id_gracz),
    id_gracz2 int not null references gracz (id_gracz),
    constraint przyjaciel_ze_soba check (id_gracz1 != id_gracz2
        )
);

create table turniej
(
    id_turniej       int identity (1,1) primary key,
    czas_rozpoczecia datetime default getdate(),
    czas_zakonczenia datetime,
    constraint turniej_czas_zakonecznia_jest_pozniej_niz_rozpoczenia check (czas_rozpoczecia < czas_zakonczenia)
);

create table gracz_turniej
(
    id_gracz   int not null references gracz (id_gracz),
    id_turniej int not null references turniej (id_turniej)
);

create table wariacje
(
    id_warjacja int identity (1,1) primary key,
    nazwa       varchar(15) not null unique,
    opis        text
);
create table czas_gry
(
    id_czas_gry int identity (1,1) primary key,
    nazwa       varchar(15) not null unique,
);
create table rodzaj_gry
(
    id_rodzaj_gry int identity (1,1) primary key,
    id_wariacja   int not null references wariacje (id_warjacja),
    id_czas_gry   int not null references czas_gry (id_czas_gry),
);

create table gra
(
    id_gry           int identity (1,1) primary key,
    id_gracz1        int      not null references gracz (id_gracz),
    id_gracz2        int      not null references gracz (id_gracz),
    id_rodzaj_gry    int      not null references rodzaj_gry (id_rodzaj_gry),
    czas_rozpoczecia datetime                                      default getdate(),
    czas_zakonczenia datetime not null,
    rankigowa        bit                                           default 1,
    wynik            char(1) check (wynik = '1' or wynik = '2' or wynik = '0'),
    ruchy            text,
    id_tuniej        int      null references turniej (id_turniej) default null,
    constraint gra_czas_zakonecznia_jest_pozniej_niz_rozpoczenia check ( czas_rozpoczecia < czas_zakonczenia),
    constraint gracz_nie_gra_ze_soba check (id_gracz1 != gra.id_gracz2
        )
);

create table gracz_elo
(
    id_gracz      int not null references gracz (id_gracz),
    id_rodzaj_gry int not null references rodzaj_gry (id_rodzaj_gry),
    elo           int check (elo > 0)
);


insert into gracz(imie, naziwsko, nick)
values ('Asia', 'Kaczmarczyk', 'asci20')

insert into gracz(imie, naziwsko, nick)
values ('Luiza', 'Kamińska', 'luzbluz')

insert into gracz(imie, naziwsko, nick)
values ('Klementyna', 'Pawlak', 'kpaw')

insert into gracz(imie, naziwsko, nick)
values ('Martin', 'Kozłowski', 'koza')

insert into gracz(imie, naziwsko, nick)
values ('Roman', 'Jaworski', 'romek')

insert into gracz(imie, naziwsko, nick)
values ('Tomek', 'Kac', 'null')

insert into przyjaciele
values (1, 2)

insert into przyjaciele
values (1, 3)

insert into przyjaciele
values (2, 3)

insert into przyjaciele
values (4, 5)

insert into przyjaciele
values (4, 3)

insert into wariacje(nazwa, opis)
values ('klasyczne', 'klasyczne zasady')

insert into wariacje(nazwa, opis)
values ('na ślepo', 'gracze widzą jedynie notacje')

insert into wariacje(nazwa, opis)
values ('szachy 960', 'figury ustawiane są losowo na 1 i 8 linii')

insert into wariacje(nazwa, opis)
values ('szachy atomowe', 'bicie powoduje eksplozje')

insert into wariacje(nazwa, opis)
values ('torpedo', 'pionki zawsze mogą poruszać się 1 lub 2 pola do przodu')

insert into czas_gry(nazwa)
values ('Bullet')

insert into czas_gry(nazwa)
values ('Blitz')

insert into czas_gry(nazwa)
values ('Rapid')

insert into czas_gry(nazwa)
values ('Classic')

insert into czas_gry(nazwa)
values ('Daily')

insert into rodzaj_gry(id_wariacja, id_czas_gry)
values (1, 2)

insert into rodzaj_gry(id_wariacja, id_czas_gry)
values (1, 3)

insert into rodzaj_gry(id_wariacja, id_czas_gry)
values (1, 4)

insert into rodzaj_gry(id_wariacja, id_czas_gry)
values (2, 4)

insert into rodzaj_gry(id_wariacja, id_czas_gry)
values (3, 3)

insert into gracz_elo
values (1, 1, 1428)
insert into gracz_elo
values (1, 2, 2186)
insert into gracz_elo
values (1, 3, 807)
insert into gracz_elo
values (1, 4, 1106)
insert into gracz_elo
values (1, 5, 2223)
insert into gracz_elo
values (2, 1, 1009)
insert into gracz_elo
values (2, 2, 1252)
insert into gracz_elo
values (2, 3, 1794)
insert into gracz_elo
values (2, 4, 1273)
insert into gracz_elo
values (2, 5, 1399)
insert into gracz_elo
values (3, 1, 1916)
insert into gracz_elo
values (3, 2, 932)
insert into gracz_elo
values (3, 3, 1600)
insert into gracz_elo
values (3, 4, 1149)
insert into gracz_elo
values (3, 5, 1054)
insert into gracz_elo
values (4, 1, 2342)
insert into gracz_elo
values (4, 2, 1066)
insert into gracz_elo
values (4, 3, 1624)
insert into gracz_elo
values (4, 4, 1148)
insert into gracz_elo
values (4, 5, 2459)
insert into gracz_elo
values (5, 1, 1779)
insert into gracz_elo
values (5, 2, 1528)
insert into gracz_elo
values (5, 3, 1321)
insert into gracz_elo
values (5, 4, 2012)
insert into gracz_elo
values (5, 5, 1804)

insert into turniej(czas_rozpoczecia, czas_zakonczenia)
values ('2019-12-12', '2019-12-30')

insert into turniej(czas_rozpoczecia, czas_zakonczenia)
values ('2020-01-12', '2020-01-23')

insert into turniej(czas_rozpoczecia, czas_zakonczenia)
values ('2020-05-01', '2020-05-09')

insert into turniej(czas_rozpoczecia, czas_zakonczenia)
values ('2020-07-30', '2020-08-02')

insert into turniej(czas_rozpoczecia, czas_zakonczenia)
values ('2020-10-10', '2020-11-11')

insert into turniej(czas_rozpoczecia, czas_zakonczenia)
values ('2020-12-30', '2021-01-10')

insert into gracz_turniej
values (1, 1)
insert into gracz_turniej
values (1, 2)
insert into gracz_turniej
values (1, 3)
insert into gracz_turniej
values (1, 4)
insert into gracz_turniej
values (1, 5)
insert into gracz_turniej
values (2, 1)
insert into gracz_turniej
values (2, 4)
insert into gracz_turniej
values (2, 5)
insert into gracz_turniej
values (4, 1)
insert into gracz_turniej
values (5, 5)


insert into gra(id_gracz1, id_gracz2, id_rodzaj_gry, czas_rozpoczecia, czas_zakonczenia, rankigowa, wynik, ruchy,
                id_tuniej)
values (1, 2, 1, '2020-10-10 12:50:00', '2020-10-10 13:00:00', 1, '0',
        '1.e4e52.Nf3Nc63.Bb5a64.Ba4Nf65.0-0b56.Bb3Bc57.a4Rb88.c3d69.d4Bb610.axb5axb511.Qd30-012.Bg5exd413.cxd4h614.Bh4g515.e5gxh416.Qg6+Kh817.Qxh6+Nh718.Bc2f519.exf6Rf720.Ng5Qxf621.Nxf7+Qxf722.Bxh7Qxh723.Qf8+Qg824.Qh6+Qh725.Qf8+Qg826.Qh6+Qh7',
        4)

insert into gra(id_gracz1, id_gracz2, id_rodzaj_gry, czas_rozpoczecia, czas_zakonczenia, rankigowa, wynik, ruchy,
                id_tuniej)
values (1, 4, 3, '2019-12-12 10:00:00', '2019-12-30 12:00:00', 1, '1',
        '1.e4g62.d4Bg73.Nf3d64.Bc4e65.0-0Ne76.Re10-07.c3Nd78.Bb3a69.a4c510.Be3cxd411.cxd4d512.Nc3dxe413.Nxe4Nf614.Nxf6+Bxf615.Bh6Re816.Bg5Bxg517.Nxg5Nf518.Nf3Bd719.d5exd520.Qxd5Be621.Qxd8Raxd822.Bxe6Rxe623.Rxe6fxe624.Kf1Nd425.Rd1Nc626.Rxd8+Nxd827.Ke2Kf828.Kd3Ke729.Kc4Kd630.Ng5h631.Ne4+Ke532.Nc5Kd633.b4g534.a5g435.b5axb5+36.Kxb5Kc737.g3h538.Nd3Nf739.Nf4Ng540.Nxh5Ne441.Nf4Nxf242.Nxe6+Kd643.Nc5Kc744.Kc4Kc645.Kd4Kb546.Nxb7Nh347.Ke4Ka648.Nc5+Kxa549.Nd3Kb550.Kf5Kc451.Kxg4Ng152.Ne5+Kd553.Nf3Ne254.Kf5Kd655.g4Ke756.h4Kf757.g5Ng3+58.Kg4Ne459.Kf4Nd660.h5Ke661.Nd4+Kf762.Nf5Nc463.g6+Kf664.g7Kf765.h6Kg866.Ne7+',
        1)

insert into gra(id_gracz1, id_gracz2, id_rodzaj_gry, czas_rozpoczecia, czas_zakonczenia, rankigowa, wynik, ruchy,
                id_tuniej)
values (5, 4, 5, '2020-11-10 12:50:00', '2020-11-10 13:00:00', 0, '0',
        '1.e4e52.Nf3Nc63.Bc4Nf64.d3Be75.Nc3d66.a30-07.0-0Na58.Ba2c59.Bg5Nc610.Bxf6Bxf611.Nd5g612.b4Bg713.bxc5dxc514.Rb1b615.c3Be616.Qe2Ne717.Nxe7+Qxe718.a4Rfd819.Rfd1Rd720.a5bxa521.Rb5Rad822.Bxe6Qxe623.c4a424.h3Qc625.Qc2a626.Ra5f527.Re1Rxd328.Qxa4Qxa429.Rxa4Rd130.Rxd1Rxd1+31.Kh2Rd632.g4Bf633.gxf5gxf534.exf5e435.Ng1Rd236.Rxa6Be5+37.Kg2e338.h4Rxf2+39.Kh3e240.Nxe2Rxe241.Kg4Re4+42.Kg5Rxc443.Ra8+Kf744.Ra7+Ke845.f6Bf4+46.Kf5Bh247.Rxh7Rf4+48.Ke6Re4+49.Kf5Rf4+50.Ke6Re4+51.Kf5Rf4+',
        NULL)

insert into gra(id_gracz1, id_gracz2, id_rodzaj_gry, czas_rozpoczecia, czas_zakonczenia, rankigowa, wynik, ruchy,
                id_tuniej)
values (3, 2, 2, '2020-01-09 12:50:00', '2020-01-10 00:01:00', 0, '2',
        '1.e4d52.exd5Qxd53.Nc3Qa54.d4Nf65.Nf3Bf56.Bc4e67.0-0c68.Re1Be79.Bd2Qd810.Nh4Bg411.Be2Qxd412.Bg5Qxd113.Raxd1Bxe214.Rxe2g615.Bxf6Bxf616.Nf3Bxc317.bxc3Nd718.Red2Nc519.Rd4Ke720.Ne5f621.Nd3Nxd322.R1xd3Rhd823.Kf1e524.Rb4b625.Rh3h526.g4Rd1+27.Ke2Rad828.gxh5gxh529.Rd3Ra130.Ra4Rxd331.cxd3a532.Kf3Ke633.Kg3Rd134.d4Rd3+35.Kh4Rxc336.dxe5fxe537.Re4Kf538.Re2b5',
        NULL)

insert into gra(id_gracz1, id_gracz2, id_rodzaj_gry, czas_rozpoczecia, czas_zakonczenia, rankigowa, wynik, ruchy,
                id_tuniej)
values (1, 3, 4, '2020-05-20 12:50:00', '2020-05-20 13:00:00', 1, '2',
        '1.e4e52.Nf3Nc63.Bb5Nf64.0-0Nxe45.d4Nd66.Bxc6dxc67.dxe5Nf58.Qxd8+Kxd89.Rd1+Ke810.Nc3Ne711.a4Ng612.a5a613.h3Be714.Be3h515.Re1h416.Bg5Rh517.Bxe7Kxe718.Ra4b519.Rd4Be620.b4Kf821.Rdd1Re822.Nd4c523.Nxe6+Rxe624.Rd8+Re825.Rxe8+Kxe826.Nd5Kd727.f4c628.Nb6+Ke729.Nc8+Ke630.Nd6Nxf431.Ne4cxb432.Nc5+Kd533.Nxa6c534.Rd1+Kc435.Nc7Ne636.Nd5Nd437.Nb6+Kc338.a6Kxc239.a7Rh840.Rf1b341.Rf2+Kd342.Nd7Ra8',
        NULL)
