USE STT_DB;
GO

/*
    Tabelle: Klassierungsgrenze
    Zweck:
    Ordnet Elo-Bereiche einer Klassierungsstufe zu.

    Die Grenzen gelten je Bewertungsperiode
    und je Klassierungsart (HERREN / DAMEN).
*/

CREATE TABLE dbo.Klassierungsgrenze
(
    KlassierungsgrenzeID INT IDENTITY(1,1) NOT NULL,
    BewertungsperiodeID INT NOT NULL,
    Stufenwert TINYINT NOT NULL,
    Klassierungsart VARCHAR(10) NOT NULL,
    MinElo DECIMAL(10,3) NULL,
    MittelElo DECIMAL(10,3) NULL,
    MaxElo DECIMAL(10,3) NULL,

    CONSTRAINT PK_Klassierungsgrenze
        PRIMARY KEY (KlassierungsgrenzeID),

    CONSTRAINT FK_Klassierungsgrenze_Bewertungsperiode
        FOREIGN KEY (BewertungsperiodeID)
        REFERENCES dbo.Bewertungsperiode(BewertungsperiodeID),

    CONSTRAINT FK_Klassierungsgrenze_Klassierungsstufe
        FOREIGN KEY (Stufenwert)
        REFERENCES dbo.Klassierungsstufe(Stufenwert),

    CONSTRAINT UQ_Klassierungsgrenze_PeriodenStufeArt
        UNIQUE
        (
            BewertungsperiodeID,
            Stufenwert,
            Klassierungsart
        ),

    CONSTRAINT CK_Klassierungsgrenze_Art
        CHECK
        (
            Klassierungsart IN ('HERREN', 'DAMEN')
        ),

    CONSTRAINT CK_Klassierungsgrenze_Bereich
        CHECK
        (
            (MinElo IS NULL OR MaxElo IS NULL OR MinElo <= MaxElo)
            AND
            (MittelElo IS NULL OR MinElo IS NULL OR MittelElo >= MinElo)
            AND
            (MittelElo IS NULL OR MaxElo IS NULL OR MittelElo <= MaxElo)
        )
);
GO