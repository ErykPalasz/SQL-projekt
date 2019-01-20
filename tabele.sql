--    usuwanie
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


--    tabele
CREATE TABLE dane_osobowe(
   id_dane_osobowe VARCHAR(20) NOT NULL, 
   imie VARCHAR(20) NOT NULL, 
   nazwisko VARCHAR(30), 
   email VARCHAR(32), 
   telefon VARCHAR(11)
);
ALTER TABLE dane_osobowe ADD PRIMARY KEY(id_dane_osobowe);

CREATE TABLE seanse(
   id_seansu VARCHAR(30) NOT NULL,
   id_filmu VARCHAR(20) NOT NULL,
   godzina_seansu VARCHAR(5) NOT NULL 
);
ALTER TABLE seanse ADD PRIMARY KEY(id_seansu);

CREATE TABLE filmy(
   id_filmu VARCHAR(20) NOT NULL,
   id_rezyser VARCHAR(20) NOT NULL,
   id_gatunku VARCHAR(20) NOT NULL,
   tytul VARCHAR(100) NOT NULL,
   data_premiery DATE,
   opis VARCHAR(512)
);
ALTER TABLE filmy ADD PRIMARY KEY(id_filmu);

CREATE TABLE gatunki(
   id_gatunku VARCHAR(20) NOT NULL,
   nazwa VARCHAR(15)
);
ALTER TABLE gatunki ADD PRIMARY KEY(id_gatunku);

create table klienci(
   id_klient VARCHAR(20) NOT NULL, 
   id_dane_osobowe VARCHAR(20)
);
alter table klienci add primary key(id_klient);

create table sprzedawcy(
   id_sprzedawca VARCHAR2(20) NOT NULL, 
   id_dane_osobowe VARCHAR2(20) NOT NULL,
   pesel VARCHAR(11) NOT NULL,
   data_zatrudnienia DATE NOT NULL, 
   data_zwolnienia DATE
);
alter table sprzedawcy add primary key(id_sprzedawca);

create table miejsca(
   id_miejsca VARCHAR(20) NOT NULL,
   rzad_litera VARCHAR(2) NOT NULL, 
   fotel_cyfra VARCHAR(2) NOT NULL
);
alter table miejsca add primary key(id_miejsca);

create table bilety  (
   id_biletu VARCHAR(50) NOT NULL,
   id_miejsca VARCHAR(20) NOT NULL,
   id_klient VARCHAR(20) NOT NULL,
   id_sprzedawca VARCHAR(20) NOT NULL,
   id_seansu VARCHAR(20) NOT NULL,
   rodzaj_biletu VARCHAR(15) check(rodzaj_biletu in('normalny 18zl', 'ulgowy 12zl', 'emeryt 8zl', 'dziecko 4zl', NULL)),
   data_kupna DATE NOT NULL
);
alter table bilety add primary key(id_biletu);

create table rezyserzy(
   id_rezyser VARCHAR2(20) NOT NULL,
   imie VARCHAR2(20) NOT NULL,
   nazwisko VARCHAR2(20) NOT NULL
);
alter table rezyserzy add primary key(id_rezyser);

--    relacje
alter table klienci add foreign key(id_dane_osobowe) REFERENCES dane_osobowe(id_dane_osobowe);
alter table sprzedawcy add foreign key(id_dane_osobowe) REFERENCES dane_osobowe(id_dane_osobowe);
alter table bilety add foreign key(id_miejsca) REFERENCES miejsca(id_miejsca);
alter table bilety add foreign key(id_klient) REFERENCES klienci(id_klient);
alter table bilety add foreign key(id_sprzedawca) REFERENCES sprzedawcy(id_sprzedawca);
alter table bilety add foreign key(id_seansu) REFERENCES seanse(id_seansu);
alter table seanse add foreign key(id_filmu) REFERENCES filmy(id_filmu);
alter table filmy add foreign key(id_rezyser) REFERENCES rezyserzy(id_rezyser);
alter table filmy add foreign key(id_gatunku) REFERENCES gatunki(id_gatunku);

