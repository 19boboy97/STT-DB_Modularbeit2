USE STT_DB;
GO

/*
    Tabelle: Saison
    Zweck:
    Speichert die einzelnen Spielsaisons.
*/

CREATE TABLE dbo.Saison
(
    SaisonID INT IDENTITY(1,1) NOT NULL,
    Bezeichnung NVARCHAR(20) NOT NULL,
    Startdatum DATE NOT NULL,
    Enddatum DATE NOT NULL,
    IstAktuell BIT NOT NULL
        CONSTRAINT DF_Saison_IstAktuell DEFAULT (0),

    CONSTRAINT PK_Saison
        PRIMARY KEY (SaisonID),

    CONSTRAINT UQ_Saison_Bezeichnung
        UNIQUE (Bezeichnung),

    CONSTRAINT CK_Saison_Datum
        CHECK (Enddatum > Startdatum)
);
GO

/*
    Es darf maximal eine aktuelle Saison geben.
*/
CREATE UNIQUE INDEX UX_Saison_IstAktuell
ON dbo.Saison (IstAktuell)
WHERE IstAktuell = 1;
GO