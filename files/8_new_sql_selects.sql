SET AUTOTRACE ON;
SET ECHO ON;
-- Zobraz počet hodin vyučovanych předmetu v letním semestru a v zimním, spojene dohromady,
	--			ale jen pro předměty, které mají naplanováno více jak tři rozvrhové akce
(select a.pocethodin, p.nazev from rozvrhova_akce a join predmet p on a.predmet_id = p.id join
kategorie k on  a.kategorie_id = k.id where k.semestr = 'Zimní' OR k.semestr = 'Letní' AND p.id IN (select predmet_id from
rozvrhova_akce group by predmet_id having count(id) > 3))

-- Zobraz učebny, kde je počet studentů menši jak půlka kapacity učebny
select ucebna.nazev, ucebna.budova, ucebna.kapacita, rozvrhova_akce.pocetstudentu,
(ucebna.kapacita - rozvrhova_akce.pocetstudentu) as "Rozdíl kapacity a poctu" 
from rozvrhova_akce join rel_ra_ucebna on rozvrhova_akce.id = rel_ra_ucebna.rozvrhova_akce_id
full outer join ucebna on rel_ra_ucebna.ucebna_id = ucebna.id where 
rozvrhova_akce.pocetstudentu <= (select u.kapacita /2 from ucebna u where u.id = rel_ra_ucebna.ucebna_id);