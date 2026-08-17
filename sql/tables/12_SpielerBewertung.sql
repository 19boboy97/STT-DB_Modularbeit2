USE STT_DB;
GO

/*
    Tabelle: SpielerBewertung
    Zweck:
    Speichert die offiziellen halbjährlichen Bewertungswerte
    eines Spielers.

    Diese Werte werden insbesondere für Turnierzulassungen
    verwendet.
*/

CREATE TABLE dbo.SpielerBewertung
(
    SpielerBewertungID BIGINT IDENTITY(1,1) NOT NULL,
    LizenzNr INT NOT NULL,
    BewertungsperiodeID INT NOT NULL,
    Elo DECIMAL(10,3) NOT NULL,
    HerrenStufenwert TINYINT NOT NULL,
    DamenStufenwert TINYINT NULL,
    Alterskategorie VARCHAR(10) NOT NULL,
    ErstelltAm DATETIME2(0) NOT NULL
        CONSTRAINT DF_SpielerBewertung_ErstelltAm DEFAULT (SYSDATETIME()),

    CONSTRAINT PK_SpielerBewertung
        PRIMARY KEY (SpielerBewertungID),

    CONSTRAINT FK_SpielerBewertung_Spieler
        FOREIGN KEY (LizenzNr)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT FK_SpielerBewertung_Bewertungsperiode
        FOREIGN KEY (BewertungsperiodeID)
        REFERENCES dbo.Bewertungsperiode(BewertungsperiodeID),

    CONSTRAINT FK_SpielerBewertung_HerrenStufenwert
        FOREIGN KEY (HerrenStufenwert)
        REFERENCES dbo.Klassierungsstufe(Stufenwert),

    CONSTRAINT FK_SpielerBewertung_DamenStufenwert
        FOREIGN KEY (DamenStufenwert)
        REFERENCES dbo.Klassierungsstufe(Stufenwert),

    CONSTRAINT FK_SpielerBewertung_Alterskategorie
        FOREIGN KEY (Alterskategorie)
        REFERENCES dbo.Alterskategorie(Bezeichnung),

    CONSTRAINT UQ_SpielerBewertung_Spieler_Perioden
        UNIQUE (LizenzNr, BewertungsperiodeID),

    CONSTRAINT CK_SpielerBewertung_Elo
        CHECK (Elo >= 0)
);
GO