SET AUTOTRACE ON;
SET ECHO ON;
-- Seznam všech učitelů a jejich počet hodin i s celkovymi součty, které jsou v datu od 1.1.21 pro predmět kde je učitel vyučující
select sum(r.pocetHodin) as "Hodiny učitele", u.jmeno from rozvrhova_akce r join ucitel u on r.ucitel_id = u.id 
where r.datum > to_date('01.01.21','DD.MM.RR') and r.predmet_id = u.id group by cube(r.pocetHodin, u.jmeno) order by u.jmeno;

-- Seznam počtu studentů předmětu v zimním semestru v období od 1. ledna do 1. března, agregováno podle názvu předmětu
select p.nazev, count(r.pocetStudentu) as "Počet studentů" from rozvrhova_akce r join predmet p on p.id = r.predmet_id 
join kategorie k on k.id = r.kategorie_id where k.semestr = 'Zimní' 
and r.datum > to_date('01.01.21','DD.MM.RR') and r.datum < to_date('01.03.21','DD.MM.RR') 
group by ROLLUP(p.nazev)