-- 1. wyswietl wszystkie kategorie czasu gry
select nazwa
from czas_gry;

-- 2. Posortuj graczy wzgledem nazwiska , imenia i nicku
select naziwsko, imie, nick
from gracz
order by naziwsko, imie, nick;

-- 3. Wyswielt nazwiska graczy bez duplikatów
select distinct naziwsko
from gracz;

-- 4. wyswiet id graczy i ich elo jesli elo jest wieksze niz 1200
select id_gracz, elo
from gracz_elo
where elo > 1200;

-- 5. wyswiet id graczy i ich elo jesli elo dla rodzaju gry id 1 jest wieksze niz 1200
select id_gracz, elo
from gracz_elo
where elo > 1200
  and id_rodzaj_gry = 1;

-- 6. wyswietl opis wariacji kalsyczne, szachy 960, torpedo
select opis
from wariacje
where nazwa in ('klasyczne', 'szachy 960', 'torpedo');

-- 7. wyswietl nazwy czas_gry których nazwa zawiera druga litere 'l' lub 'u'
select nazwa
from czas_gry
where nazwa like '_[lu]%';

-- 8. wyswietl id turnieji miedzy 01.05.2019 a 01.06.2020
select id_turniej
from turniej
where czas_zakonczenia between '2019-05-01' and '2020-06-01';

-- 9. wyswietl id_graczy, id_rodzaju_rozgrywki dla graczy nie posiadajacych elo
select id_gracz, id_rodzaj_gry
from gracz_elo
where elo is null;

-- 10 zamien wartosc null w gracz_elo na 1200
select id_gracz, id_rodzaj_gry, coalesce(elo, 1200)
from gracz_elo;

-- 11. wyswietl 3 najlepszych graczy z rodzaju gry 3
select top 3 id_gracz
from gracz_elo
where id_rodzaj_gry = 1
order by elo desc;

-- 12 utworz nową kolumne z czasem trawnia turnieju
select id_turniej,
       czas_rozpoczecia,
       czas_zakonczenia,
       datediff(day, czas_rozpoczecia, czas_zakonczenia) as czas_trwania
from turniej;

-- 13. wyswietl imie i nazwisko tak aby wszystkie litry były małe
select lower(imie), lower(naziwsko)
from gracz;

-- 14. zwikesz każdemu graczowi elo o 100 punktów jezli elo < 1200
update gracz_elo
set elo = elo + 100
where elo < 1200;


-- 15. usuń wszystkie gry gracza 3

delete
from gra
where id_gracz1 = 3
   or id_gracz2 = 3;

-- 16. dodaj nowego gracza

insert into gracz(imie, naziwsko, nick)
values (null, 'kozlowski', 'kowa3')