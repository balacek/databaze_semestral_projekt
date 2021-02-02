CREATE SEQUENCE kategorie_id_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE predmet_id_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE rozvrhova_akce_id_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE ucebna_id_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE ucitel_id_seq START WITH 1 NOCACHE ORDER;

CREATE TABLE kategorie (
    id       NUMBER NOT NULL,
    druh     VARCHAR2(50) NOT NULL,
    semestr  VARCHAR2(50) NOT NULL
)
LOGGING;

ALTER TABLE kategorie ADD CONSTRAINT kategorie_pk PRIMARY KEY ( id );

CREATE TABLE predmet (
    id               NUMBER NOT NULL,
    nazev            VARCHAR2(100) NOT NULL,
    popis            VARCHAR2(255),
    pozadavky        VARCHAR2(255) NOT NULL,
    zpusobzakonceni  VARCHAR2(40) NOT NULL
)
LOGGING;

ALTER TABLE predmet ADD CONSTRAINT predmet_pk PRIMARY KEY ( id );

CREATE TABLE rozvrhova_akce (
    id             NUMBER NOT NULL,
    cas            TIMESTAMP NOT NULL,
    datum          DATE NOT NULL,
    pocethodin     NUMBER NOT NULL,
    ucitel_id      NUMBER NOT NULL,
    kategorie_id   NUMBER NOT NULL,
    predmet_id     NUMBER NOT NULL,
    pocetstudentu  NUMBER NOT NULL
)
LOGGING;

ALTER TABLE rozvrhova_akce ADD CHECK ( pocethodin > 0 );

ALTER TABLE rozvrhova_akce ADD CHECK ( pocetstudentu > 0 );

ALTER TABLE rozvrhova_akce ADD CONSTRAINT rozvrhova_akce_pk PRIMARY KEY ( id );

CREATE TABLE ucitel (
    id         NUMBER NOT NULL,
    jmeno      VARCHAR2(100) NOT NULL,
    prijmeni   VARCHAR2(100) NOT NULL,
    telefon    NUMBER NOT NULL,
    fakulta    VARCHAR2(255) NOT NULL,
    titulpred  CHAR(15),
    titulza    CHAR(15)
)
LOGGING;

ALTER TABLE ucitel ADD CONSTRAINT ucitel_pk PRIMARY KEY ( id );

ALTER TABLE rozvrhova_akce
    ADD CONSTRAINT rozvrhova_akce_kategorie_fk FOREIGN KEY ( kategorie_id )
        REFERENCES kategorie ( id )
    NOT DEFERRABLE;

ALTER TABLE rozvrhova_akce
    ADD CONSTRAINT rozvrhova_akce_predmet_fk FOREIGN KEY ( predmet_id )
        REFERENCES predmet ( id )
    NOT DEFERRABLE;

ALTER TABLE rozvrhova_akce
    ADD CONSTRAINT rozvrhova_akce_ucitel_fk FOREIGN KEY ( ucitel_id )
        REFERENCES ucitel ( id )
    NOT DEFERRABLE;
