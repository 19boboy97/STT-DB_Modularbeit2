USE STT_DB;
GO

/*
    Tabelle: Klassierungsstufe
    Zweck:
    Speichert die möglichen Klassierungsstufen
    von D1 bis A22.
*/

CREATE TABLE dbo.Klassierungsstufe
(
    Stufenwert TINYINT NOT NULL,
    Bezeichnung VARCHAR(3) NOT NULL,

    CONSTRAINT PK_Klassierungsstufe
        PRIMARY KEY (Stufenwert),

    CONSTRAINT UQ_Klassierungsstufe_Bezeichnung
        UNIQUE (Bezeichnung),

    CONSTRAINT CK_Klassierungsstufe_Stufenwert
        CHECK (Stufenwert BETWEEN 1 AND 22)
);
GO