CREATE SEQUENCE dw_kategorie_id_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE dw_predmet_id_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE dw_rozvrhova_akce_id_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE dw_ucebna_id_seq START WITH 1 NOCACHE ORDER;

CREATE SEQUENCE dw_ucitel_id_seq START WITH 1 NOCACHE ORDER;

CREATE TABLE dw_kategorie
    id       NUMBER NOT NULL,
    druh     VARCHAR2(50) NOT NULL,
    semestr  VARCHAR2(50) NOT NULL
)
LOGGING;

ALTER TABLE dw_kategorie ADD CONSTRAINT kategorie_pk PRIMARY KEY ( id );

CREATE TABLE dw_predmet (
    id               NUMBER NOT NULL,
    nazev            VARCHAR2(100) NOT NULL,
    popis            VARCHAR2(255),
    pozadavky        VARCHAR2(255) NOT NULL,
    zpusobzakonceni  VARCHAR2(40) NOT NULL
)
LOGGING;

ALTER TABLE dw_predmet ADD CONSTRAINT predmet_pk PRIMARY KEY ( id );

CREATE TABLE dw_rozvrhova_akce (
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

ALTER TABLE dw_rozvrhova_akce ADD CHECK ( pocethodin > 0 );

ALTER TABLE dw_rozvrhova_akce ADD CHECK ( pocetstudentu > 0 );

ALTER TABLE dw_rozvrhova_akce ADD CONSTRAINT rozvrhova_akce_pk PRIMARY KEY ( id );

CREATE TABLE dw_ucitel (
    id         NUMBER NOT NULL,
    jmeno      VARCHAR2(100) NOT NULL,
    prijmeni   VARCHAR2(100) NOT NULL,
    telefon    NUMBER NOT NULL,
    fakulta    VARCHAR2(255) NOT NULL,
    titulpred  CHAR(15),
    titulza    CHAR(15)
)
LOGGING;

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

CREATE TABLE dw_kategorie (
    id       NUMBER NOT NULL,
    druh     VARCHAR2(50) NOT NULL,
    semestr  VARCHAR2(50) NOT NULL
)
LOGGING;

ALTER TABLE dw_kategorie ADD CONSTRAINT kategorie_pk PRIMARY KEY ( id );

CREATE TABLE dw_predmet (
    id               NUMBER NOT NULL,
    nazev            VARCHAR2(100) NOT NULL,
    popis            VARCHAR2(255),
    pozadavky        VARCHAR2(255) NOT NULL,
    zpusobzakonceni  VARCHAR2(40) NOT NULL
)
LOGGING;

ALTER TABLE dw_predmet ADD CONSTRAINT predmet_pk PRIMARY KEY ( id );

CREATE TABLE dw_rozvrhova_akce (
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

ALTER TABLE dw_rozvrhova_akce ADD CHECK ( pocethodin > 0 );

ALTER TABLE dw_rozvrhova_akce ADD CHECK ( pocetstudentu > 0 );

ALTER TABLE dw_rozvrhova_akce ADD CONSTRAINT rozvrhova_akce_pk PRIMARY KEY ( id );

CREATE TABLE dw_ucitel (
    id         NUMBER NOT NULL,
    jmeno      VARCHAR2(100) NOT NULL,
    prijmeni   VARCHAR2(100) NOT NULL,
    telefon    NUMBER NOT NULL,
    fakulta    VARCHAR2(255) NOT NULL,
    titulpred  CHAR(15),
    titulza    CHAR(15)
)
LOGGING;

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
