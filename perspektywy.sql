-- minimum 6

create view bilet_druk as (select bilet.id_biletu, seans.id_filmu, miejsca.id_miejsca, bilet.data_kupna, bilet.rodzaj_biletu
from bilet, filmy, miejsca, seanse
where bilet.id_seansu = seans.id_filmu and bilet.id_miejsca = miejsce.id_miejsca and data_kupna = data_kupna and rodzaj_biletu = rodzaj_biletu);