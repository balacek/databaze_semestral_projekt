-- Vytvoření rozvrhové akce
BEGIN
  balicek_buss_logika.vytvor_rozvrhovou_akci(TO_TIMESTAMP('10:15:46', 'HH24:MI:SS'), TO_DATE('10.5.21', 'DD.MM.YY'), 2, 12, 101, 22, 21, 12);
END;
/

SELECT * FROM ROZVRHOVA_AKCE WHERE id = (SELECT MAX(id) FROM ROZVRHOVA_AKCE);
SELECT * FROM REL_RA_UCEBNA WHERE rozvrhova_akce_id = (SELECT MAX(id) FROM ROZVRHOVA_AKCE);

-- Vytvoření nového předmětu se závislostmi
BEGIN
  balicek_buss_logika.vytvor_novy_predmet(22, 12, 101, 'Nový předmět', 'Popis předmětu', 'Požadavky předmětu', TO_DATE('10.5.21', 'DD.MM.YY'), 'Zápočet', 2, 5);
END;
/

SELECT * FROM PREDMET WHERE id = (SELECT MAX(id) FROM PREDMET);
SELECT * FROM ROZVRHOVA_AKCE WHERE ROWNUM <= 3 ORDER BY id DESC;
