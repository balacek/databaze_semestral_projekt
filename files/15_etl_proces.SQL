CREATE TABLE dw_kategorie AS
SELECT
    id
    ,druh
    ,semestr
FROM kategorie;

ALTER TABLE dw_kategorie ADD CONSTRAINT kategorie_pk PRIMARY KEY ( id );

CREATE TABLE dw_predmet AS
SELECT
    id
    ,nazev
    ,popis
    ,pozadavky
    ,zpusobzakonceni
FROM predmet;

ALTER TABLE dw_predmet ADD CONSTRAINT predmet_pk PRIMARY KEY ( id );

CREATE TABLE dw_rozvrhova_akce AS
SELECT
    id
    ,cas
    ,datum
    ,pocethodin
    ,ucitel_id
    ,kategorie_id
    ,predmet_id 
    ,pocetstudentu
FROM rozvrhova_akce;

ALTER TABLE dw_rozvrhova_akce ADD CHECK ( pocethodin > 0 );

ALTER TABLE dw_rozvrhova_akce ADD CHECK ( pocetstudentu > 0 );

ALTER TABLE dw_rozvrhova_akce ADD CONSTRAINT rozvrhova_akce_pk PRIMARY KEY ( id );

CREATE TABLE dw_ucitel AS
SELECT
    id
    ,jmeno
    ,prijmeni
    ,telefon
    ,fakulta
    ,titulpred
    ,titulza
FROM ucitel;

ALTER TABLE dw_ucitel ADD CONSTRAINT ucitel_pk PRIMARY KEY ( id );

ALTER TABLE dw_rozvrhova_akce
    ADD CONSTRAINT rozvrhova_akce_kategorie_fk FOREIGN KEY ( kategorie_id )
        REFERENCES dw_kategorie ( id )
    NOT DEFERRABLE;

ALTER TABLE dw_rozvrhova_akce
    ADD CONSTRAINT rozvrhova_akce_predmet_fk FOREIGN KEY ( predmet_id )
        REFERENCES dw_predmet ( id )
    NOT DEFERRABLE;

ALTER TABLE dw_rozvrhova_akce
    ADD CONSTRAINT rozvrhova_akce_ucitel_fk FOREIGN KEY ( ucitel_id )
        REFERENCES dw_ucitel ( id )
    NOT DEFERRABLE;

CREATE TABLE dw_kategorie AS
SELECT
    id
    ,druh
    ,semestr
FROM kategorie;

ALTER TABLE dw_kategorie ADD CONSTRAINT kategorie_pk PRIMARY KEY ( id );

CREATE TABLE dw_predmet AS
SELECT
    id
    ,nazev
    ,popis
    ,pozadavky
    ,zpusobzakonceni
FROM predmet;

ALTER TABLE dw_predmet ADD CONSTRAINT predmet_pk PRIMARY KEY ( id );

CREATE TABLE dw_rozvrhova_akce AS
    id
    ,cas
    ,datum
    ,pocethodin
    ,ucitel_id
    ,kategorie_id
    ,predmet_id
    ,pocetstudentu
FROM rozvrhova_akce;

ALTER TABLE dw_rozvrhova_akce ADD CHECK ( pocethodin > 0 );

ALTER TABLE dw_rozvrhova_akce ADD CHECK ( pocetstudentu > 0 );

ALTER TABLE dw_rozvrhova_akce ADD CONSTRAINT rozvrhova_akce_pk PRIMARY KEY ( id );

CREATE TABLE dw_ucitel AS
SELECT
    id
    ,jmeno
    ,prijmeni
    ,telefon
    ,fakulta
    ,titulpred
    ,titulza
FROM ucitel;

ALTER TABLE dw_ucitel ADD CONSTRAINT ucitel_pk PRIMARY KEY ( id );

ALTER TABLE dw_rozvrhova_akce
    ADD CONSTRAINT rozvrhova_akce_kategorie_fk FOREIGN KEY ( kategorie_id )
        REFERENCES dw_kategorie ( id )
    NOT DEFERRABLE;

ALTER TABLE dw_rozvrhova_akce
    ADD CONSTRAINT rozvrhova_akce_predmet_fk FOREIGN KEY ( predmet_id )
        REFERENCES dw_predmet ( id )
    NOT DEFERRABLE;

ALTER TABLE dw_rozvrhova_akce
    ADD CONSTRAINT rozvrhova_akce_ucitel_fk FOREIGN KEY ( ucitel_id )
        REFERENCES dw_ucitel ( id )
    NOT DEFERRABLE;
