USE STT_DB;
GO

/*
    Tabelle: Bewertungsperiode
    Zweck:
    Speichert die beiden offiziellen Bewertungsstände
    innerhalb einer Saison.

    Diese werden insbesondere für Turnierzulassungen
    und Klassierungsgrenzen verwendet.
*/

CREATE TABLE dbo.Bewertungsperiode
(
    BewertungsperiodeID INT IDENTITY(1,1) NOT NULL,
    SaisonID INT NOT NULL,
    Bezeichnung VARCHAR(20) NOT NULL,
    Stichtag DATE NOT NULL,
    GueltigAb DATE NOT NULL,
    GueltigBis DATE NOT NULL,

    CONSTRAINT PK_Bewertungsperiode
        PRIMARY KEY (BewertungsperiodeID),

    CONSTRAINT FK_Bewertungsperiode_Saison
        FOREIGN KEY (SaisonID)
        REFERENCES dbo.Saison(SaisonID),

    CONSTRAINT UQ_Bewertungsperiode_Saison_Bezeichnung
        UNIQUE (SaisonID, Bezeichnung),

    CONSTRAINT CK_Bewertungsperiode_Bezeichnung
        CHECK
        (
            Bezeichnung IN
            (
                'SAISONBEGINN',
                'SAISONMITTE'
            )
        ),

    CONSTRAINT CK_Bewertungsperiode_Datum
        CHECK
        (
            GueltigBis >= GueltigAb
            AND Stichtag BETWEEN GueltigAb AND GueltigBis
        )
);
GO