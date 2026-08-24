
/*
    Tabelle: Turnier
    Zweck:
    Speichert die allgemeinen Stammdaten eines Turniers.

    Ein Turnier kann mehrere Kategorien enthalten.
*/

CREATE TABLE dbo.Turnier
(
    TurnierID INT IDENTITY(1,1) NOT NULL,
    SaisonID INT NOT NULL,
    BewertungsperiodeID INT NOT NULL,
    Turniername NVARCHAR(150) NOT NULL,
    VeranstalterNr INT NOT NULL,
    SpielortID INT NOT NULL,
    Startdatum DATE NOT NULL,
    Enddatum DATE NULL,
    Meldeschluss DATETIME2(0) NOT NULL,
    HallenSchiedsrichterName NVARCHAR(150) NULL,
    Status VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Turnier
        PRIMARY KEY (TurnierID),

    CONSTRAINT FK_Turnier_Saison
        FOREIGN KEY (SaisonID)
        REFERENCES dbo.Saison(SaisonID),

    CONSTRAINT FK_Turnier_Bewertungsperiode
        FOREIGN KEY (BewertungsperiodeID)
        REFERENCES dbo.Bewertungsperiode(BewertungsperiodeID),

    CONSTRAINT FK_Turnier_Veranstalter
        FOREIGN KEY (VeranstalterNr)
        REFERENCES dbo.Club(VereinsNr),

    CONSTRAINT FK_Turnier_Spielort
        FOREIGN KEY (SpielortID)
        REFERENCES dbo.Spielort(SpielortID),

    CONSTRAINT CK_Turnier_Datum
        CHECK
        (
            Enddatum IS NULL
            OR Enddatum >= Startdatum
        ),

    CONSTRAINT CK_Turnier_Meldeschluss
        CHECK
        (
            Meldeschluss <= CAST(Startdatum AS DATETIME2(0))
        ),

    CONSTRAINT CK_Turnier_Status
        CHECK
        (
            Status IN
            (
                'GEPLANT',
                'OFFEN',
                'AUSGELOST',
                'LAUFEND',
                'BEENDET',
                'ABGESAGT'
            )
        )
);
GO