--    indeksy
CREATE index indeks_sean_film_datagodz on seanse(id_filmu, godzina_seansu);
CREATE index indeks_imie_nazw on dane_osobowe(imie, nazwisko);
CREATE index indeks_bile_miej_sean_wazn on bilety(id_miejsca, id_seansu, termin_waznosci);
CREATE index indeks_miej_rzad_fote on miejsca(rzad_litera, fotel_cyfra);

--    sekwencje
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

--    triggery generujące identyfikatory
CREATE or REPLACE trigger dane_osob_trigg_insert
before insert on dane_osobowe 
FOR EACH ROW 
DECLARE NUMEREK number;
begin
   select id_dane_osobowe_seq.nextval into NUMEREK from dual;
   :NEW.id_dane_osobowe := concat(concat(substr(:NEW.imie,1,1),substr(:NEW.nazwisko,1,1)),NUMEREK);
end;
/

CREATE or REPLACE trigger klienci_trigg_insert
before insert on klienci 
FOR EACH ROW
DECLARE NUMEREK number;
begin
   select id_klient_seq.nextval into NUMEREK from dual;
   :NEW.id_klient := concat(concat(:NEW.id_dane_osobowe, NUMEREK), 'KL');
end;
/

CREATE or REPLACE trigger sprzedawcy_trigg_insert
before insert on sprzedawcy 
FOR EACH ROW
DECLARE NUMEREK number;
begin
   select id_sprzedawca_seq.nextval into NUMEREK from dual;
   :NEW.id_sprzedawca := concat(concat(:NEW.id_dane_osobowe, NUMEREK), 'SP');
end;
/

CREATE or REPLACE trigger rezyserzy_trigg_insert
before insert on rezyserzy
FOR EACH ROW 
DECLARE NUMEREK number;
begin
   select id_rezyser_seq.nextval into NUMEREK from dual;
   :NEW.id_rezyser := concat(concat(concat(substr(:NEW.imie,1,1),substr(:NEW.nazwisko,1,1)),NUMEREK),'REZ');
end;
/

CREATE or REPLACE trigger gatunki_trigg_insert
before insert on gatunki 
FOR EACH ROW 
DECLARE NUMEREK number;
begin
   select id_gatunku_seq.nextval into NUMEREK from dual;
   :NEW.id_gatunku := concat(substr(:NEW.nazwa,1,1),NUMEREK);
end;
/

CREATE or REPLACE trigger filmy_trigg_insert
before insert on filmy 
FOR EACH ROW 
DECLARE NUMEREK number;
begin 
   select id_filmu_seq.nextval into NUMEREK from dual;
   :NEW.id_filmu := concat(concat(concat(substr(:NEW.tytul,1,2),:NEW.id_gatunku),:NEW.id_rezyser), NUMEREK);
end;
/

CREATE or REPLACE trigger miejsca_trigg_insert
before insert on miejsca 
FOR EACH ROW 
DECLARE NUMEREK number;
begin
   select id_miejsca_seq.nextval into NUMEREK from dual;
   :NEW.id_miejsca := concat(concat(:NEW.rzad_litera, :NEW.fotel_cyfra), NUMEREK);
end;
/

CREATE or REPLACE trigger seanse_trigg_insert
before insert on seanse 
FOR EACH ROW 
DECLARE NUMEREK number;
begin
   select id_seansu_seq.nextval into NUMEREK from dual;
   :NEW.id_seansu := concat(concat(:NEW.id_filmu, NUMEREK), substr(:NEW.godzina_seansu,1,2));
end;
/

CREATE or REPLACE trigger bilety_trigg_insert
before insert on bilety 
FOR EACH ROW 
DECLARE NUMEREK number;
begin
   select id_biletu_seq.nextval into NUMEREK from dual;
   :NEW.id_biletu := concat(concat(concat(substr(:NEW.rodzaj_biletu,1,2), :NEW.id_miejsca), NUMEREK), :NEW.id_seansu);
   :NEW.data_kupna := current_timestamp;
end;
/

--    triggery poprawiające dane
CREATE or REPLACE trigger bilety_trigg_typ_insert
before insert or update on bilety
for each row 
begin
   if :NEW.rodzaj_biletu is NULL then
   :NEW.rodzaj_biletu := 'normalny 18zl'; 
   end if;
end;
/

