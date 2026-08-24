
/*
    Tabelle: Einzelanmeldung
    Zweck:
    Speichert die Anmeldung eines einzelnen Spielers
    zu einer Einzelkategorie eines Turniers.

    Elo, Klassierung und Alterskategorie werden nicht
    redundant gespeichert. Die Zulassung wird über
    SpielerBewertung geprüft.
*/

CREATE TABLE dbo.Einzelanmeldung
(
    EinzelanmeldungID BIGINT IDENTITY(1,1) NOT NULL,
    TurnierKategorieID INT NOT NULL,
    LizenzNr INT NOT NULL,

    Anmeldedatum DATETIME2(0) NOT NULL
        CONSTRAINT DF_Einzelanmeldung_Anmeldedatum
        DEFAULT (SYSDATETIME()),

    Status VARCHAR(20) NOT NULL
        CONSTRAINT DF_Einzelanmeldung_Status
        DEFAULT ('ANGEMELDET'),

    Ablehnungsgrund NVARCHAR(500) NULL,

    CONSTRAINT PK_Einzelanmeldung
        PRIMARY KEY (EinzelanmeldungID),

    CONSTRAINT FK_Einzelanmeldung_TurnierKategorie
        FOREIGN KEY (TurnierKategorieID)
        REFERENCES dbo.TurnierKategorie(TurnierKategorieID),

    CONSTRAINT FK_Einzelanmeldung_Spieler
        FOREIGN KEY (LizenzNr)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT UQ_Einzelanmeldung_Kategorie_Spieler
        UNIQUE
        (
            TurnierKategorieID,
            LizenzNr
        ),

    CONSTRAINT CK_Einzelanmeldung_Status
        CHECK
        (
            Status IN
            (
                'ANGEMELDET',
                'BESTAETIGT',
                'ABGELEHNT',
                'ZURUECKGEZOGEN'
            )
        )
);
GO
