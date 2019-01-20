-- usuwanie
DROP TABLE dane_osobowe CASCADE CONSTRAINTS PURGE;
DROP TABLE seanse CASCADE CONSTRAINTS PURGE;
DROP TABLE filmy CASCADE CONSTRAINTS PURGE;
DROP TABLE gatunki CASCADE CONSTRAINTS PURGE;
drop table klienci CASCADE CONSTRAINTS PURGE;
drop table sprzedawcy CASCADE CONSTRAINTS PURGE;
drop table bilety CASCADE CONSTRAINTS PURGE;
drop table miejsca CASCADE CONSTRAINTS PURGE;
drop table rezyserzy CASCADE CONSTRAINTS PURGE;

drop sequence id_filmu_seq;
drop sequence id_seansu_seq;
drop sequence id_biletu_seq;
drop sequence id_klient_seq;
drop sequence id_gatunku_seq;
drop sequence id_miejsca_seq;
drop sequence id_rezyser_seq;
drop sequence id_sprzedawca_seq;
drop sequence id_dane_osobowe_seq;


-- tabele
CREATE TABLE dane_osobowe(
   id_dane_osobowe VARCHAR(10) NOT NULL, 
   imie VARCHAR(10) NOT NULL, 
   nazwisko VARCHAR(20), 
   email VARCHAR(32), 
   telefon NUMERIC(9)
);
ALTER TABLE dane_osobowe ADD PRIMARY KEY(id_dane_osobowe);

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
   id_dane_osobowe VARCHAR(10)
);
alter table klienci add primary key(id_klient);
alter table klienci add check(select id_dane_osobowe from dane_osobowe = id_dane_osobowe);

create table sprzedawcy(
   id_sprzedawca VARCHAR2(10) NOT NULL, 
   id_dane_osobowe VARCHAR2(10) NOT NULL,
   pesel VARCHAR(11) NOT NULL,
   data_zatrudnienia DATE, 
   data_zwolnienia DATE
);
alter table sprzedawcy add primary key(id_sprzedawca);

create table miejsca(
   id_miejsca VARCHAR(10) NOT NULL,
   rzad_litera CHAR(2) NOT NULL, 
   fotel_cyfra NUMERIC(2) NOT NULL
);
alter table miejsca add primary key(id_miejsca);

create table bilety  (
   id_biletu VARCHAR(10) NOT NULL,
   id_miejsca VARCHAR(10) NOT NULL,
   id_klient VARCHAR(10) NOT NULL,
   id_sprzedawca VARCHAR(10) NOT NULL,
   id_seansu VARCHAR(10) NOT NULL,
   rodzaj_biletu VARCHAR(15) check(rodzaj_biletu in('normalny 18zl', 'ulgowy 12zl', 'emeryt 8zl', 'dziecko 4zl')),
   data_kupna DATE,
   termin_waznosci DATE
);
alter table bilety add primary key(id_biletu);

create table rezyserzy(
   id_rezyser VARCHAR2(10) NOT NULL,
   imie VARCHAR2(20) NOT NULL,
   nazwisko VARCHAR2(20) NOT NULL
);
alter table rezyserzy add primary key(id_rezyser);

-- relacje
alter table klienci add foreign key(id_dane_osobowe) REFERENCES dane_osobowe(id_dane_osobowe);
alter table sprzedawcy add foreign key(id_dane_osobowe) REFERENCES dane_osobowe(id_dane_osobowe);
alter table bilety add foreign key(id_miejsca) REFERENCES miejsca(id_miejsca);
alter table bilety add foreign key(id_klient) REFERENCES klienci(id_klient);
alter table bilety add foreign key(id_sprzedawca) REFERENCES sprzedawcy(id_sprzedawca);
alter table bilety add foreign key(id_seansu) REFERENCES seanse(id_seansu);
alter table seanse add foreign key(id_filmu) REFERENCES filmy(id_filmu);
alter table filmy add foreign key(id_rezyser) REFERENCES rezyserzy(id_rezyser);
alter table filmy add foreign key(id_gatunku) REFERENCES gatunki(id_gatunku);

-- indeksy
CREATE index indeks_sean_film_datagodz on seanse(id_filmu, data_godzina);
CREATE index indeks_imie_nazw on dane_osobowe(imie, nazwisko);
CREATE index indeks_bile_miej_sean_wazn on bilety(id_miejsca, id_seansu, termin_waznosci);
CREATE index indeks_miej_rzad_fote on miejsca(rzad_litera, fotel_cyfra);

-- sekwencje
CREATE sequence id_dane_osobowe_seq
minvalue 1 maxvalue 999999999999999999999999999
increment by 1 start with 70 cache 20 noorder nocycle;

CREATE sequence id_seansu_seq
minvalue 1 maxvalue 999999999999999999999999999
increment by 1 start with 70 cache 20 noorder nocycle;

CREATE sequence id_filmu_seq
minvalue 1 maxvalue 999999999999999999999999999
increment by 1 start with 70 cache 20 noorder nocycle;

CREATE sequence id_gatunku_seq
minvalue 1 maxvalue 999999999999999999999999999
increment by 1 start with 70 cache 20 noorder nocycle;

CREATE sequence id_klient_seq
minvalue 1 maxvalue 999999999999999999999999999
increment by 1 start with 70 cache 20 noorder nocycle;

CREATE sequence id_sprzedawca_seq
minvalue 1 maxvalue 999999999999999999999999999
increment by 1 start with 70 cache 20 noorder nocycle;

CREATE sequence id_miejsca_seq
minvalue 1 maxvalue 999999999999999999999999999
increment by 1 start with 70 cache 20 noorder nocycle;

CREATE sequence id_biletu_seq
minvalue 1 maxvalue 999999999999999999999999999
increment by 1 start with 70 cache 20 noorder nocycle;

CREATE sequence id_rezyser_seq
minvalue 1 maxvalue 999999999999999999999999999
increment by 1 start with 70 cache 20 noorder nocycle;

-- triggery

--    id triggery
CREATE or REPLACE trigger dane_osob_trigg_insert
before insert on dane_osobowe FOR EACH ROW DECLARE NUMEREK number;
begin
   select id_dane_osobowe_seq.nextval into NUMEREK from dual;
   :NEW.id_dane_osobowe := concat(concat(substr(:NEW.imie,1,1),substr(:NEW.nazwisko,1,1)),NUMEREK);
end;

CREATE or REPLACE trigger klienci_trigg_insert
before insert on dane_osobowe FOR EACH ROW
begin
   :NEW.id_klient := concat(:NEW.id_dane_osobowe, 'KL');
end;