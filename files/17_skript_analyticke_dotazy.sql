-- Seznam všech učitelů a jejich počet hodin i s celkovymi součty, které jsou v datu od 1.1.21
select sum(r.pocetHodin) as "Hodiny učitele", u.jmeno from rozvrhova_akce r join ucitel u on r.ucitel_id = u.id 
where r.datum > to_date('01.01.21','DD.MM.RR') group by cube(r.pocetHodin, u.jmeno) order by u.jmeno;