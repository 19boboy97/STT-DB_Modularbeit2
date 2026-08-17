USE STT_DB;
GO

/*
    Tabelle: Funktion
    Zweck:
    Speichert mögliche Funktionen innerhalb eines Clubs.
*/

CREATE TABLE dbo.Funktion
(
    FunktionID INT IDENTITY(1,1) NOT NULL,
    Bezeichnung NVARCHAR(100) NOT NULL,
    Aktiv BIT NOT NULL
        CONSTRAINT DF_Funktion_Aktiv DEFAULT (1),

    CONSTRAINT PK_Funktion
        PRIMARY KEY (FunktionID),

    CONSTRAINT UQ_Funktion_Bezeichnung
        UNIQUE (Bezeichnung)
);
GO