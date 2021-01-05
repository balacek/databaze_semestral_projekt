-- Seznam učitelů a jejich předmětů, počet hodin vyučujícího seřazeno podle předmětu
select u.jmeno, u.prijmeni, p.nazev, a.pocethodin as "Vyucujici hodiny" from rozvrhova_akce a join ucitel u on a.ucitel_id = u.id join predmet p
on a.predmet_id = p.id order by a.predmet_id;

-- Zobraz učebny a předměty vyučované v učebně
  select u.nazev as "Nazev ucebny", u.budova as "Budova", p.nazev as "Vyucovany predmet" from rozvrhova_akce a right join predmet p on a.predmet_id = p.id join rel_ra_ucebna re
 on a.id = re.rozvrhova_akce_id join ucebna u on re.ucebna_id = u.id where a.id IN
 (select rozvrhova_akce.id from rozvrhova_akce join kategorie on
 rozvrhova_akce.kategorie_id = kategorie.id where semestr = 'Zimní') order by u.nazev desc;

 -- Zobraz počet hodin vyučovanych předmetu v letním semestru a v zimním, spojene dohromady,
	--			ale jen pro předměty, které mají naplanováno více jak tři rozvrhové akce
(select a.pocethodin, p.nazev from rozvrhova_akce a join predmet p on a.predmet_id = p.id join
kategorie k on  a.kategorie_id = k.id where k.semestr = 'Zimní' AND p.id IN (select predmet_id from
rozvrhova_akce group by predmet_id having count(id) > 3))
UNION ALL
(select a.pocethodin, p.nazev from rozvrhova_akce a join predmet p on a.predmet_id = p.id join 
kategorie k on  a.kategorie_id = k.id where k.semestr = 'Letní' AND p.id IN (select predmet_id from rozvrhova_akce group by
predmet_id having count(id) > 3));

-- Seznam odučenych hodin učitele za týden, tri mesice, rok od dnešního dne
select jedna.jmeno as "Jmeno ucitele", jedna.prijmeni as "Prijmeni ucitele", jedna.pocethodin as "Pocet tyden", dva.pocethodin
as "Pocet tri mesice", tri.pocethodin as "Pocet rok" from
(select a.pocethodin, a.id, u.jmeno, u.prijmeni from rozvrhova_akce a join ucitel u on a.ucitel_id = u.id
where TO_DATE(a.datum, 'DD.MM.YY') between TO_DATE(sysdate, 'DD.MM.YY')
and TO_DATE(sysdate + 7, 'DD.MM.YY')) jedna left join
(select a.pocethodin, a.id from rozvrhova_akce a join ucitel u on a.ucitel_id = u.id
where TO_DATE(a.datum, 'DD.MM.YY') between TO_DATE(sysdate, 'DD.MM.YY')
and TO_DATE(add_months(sysdate, 3), 'DD.MM.YY')) dva on jedna.id = dva.id left join
(select a.pocethodin, a.id from rozvrhova_akce a join ucitel u on a.ucitel_id = u.id
where TO_DATE(a.datum, 'DD.MM.YY') between TO_DATE(sysdate, 'DD.MM.YY')
and TO_DATE(add_months(sysdate, 12), 'DD.MM.YY')) tri on jedna.id = tri.id;

-- Zobraz učebny, kde je počet studentů menši jak půlka kapacity učebny
select ucebna.nazev, ucebna.budova, ucebna.kapacita, rozvrhova_akce.pocetstudentu,
(ucebna.kapacita - rozvrhova_akce.pocetstudentu) as "Rozdíl kapacity a poctu" from rozvrhova_akce join rel_ra_ucebna on rozvrhova_akce.id = rel_ra_ucebna.rozvrhova_akce_id
full outer join ucebna on rel_ra_ucebna.ucebna_id = ucebna.id where rozvrhova_akce.pocetstudentu <= ucebna.kapacita / 2;

-- Seznam učitelů a vyučovaných předmětů, které probíhají v zadaný čas, včetně délky hodiny
select ucitel.jmeno, ucitel.prijmeni, predmet.nazev,
rozvrhova_akce.datum, rozvrhova_akce.cas from rozvrhova_akce join ucitel on
rozvrhova_akce.ucitel_id = ucitel.id join predmet on rozvrhova_akce.predmet_id = predmet.id
where rozvrhova_akce.datum = TO_DATE(sysdate, 'DD.MM.YY') and
rozvrhova_akce.cas >= to_timestamp('17:13:56', 'HH24:MI:SS')
INTERSECT
select ucitel.jmeno, ucitel.prijmeni, predmet.nazev,
rozvrhova_akce.datum, rozvrhova_akce.cas from rozvrhova_akce join ucitel on
rozvrhova_akce.ucitel_id = ucitel.id join predmet on rozvrhova_akce.predmet_id = predmet.id
where rozvrhova_akce.datum = TO_DATE(sysdate, 'DD.MM.YY') and
rozvrhova_akce.cas <= to_timestamp('17:13:56', 'HH24:MI:SS') + rozvrhova_akce.pocethodin/24;
