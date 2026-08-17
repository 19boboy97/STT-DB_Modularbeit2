USE STT_DB;
GO

/*
    Tabelle: Vereinsfunktionaer
    Zweck:
    Speichert Kontaktpersonen eines Clubs.

    Ein Vereinsfunktionär muss kein lizenzierter Spieler sein.
*/

CREATE TABLE dbo.Vereinsfunktionaer
(
    FunktionaerID INT IDENTITY(1,1) NOT NULL,
    VereinsNr INT NOT NULL,
    Vorname NVARCHAR(80) NOT NULL,
    Nachname NVARCHAR(80) NOT NULL,
    Email NVARCHAR(255) NULL,
    TelefonPrivat NVARCHAR(30) NULL,
    TelefonMobil NVARCHAR(30) NULL,
    Strasse NVARCHAR(100) NULL,
    Hausnummer NVARCHAR(10) NULL,
    PLZ CHAR(4) NULL,
    Ort NVARCHAR(100) NULL,
    Aktiv BIT NOT NULL
        CONSTRAINT DF_Vereinsfunktionaer_Aktiv DEFAULT (1),

    CONSTRAINT PK_Vereinsfunktionaer
        PRIMARY KEY (FunktionaerID),

    CONSTRAINT FK_Vereinsfunktionaer_Club
        FOREIGN KEY (VereinsNr)
        REFERENCES dbo.Club(VereinsNr)
);
GO