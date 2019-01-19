-- plik wsadowy
DROP DATABASE kino_filar;

DROP TABLE dane_osobowe;
DROP TABLE rodzaj_biletu;
DROP TABLE seanse;
DROP TABLE filmy;
DROP TABLE gatunki;

CREATE DATABASE kino_filar;

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
   cena NUMERIC(4) NOT NULL,
);
ALTER TABLE rodzaj_biletu ADD PRIMARY KEY(id_biletu);

CREATE TABLE seanse(
   id_seansu VARCHAR(10) NOT NULL,
   id_filmu VARCHAR(10) NOT NULL,
   data_godzina DATETIME(16) NOT NULL,
);
ALTER TABLE seanse ADD PRIMARY KEY(id_seansu);

CREATE TABLE filmy(
   id_filmu VARCHAR(10) NOT NULL,
   id_rezyser VARCHAR(10) NOT NULL,
   id_gatunku VARCHAR(10) NOT NULL,
   tytul VARCHAR(20) NOT NULL,
   data_premiery DATE(10),
   opis VARCHAR(250),
);
ALTER TABLE filmy ADD PRIMARY KEY(id_filmu);

CREATE TABLE gatunki(
   id_gatunku VARCHAR(10) NOT NULL,
   nazwa VARCHAR(15),
);
ALTER TABLE gatunki ADD PRIMARY KEY(id_gatunku);
