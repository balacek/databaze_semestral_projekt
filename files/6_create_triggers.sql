CREATE OR REPLACE TRIGGER KATEGORIE_id_TRG BEFORE
  INSERT ON KATEGORIE FOR EACH ROW WHEN (NEW.id IS NULL) BEGIN :NEW.id := KATEGORIE_id_SEQ.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER PREDMET_id_TRG BEFORE
  INSERT ON PREDMET FOR EACH ROW WHEN (NEW.id IS NULL) BEGIN :NEW.id := PREDMET_id_SEQ.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER ROZVRHOVA_AKCE_id_TRG BEFORE
  INSERT ON ROZVRHOVA_AKCE FOR EACH ROW WHEN (NEW.id IS NULL) BEGIN :NEW.id := ROZVRHOVA_AKCE_id_SEQ.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER UCEBNA_id_TRG BEFORE
  INSERT ON UCEBNA FOR EACH ROW WHEN (NEW.id IS NULL) BEGIN :NEW.id := UCEBNA_id_SEQ.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER UCITEL_id_TRG BEFORE
  INSERT ON UCITEL FOR EACH ROW WHEN (NEW.id IS NULL) BEGIN :NEW.id := UCITEL_id_SEQ.NEXTVAL;
END;
/

ALTER TABLE KATEGORIE ADD CHECK (semestr = 'Zimní' OR semestr = 'Letní');

ALTER TABLE PREDMET ADD CHECK (zpusobzakonceni = 'Zkouška' OR zpusobzakonceni = 'Zápočet');

ALTER TABLE ROZVRHOVA_AKCE ADD CHECK (CAST(cas as time) >= '07:00:00' AND CAST(cas as time) <= '20:00:00');

CREATE OR REPLACE TRIGGER trigger_kapacita_check
BEFORE INSERT OR UPDATE
   ON REL_RA_UCEBNA  FOR EACH ROW
DECLARE
  pocet rozvrhova_akce.pocetstudentu%TYPE;
  maximum ucebna.kapacita%TYPE;
  TOO_MANY_STUDENTS EXCEPTION;
  AKCE_EXISTS NUMBER;
  UCEBNA_EXISTS NUMBER;
BEGIN
   SELECT COUNT(*) INTO AKCE_EXISTS FROM ROZVRHOVA_AKCE WHERE rozvrhova_akce.id = :new.rozvrhova_akce_id;
   SELECT COUNT(*) INTO UCEBNA_EXISTS FROM ucebna WHERE ucebna.id = :new.ucebna_id; 
	IF AKCE_EXISTS + UCEBNA_EXISTS > 1 THEN
		SELECT pocetstudentu INTO pocet FROM rozvrhova_akce WHERE rozvrhova_akce.id = :new.rozvrhova_akce_id;
  
		SELECT kapacita INTO maximum FROM ucebna WHERE ucebna.id = :new.ucebna_id;
  
		IF pocet > maximum THEN 
			RAISE TOO_MANY_STUDENTS;
		END IF;
	END IF;
EXCEPTION
    WHEN TOO_MANY_STUDENTS THEN 
        dbms_output.put_line('Počet studentů je větší, než kapacita učebny');
        RAISE_APPLICATION_ERROR(-20001, 'Počet studentů je větší, než kapacita učebny');
END;
/

CREATE OR REPLACE TRIGGER trigger_datum_akce_check
  BEFORE INSERT OR UPDATE ON ROZVRHOVA_AKCE
  FOR EACH ROW
BEGIN
  IF( :new.datum < SYSDATE )
  THEN
    RAISE_APPLICATION_ERROR(-20001,'Neplatný datum rozvrhové akce, datum musí být v budoucnosti!');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trigger_check_teacher
BEFORE INSERT OR UPDATE
   ON rozvrhova_akce  FOR EACH ROW
DECLARE
  stejne_hodiny NUMBER;
  TEACHER_NO_TIME EXCEPTION;
  cursor list_delek is 
    (select pocethodin, cas, datum from rozvrhova_akce where datum = :new.datum AND ucitel_id = :new.ucitel_id);
BEGIN
    FOR existing_ra IN list_delek  LOOP
		SELECT COUNT(*) into stejne_hodiny FROM rozvrhova_akce WHERE (ucitel_id = :new.ucitel_id AND 
			cas <= :new.cas AND
			(cas + existing_ra.pocethodin/24) >= :new.cas and datum = :new.datum)
			OR (cas <= (:new.cas + :new.pocethodin/24) AND :new.cas <= cas AND 
			ucitel_id = :new.ucitel_id and datum = :new.datum);

  IF stejne_hodiny > 0 THEN 
        RAISE TEACHER_NO_TIME;
  END IF;
  END LOOP existing_ra;
EXCEPTION
    WHEN TEACHER_NO_TIME THEN 
        dbms_output.put_line('Zadaná rovzvrhová akce kryje učitelovu výuku, prosím zvolte jiný datum nebo čas.');
        RAISE_APPLICATION_ERROR(-20001, 'Zadaná rovzvrhová akce kryje učitelovu výuku, prosím zvolte jiný datum nebo čas.');
END;
/

CREATE OR REPLACE TRIGGER trigger_check_ucebna_available
BEFORE INSERT OR UPDATE
   ON REL_RA_UCEBNA  FOR EACH ROW  
DECLARE
inserted_ra_date DATE;
inserted_ra_time TIMESTAMP;
inserted_ra_pocethodin NUMBER;
RA_IN_UCEBNA_EXISTS EXCEPTION;
cursor list is (SELECT datum, cas, pocethodin FROM 
       rozvrhova_akce akce JOIN rel_ra_ucebna 
    rel ON akce.id = rel.rozvrhova_akce_id  WHERE ucebna_id = :new.ucebna_id);
BEGIN
FOR existing_ IN list LOOP
 SELECT datum, cas, pocethodin INTO inserted_ra_date, inserted_ra_time, inserted_ra_pocethodin
            FROM rozvrhova_akce WHERE ID = :new.rozvrhova_akce_id;

		IF existing_.datum = inserted_ra_date THEN
			IF existing_.cas <= inserted_ra_time AND
    (existing_.cas + existing_.pocethodin/24) >= inserted_ra_time OR
    existing_.cas >= (inserted_ra_time + inserted_ra_pocethodin/24) AND
	inserted_ra_time <= existing_.cas THEN
				RAISE RA_IN_UCEBNA_EXISTS;
			END IF;
		END IF;
END LOOP;
EXCEPTION
    WHEN RA_IN_UCEBNA_EXISTS THEN 
        dbms_output.put_line('V učebně je již naplánovaná výuka v této době.');
        RAISE_APPLICATION_ERROR(-20001, 'V učebně je již naplánovaná výuka v této době.');
END;
/