USE STT_DB;
GO

/*
    Tabelle: SpielerSaison
    Zweck:
    Speichert saisonabhängige Eigenschaften eines Spielers.

    Dazu gehören insbesondere:
    - aktive Lizenz in der Saison
    - feste Alterskategorie für die ganze Saison
*/

CREATE TABLE dbo.SpielerSaison
(
    LizenzNr INT NOT NULL,
    SaisonID INT NOT NULL,
    Alterskategorie VARCHAR(10) NOT NULL,
    LizenzAktiv BIT NOT NULL
        CONSTRAINT DF_SpielerSaison_LizenzAktiv DEFAULT (1),

    CONSTRAINT PK_SpielerSaison
        PRIMARY KEY (LizenzNr, SaisonID),

    CONSTRAINT FK_SpielerSaison_Spieler
        FOREIGN KEY (LizenzNr)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT FK_SpielerSaison_Saison
        FOREIGN KEY (SaisonID)
        REFERENCES dbo.Saison(SaisonID),

    CONSTRAINT FK_SpielerSaison_Alterskategorie
        FOREIGN KEY (Alterskategorie)
        REFERENCES dbo.Alterskategorie(Bezeichnung)
);
GO