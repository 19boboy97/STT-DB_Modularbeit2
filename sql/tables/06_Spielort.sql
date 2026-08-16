USE STT_DB;
GO

/*
    Tabelle: Spielort
    Zweck:
    Speichert die Spiellokale eines Clubs.
*/

CREATE TABLE dbo.Spielort
(
    SpielortID INT IDENTITY(1,1) NOT NULL,
    VereinsNr INT NOT NULL,
    Bezeichnung NVARCHAR(100) NOT NULL,
    Gebaeude NVARCHAR(150) NULL,
    Strasse NVARCHAR(100) NOT NULL,
    Hausnummer NVARCHAR(10) NOT NULL,
    PLZ CHAR(4) NOT NULL,
    Ort NVARCHAR(100) NOT NULL,
    Landcode CHAR(2) NOT NULL
        CONSTRAINT DF_Spielort_Landcode DEFAULT ('CH'),
    IstHauptspielort BIT NOT NULL
        CONSTRAINT DF_Spielort_IstHauptspielort DEFAULT (0),
    Aktiv BIT NOT NULL
        CONSTRAINT DF_Spielort_Aktiv DEFAULT (1),

    CONSTRAINT PK_Spielort
        PRIMARY KEY (SpielortID),

    CONSTRAINT FK_Spielort_Club
        FOREIGN KEY (VereinsNr)
        REFERENCES dbo.Club(VereinsNr),

    CONSTRAINT UQ_Spielort_Verein_Bezeichnung
        UNIQUE (VereinsNr, Bezeichnung)
);
GO

/*
    Pro Club darf es maximal einen aktiven Hauptspielort geben.
*/
CREATE UNIQUE INDEX UX_Spielort_AktiverHauptspielort
ON dbo.Spielort (VereinsNr)
WHERE IstHauptspielort = 1
  AND Aktiv = 1;
GO