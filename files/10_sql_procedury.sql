CREATE OR REPLACE PACKAGE balicek_buss_logika AS 
	-- Vytvoření rozvrhové akce
	PROCEDURE vytvor_rozvrhovou_akci (cas TIMESTAMP, datum DATE, pocetHodin NUMBER,
pocetStudentu NUMBER, ucitel_id NUMBER, ucebna_id NUMBER, predmet_id NUMBER, kategorie_id NUMBER);
	-- Vytvoření nového předmětu se závislostmi
	PROCEDURE vytvor_novy_predmet (ucitel_id_pa NUMBER, kategorie_id_pa NUMBER, 
ucebna_id_pa NUMBER,nazev_pa VARCHAR2, popis_pa VARCHAR2, pozadavky_pa VARCHAR2, datumakci_pa DATE,
zpusobZakonceni_pa VARCHAR2, delkaAkci_pa NUMBER, pocetStudentuRA NUMBER);
	FUNCTION je_cas_validni(cas_param IN TIMESTAMP, datum_param IN DATE, 
delka_hodiny_param number, ucebna_id_param NUMBER)  
RETURN NUMBER;
END balicek_buss_logika; 
/

CREATE OR REPLACE PACKAGE BODY balicek_buss_logika AS 
PROCEDURE vytvor_rozvrhovou_akci (cas TIMESTAMP, datum DATE, pocetHodin NUMBER,
pocetStudentu NUMBER, ucitel_id NUMBER, ucebna_id NUMBER, predmet_id NUMBER, kategorie_id NUMBER) 
IS
nove_id NUMBER;
BEGIN 
INSERT INTO ROZVRHOVA_AKCE 
(ID, CAS, DATUM, POCETHODIN, UCITEL_ID, KATEGORIE_ID, PREDMET_ID, POCETSTUDENTU) 
VALUES (ROZVRHOVA_AKCE_id_SEQ.NEXTVAL, cas,datum, pocetHodin, ucitel_id, kategorie_id, predmet_id,
pocetStudentu) RETURNING id INTO nove_id;

INSERT INTO REL_RA_UCEBNA (ROZVRHOVA_AKCE_ID, UCEBNA_ID) VALUES (nove_id, ucebna_id);
DBMS_OUTPUT.PUT_LINE( 'Proces dokoncen!' );
COMMIT;

EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE( 'Procedura: akce selhala!' );
            ROLLBACK;
END;

PROCEDURE vytvor_novy_predmet (ucitel_id_pa NUMBER, kategorie_id_pa NUMBER, 
ucebna_id_pa NUMBER,nazev_pa VARCHAR2, popis_pa VARCHAR2, pozadavky_pa VARCHAR2, datumakci_pa DATE,
zpusobZakonceni_pa VARCHAR2, delkaAkci_pa NUMBER, pocetStudentuRA NUMBER) 
IS
existuje_ra NUMBER;
init_cas TIMESTAMP := TO_TIMESTAMP('07:00:00', 'HH24:MI:SS');
init_number NUMBER := 1;
pocetakci NUMBER := 1;
nove_id_ra NUMBER;
nove_id_predmet NUMBER;
NO_SPACE EXCEPTION;
BEGIN
INSERT INTO PREDMET (ID, NAZEV, POPIS, POZADAVKY, ZPUSOBZAKONCENI) VALUES 
(PREDMET_id_SEQ.nextval, nazev_pa, popis_pa, pozadavky_pa, zpusobZakonceni_pa) RETURNING id INTO nove_id_predmet;

WHILE init_number <= 20 AND pocetakci < 4
    LOOP
        SELECT je_cas_validni(init_cas, datumakci_pa, delkaAkci_pa, ucebna_id_pa)
        INTO existuje_ra FROM dual;
    
        IF existuje_ra > 0 THEN 
            init_number := init_number + 1;
        ELSE
            INSERT INTO ROZVRHOVA_AKCE 
            (ID, CAS, DATUM, POCETHODIN, UCITEL_ID, KATEGORIE_ID, PREDMET_ID, POCETSTUDENTU) 
            VALUES (ROZVRHOVA_AKCE_id_SEQ.NEXTVAL, init_cas,
            datumakci_pa,delkaAkci_pa, ucitel_id_pa, kategorie_id_pa , nove_id_predmet, pocetStudentuRA) 
            RETURNING id INTO nove_id_ra;
            DBMS_OUTPUT.PUT_LINE('druhy insert' || nove_id_ra || ucebna_id_pa);
            INSERT INTO REL_RA_UCEBNA (ROZVRHOVA_AKCE_ID, UCEBNA_ID) VALUES (nove_id_ra, ucebna_id_pa);
            pocetakci := pocetakci + 1;
            init_number := init_number + 1;
        END IF;
        SELECT init_cas + (delkaAkci_pa + 0.1)/24 into init_cas from dual;
        IF init_cas >= TO_DATE('20:00:00',  'HH24:MI:SS') then
            RAISE NO_SPACE;
        END IF;
END LOOP;

IF init_number > 20 THEN
    RAISE NO_SPACE;
END IF;
COMMIT;
DBMS_OUTPUT.PUT_LINE('Procedura: procedura proběhla úspěšně!');
EXCEPTION 
 WHEN NO_SPACE THEN 
         ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Pro tři rozvrhove akce neni dostatek mista v ucebne');
        RAISE_APPLICATION_ERROR(-20001, 'Pro tři rozvrhove akce neni dostatek mista v ucebne');
END;

FUNCTION je_cas_validni(cas_param IN TIMESTAMP, datum_param IN DATE, 
delka_hodiny_param NUMBER, ucebna_id_param NUMBER)  
RETURN NUMBER 
IS 
    existujici_udalost number; 
BEGIN 
    SELECT COUNT(*) into existujici_udalost from rozvrhova_akce ra JOIN rel_ra_ucebna rel ON 
    ra.id = rel.rozvrhova_akce_id JOIN ucebna u ON rel.ucebna_id = u.id WHERE 
    u.id = ucebna_id_param and cas >= cas_param AND 
    cas <= cas_param + delka_hodiny_param/24 and datum = datum_param;
   IF existujici_udalost > 0 THEN 
      RETURN 1; 
   ELSE 
      RETURN 0;
   END IF;  
END;
END balicek_buss_logika; 
/