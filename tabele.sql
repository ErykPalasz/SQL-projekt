DROP TABLE dane_osobowe;
DROP TABLE rodzaj_biletu;
DROP TABLE seanse;
DROP TABLE filmy;
DROP TABLE gatunki;
drop table klienci;
drop table sprzedawcy;
drop table bilety;
drop table miejsca;
drop table rezyserzy;

CREATE TABLE dane_osobowe(
   id_dane_osobowe VARCHAR(10) NOT NULL, 
   imie VARCHAR(10) NOT NULL, 
   nazwisko VARCHAR(20), 
   email VARCHAR(32), 
   telefon NUMERIC(9)
);
ALTER TABLE dane_osobowe ADD PRIMARY KEY(id_dane_osobowe);

CREATE TABLE rodzaj_biletu(
   id_biletu VARCHAR(10) NOT NULL,
   rodzaj VARCHAR(10) NOT NULL,
   cena NUMERIC(4) NOT NULL
);
ALTER TABLE rodzaj_biletu ADD PRIMARY KEY(id_biletu);

CREATE TABLE seanse(
   id_seansu VARCHAR(10) NOT NULL,
   id_filmu VARCHAR(10) NOT NULL,
   data_godzina DATE NOT NULL
);
ALTER TABLE seanse ADD PRIMARY KEY(id_seansu);

CREATE TABLE filmy(
   id_filmu VARCHAR(10) NOT NULL,
   id_rezyser VARCHAR(10) NOT NULL,
   id_gatunku VARCHAR(10) NOT NULL,
   tytul VARCHAR(20) NOT NULL,
   data_premiery DATE,
   opis VARCHAR(250)
);
ALTER TABLE filmy ADD PRIMARY KEY(id_filmu);

CREATE TABLE gatunki(
   id_gatunku VARCHAR(10) NOT NULL,
   nazwa VARCHAR(15)
);
ALTER TABLE gatunki ADD PRIMARY KEY(id_gatunku);

create table klienci(
   id_klient VARCHAR(10) NOT NULL, 
   id_dane_osobowe VARCHAR(10) NOT NULL
);
alter table klienci add primary key(id_klient);

create table sprzedawcy
(
   id_sprzedawca VARCHAR2(10) NOT NULL, 
   id_dane_osobowe VARCHAR2(10) NOT NULL, 
   data_zatrudnienia DATE, 
   data_zwolnienia DATE
);
alter table sprzedawcy add primary key(id_sprzedawca);

create table miejsca
(
id_miejsca VARCHAR2(10) NOT NULL,
rzad_litera CHAR(2) NOT NULL, 
fotel_cyfra INTEGER(2) NOT NULL
);
alter table miejsca add primary key(id_miejsca);

create table bilety
(
id_biletu VARCHAR2(10) NOT NULL,
id_miejsca VARCHAR2(10) NOT NULL,
id_klient VARCHAR2(10) NOT NULL,
id_sprzedawca VARCHAR2(10) NOT NULL,
id_seans VARCHAR2(10) NOT NULL,
id_rodzaj_biletu VARCHAR2(10) NOT NULL,
data_kupna DATETIME(16),
termin_waznosci DATETIME(16)
);
alter table bilety add primary key(id_biletu);

create table rezyserzy
(
id_rezyser VARCHAR2(10) NOT NULL,
imie VARCHAR2(20) NOT NULL,
nazwisko VARCHAR2(20) NOT NULL
);
alter table bilety add primary key(id_rezyser);

alter table klienci add foreign key(id_dane_osobowe) REFERENCES dane_osobowe(id_dane_osobowe);
alter table sprzedawcy add foreign key(id_dane_osobowe) REFERENCES dane_osobowe(id_dane_osobowe);
alter table bilety add foreign key(id_miejsca) REFERENCES miejsca(id_miejsca);
alter table bilety add foreign key(id_klient) REFERENCES klienci(id_klient);
alter table bilety add foreign key(id_sprzedawca) REFERENCES sprzedawcy(id_sprzedawca);
alter table bilety add foreign key(id_seans) REFERENCES seanse(id_seans);
alter table bilety add foreign key(id_rodzaj_biletu) REFERENCES rodzaj_biletu(id_rodzaj_biletu);

alter table seanse add foreign key(id_film) REFERENCES filmy(id_film);
alter table filmy add foreign key(id_rezyser) REFERENCES rezyserzy(id_rezyser);
alter table filmy add foreign key(id_gatunek) REFERENCES gatunki(id_gatunek);



