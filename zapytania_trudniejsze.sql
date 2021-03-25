-- 17. Wyswietl imie naziwsko i elo gracza z rodzaju gry 1
select g.imie, g.naziwsko, e.elo
from gracz g
         join gracz_elo e on g.id_gracz = e.id_gracz
where e.id_rodzaj_gry = 1;

-- 18 Dla kazdego gracza biorącego udział w turnieju wyszukaj kiedy tunriej rozpoczał się
-- wyslwielt nick, czas_rozpoczecia i czas_zakonczenia
select g.nick, t.czas_rozpoczecia, t.czas_zakonczenia
from gracz g
         join gracz_turniej gt on g.id_gracz = gt.id_gracz
         join turniej t on gt.id_turniej = t.id_turniej;

-- 19 Znaleźć średnie elo
select avg(elo)
from gracz_elo;

-- 20 Dla każdego rodzaju gry wypisz id, nazwe wariacji, nazwe grupy czasowej, i srednie elo
select rg.id_rodzaj_gry, w.nazwa, cg.nazwa, avg(elo) as 'avg_elo'
from rodzaj_gry rg
         join gracz_elo ge on rg.id_rodzaj_gry = ge.id_rodzaj_gry
         join wariacje w on rg.id_wariacja = w.id_warjacja
         join czas_gry cg on cg.id_czas_gry = rg.id_czas_gry
group by w.nazwa, rg.id_rodzaj_gry, cg.nazwa;

-- 21 Znajdz rodzaje gry z srednim elo wiekszym niż 1500
-- wypisz id, nazwe wariacji, nazwe grupy czasowej, i srednie elo
-- posortuj elo malejąco
select rg.id_rodzaj_gry, w.nazwa, cg.nazwa, avg(elo) as 'avg_elo'
from rodzaj_gry rg
         join gracz_elo ge on rg.id_rodzaj_gry = ge.id_rodzaj_gry
         join wariacje w on rg.id_wariacja = w.id_warjacja
         join czas_gry cg on cg.id_czas_gry = rg.id_czas_gry
group by w.nazwa, rg.id_rodzaj_gry, cg.nazwa;

-- 22 Wyswielt nick graczyz z naziwskami dłużyszmi niż średnia
select id_gracz, naziwsko
from gracz
where len(naziwsko) > (select avg(len(naziwsko)) from gracz)

-- 23 Wyswielt id i nick graczy który nie brali udzaił w turnieju
select id_gracz, nick
from gracz
where id_gracz not in (select id_gracz from gracz_turniej)

-- 24 znajdz gracza który brał udział w najwiekszej niczbie turnieji
select id_gracz, nick
from gracz
where id_gracz = (select top 1 id_gracz from gracz_turniej group by id_gracz order by count(id_gracz) desc);

-- 25 Zwiększyć elo o 1% dla każdego gracza biorącego udział w grze turniejowej
update gracz_elo
set elo = elo * 1.01
where id_gracz in (select id_gracz1 from gra where id_tuniej is not NULL)
   or id_gracz in (select id_gracz2 from gra where id_tuniej is not NULL);

-- 26 Usun graczy bez zadnego elo
delete gracz
where id_gracz not in (select id_gracz from gracz_elo);

-- 27 Wyświetl razem wszystkie czasy turnieji i gier
select czas_rozpoczecia, czas_zakonczenia
from turniej
union all
select czas_rozpoczecia, czas_zakonczenia
from gra;


-- 32.1 utówrz procedure zmien_elo przyjmujaca 3 parametry id_gracz id_rodzaj_gry zmiana_elo
CREATE PROC zmien_elo @id_gracz INT, @id_rodzaj_gry INT, @ilosc INT
AS
UPDATE gracz_elo
SET elo = elo + @ilosc
WHERE id_gracz = @id_gracz
and id_rodzaj_gry = @id_rodzaj_gry;

-- SELECT *
-- FROM gracz_elo
-- WHERE id_gracz = 1;
--     EXEC zmien_elo 1, 3, 100;

-- 32.2 utwórz procedure dodaj_gracza

CREATE PROC dodaj_gracza @imie VARCHAR(30), @nazwisko VARCHAR(50), @nick CHAR(20)
AS
INSERT INTO gracz (imie, naziwsko, nick)
VALUES (@imie, @nazwisko, @nick);

--     exec dodaj_gracza karol, perkowski, karlper;
--     select * from gracz;

-- 33.1 utwórz funckje aktywnośc_gracza wypisującego w ilu grach brał udział
CREATE FUNCTION aktywnosc_gracza (@id_gracza INT) RETURNS INT
BEGIN
RETURN (SELECT COUNT(*) FROM gra WHERE id_gracz1= @id_gracza or id_gracz2= @id_gracza);
END

SELECT COUNT(*) FROM gra WHERE id_gracz1= 3 or id_gracz2= 3;
SELECT dbo.aktywnosc_gracza(3);

-- 33.2 utwórz funckje obliczajacą roznice najwiekszego i najmiejszego elo dla id_rodzaj_gry

CREATE FUNCTION roznica_elo (@id_rodzaj_gry int) RETURNS DECIMAL
BEGIN
DECLARE @max_elo DECIMAL;
SET @max_elo = (SELECT TOP(1) elo FROM gracz_elo WHERE id_rodzaj_gry = @id_rodzaj_gry ORDER BY elo DESC)
DECLARE @min_elo DECIMAL;
SET @min_elo = (SELECT TOP(1) elo FROM gracz_elo WHERE id_rodzaj_gry = @id_rodzaj_gry ORDER BY elo ASC)
RETURN (@max_elo - @min_elo)
END

PRINT dbo.roznica_elo(1);


-- 34.1 utwórz widok aktywności gracza ilośc gier w jakich brali udział i ilość turnieji w jakich brali udział uwzgledni graczy niekatywnych
-- Funkcja pomocnicza
CREATE FUNCTION aktywnosc_turniej (@id_gracza INT) RETURNS INT
BEGIN
RETURN (SELECT COUNT(*) FROM gracz_turniej WHERE id_gracz= @id_gracza);
END

CREATE VIEW raport_aktywnosci_gracza
AS
SELECT imie,naziwsko,nick, dbo.aktywnosc_gracza(id_gracz) AS 'Ilosc gier', dbo.aktywnosc_turniej(id_gracz) as 'Ilosc turnieji'
FROM gracz;

-- 34.2 utwórz widok pokazujący róznice_elo, srednie_elo, std_dev i id najleszpego gracza dla  rodzaju gry
CREATE FUNCTION top_elo (@id_rodzaj_gry int) RETURNS int
BEGIN
DECLARE @top_gracz int;
SET @top_gracz = (SELECT TOP(1) id_gracz FROM gracz_elo WHERE id_rodzaj_gry = @id_rodzaj_gry ORDER BY elo DESC)
RETURN @top_gracz
END

CREATE VIEW raport_elo
AS
select id_rodzaj_gry, avg(elo) as 'srednie elo', dbo.roznica_elo(id_rodzaj_gry) as 'Roznica elo', stdev(elo) as "Odchyelenie standardowe",
       dbo.top_elo(id_rodzaj_gry) as 'id najlepszego gracza'
from gracz_elo
    group by id_rodzaj_gry;









