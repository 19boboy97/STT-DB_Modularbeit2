USE STT_DB;
GO

/*
    Tabelle: Spieler
    Zweck:
    Speichert die langfristigen Stammdaten eines Spielers.

    Die Lizenznummer ist lebenslang eindeutig
    und dient als Primärschlüssel.
*/

CREATE TABLE dbo.Spieler
(
    LizenzNr INT NOT NULL,
    Vorname NVARCHAR(80) NOT NULL,
    Nachname NVARCHAR(80) NOT NULL,
    Geburtsdatum DATE NOT NULL,
    Geschlecht CHAR(1) NOT NULL,
    Aktiv BIT NOT NULL
        CONSTRAINT DF_Spieler_Aktiv DEFAULT (1),

    CONSTRAINT PK_Spieler
        PRIMARY KEY (LizenzNr),

    CONSTRAINT CK_Spieler_Geschlecht
        CHECK (Geschlecht IN ('M', 'W'))
);
GO