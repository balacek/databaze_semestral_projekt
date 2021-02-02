-- přidání nového sloupce pocet_rozvrhovych_akci
ALTER TABLE UCITEL ADD pocet_rozvrhovych_akci NUMBER DEFAULT 0;

-- výpočet a update počtu rozvrhových akcí
BEGIN
  FOR record IN (SELECT id FROM UCITEL)
  LOOP
    UPDATE UCITEL SET pocet_rozvrhovych_akci = (SELECT COUNT(*) FROM ROZVRHOVA_AKCE ra
      JOIN UCITEL u ON (ra.ucitel_id = u.id)
      WHERE u.id = record.id)
    WHERE id = record.id;
  END LOOP;
END;
/

-- vytvoření triggerů
CREATE OR REPLACE TRIGGER trigger_pocet_akci_insert
AFTER INSERT
ON ROZVRHOVA_AKCE
FOR EACH ROW
BEGIN
  UPDATE UCITEL SET pocet_rozvrhovych_akci = ((SELECT pocet_rozvrhovych_akci FROM UCITEL WHERE id = :NEW.ucitel_id) + 1) WHERE id = :NEW.ucitel_id;
END;
/

CREATE OR REPLACE TRIGGER trigger_pocet_akci_delete
AFTER DELETE
ON ROZVRHOVA_AKCE
FOR EACH ROW
BEGIN
  UPDATE UCITEL SET pocet_rozvrhovych_akci = ((SELECT pocet_rozvrhovych_akci FROM UCITEL WHERE id = :OLD.ucitel_id) - 1) WHERE id = :OLD.ucitel_id;
END;
/

CREATE OR REPLACE TRIGGER trigger_pocet_akci_update
AFTER UPDATE
ON ROZVRHOVA_AKCE
FOR EACH ROW
BEGIN
  UPDATE UCITEL SET pocet_rozvrhovych_akci = ((SELECT pocet_rozvrhovych_akci FROM UCITEL WHERE id = :NEW.ucitel_id) + 1) WHERE id = :NEW.ucitel_id;
  UPDATE UCITEL SET pocet_rozvrhovych_akci = ((SELECT pocet_rozvrhovych_akci FROM UCITEL WHERE id = :OLD.ucitel_id) - 1) WHERE id = :OLD.ucitel_id;
END;
/
