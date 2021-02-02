SET AUTOTRACE ON;
-- Seznam učitelů a jejich předmětů, počet hodin vyučujícího seřazeno podle předmětu
select u.jmeno, u.prijmeni, p.nazev, a.pocethodin as "Vyucujici hodiny" from obj_rozvrhova_akce a join obj_ucitel u on a.ucitel_id = u.id join obj_predmet p
on a.predmet_id = p.id order by a.predmet_id;

-- Zobraz učebny a předměty vyučované v učebně
  select u.nazev as "Nazev ucebny", u.budova as "Budova", p.nazev as "Vyucovany predmet" from obj_rozvrhova_akce a right join obj_predmet p on a.predmet_id = p.id join obj_rel_ra_ucebna re
 on a.id = re.rozvrhova_akce_id join obj_ucebna u on re.ucebna_id = u.id where a.id IN
 (select obj_rozvrhova_akce.id from obj_rozvrhova_akce join obj_kategorie on
 obj_rozvrhova_akce.kategorie_id = obj_kategorie.id where semestr = 'Zimní') order by u.nazev desc;

 -- Zobraz počet hodin vyučovanych předmetu v letním semestru a v zimním, spojene dohromady,
	--			ale jen pro předměty, které mají naplanováno více jak tři rozvrhové akce
(select a.pocethodin, p.nazev from obj_rozvrhova_akce a join obj_predmet p on a.predmet_id = p.id join
obj_kategorie k on  a.kategorie_id = k.id where k.semestr = 'Zimní' AND p.id IN (select predmet_id from
rozvrhova_akce group by predmet_id having count(id) > 3))
UNION ALL
(select a.pocethodin, p.nazev from obj_rozvrhova_akce a join predmet p on a.predmet_id = p.id join
obj_kategorie k on  a.kategorie_id = k.id where k.semestr = 'Letní' AND p.id IN (select predmet_id from obj_rozvrhova_akce group by
predmet_id having count(id) > 3));

-- Seznam odučenych hodin učitele za týden, tri mesice, rok od dnešního dne
select jedna.jmeno as "Jmeno ucitele", jedna.prijmeni as "Prijmeni ucitele", jedna.pocethodin as "Pocet tyden", dva.pocethodin
as "Pocet tri mesice", tri.pocethodin as "Pocet rok" from
(select a.pocethodin, a.id, u.jmeno, u.prijmeni from obj_rozvrhova_akce a join obj_ucitel u on a.ucitel_id = u.id
where TO_DATE(a.datum, 'DD.MM.YY') between TO_DATE(sysdate, 'DD.MM.YY')
and TO_DATE(sysdate + 7, 'DD.MM.YY')) jedna left join
(select a.pocethodin, a.id from obj_rozvrhova_akce a join obj_ucitel u on a.ucitel_id = u.id
where TO_DATE(a.datum, 'DD.MM.YY') between TO_DATE(sysdate, 'DD.MM.YY')
and TO_DATE(add_months(sysdate, 3), 'DD.MM.YY')) dva on jedna.id = dva.id left join
(select a.pocethodin, a.id from obj_rozvrhova_akce a join obj_ucitel u on a.ucitel_id = u.id
where TO_DATE(a.datum, 'DD.MM.YY') between TO_DATE(sysdate, 'DD.MM.YY')
and TO_DATE(add_months(sysdate, 12), 'DD.MM.YY')) tri on jedna.id = tri.id;

-- Zobraz učebny, kde je počet studentů menši jak půlka kapacity učebny
select obj_ucebna.nazev, obj_ucebna.budova, obj_ucebna.kapacita, obj_rozvrhova_akce.pocetstudentu,
(obj_ucebna.kapacita - obj_rozvrhova_akce.pocetstudentu) as "Rozdíl kapacity a poctu" from obj_rozvrhova_akce join obj_rel_ra_ucebna on obj_rozvrhova_akce.id = obj_rel_ra_ucebna.rozvrhova_akce_id
full outer join obj_ucebna on obj_rel_ra_ucebna.ucebna_id = obj_ucebna.id where obj_rozvrhova_akce.pocetstudentu <= obj_ucebna.kapacita / 2;

-- Seznam učitelů a vyučovaných předmětů, které probíhají v zadaný čas, včetně délky hodiny
select obj_ucitel.jmeno, obj_ucitel.prijmeni, obj_predmet.nazev,
obj_rozvrhova_akce.datum, obj_rozvrhova_akce.cas from obj_rozvrhova_akce join obj_ucitel on
obj_rozvrhova_akce.ucitel_id = obj_ucitel.id join obj_predmet on obj_rozvrhova_akce.predmet_id = obj_predmet.id
where obj_rozvrhova_akce.datum = TO_DATE(sysdate, 'DD.MM.YY') and
obj_rozvrhova_akce.cas >= to_timestamp('17:13:56', 'HH24:MI:SS')
INTERSECT
select obj_ucitel.jmeno, obj_ucitel.prijmeni, obj_predmet.nazev,
obj_rozvrhova_akce.datum, obj_rozvrhova_akce.cas from obj_rozvrhova_akce join obj_ucitel on
obj_rozvrhova_akce.ucitel_id = obj_ucitel.id join obj_predmet on obj_rozvrhova_akce.predmet_id = obj_predmet.id
where obj_rozvrhova_akce.datum = TO_DATE(sysdate, 'DD.MM.YY') and
obj_rozvrhova_akce.cas <= to_timestamp('17:13:56', 'HH24:MI:SS') + obj_rozvrhova_akce.pocethodin/24;
