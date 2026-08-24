
/*
    Tabelle: Einzelspiel
    Zweck:
    Speichert ein einzelnes Spiel aus einer Ligabegegnung
    oder einer Turnierkategorie.

    Elo-relevant sind:
    - REGULAER
    - AUFGABE

    Nicht Elo-relevant sind:
    - FORFAIT
    - NICHTANGETRETEN
    - ANNULLIERT
*/

CREATE TABLE dbo.Einzelspiel
(
    EinzelspielID BIGINT IDENTITY(1,1) NOT NULL,

    BegegnungID BIGINT NULL,
    TurnierKategorieID INT NULL,

    Spielnummer TINYINT NULL,
    Spielcode VARCHAR(10) NULL,

    Spieler1Lizenz INT NULL,
    Spieler2Lizenz INT NULL,
    GewinnerLizenz INT NULL,

    Spieldatum DATETIME2(0) NOT NULL
        CONSTRAINT DF_Einzelspiel_Spieldatum
        DEFAULT (SYSDATETIME()),

    SaetzeSpieler1 TINYINT NOT NULL
        CONSTRAINT DF_Einzelspiel_SaetzeSpieler1 DEFAULT (0),

    SaetzeSpieler2 TINYINT NOT NULL
        CONSTRAINT DF_Einzelspiel_SaetzeSpieler2 DEFAULT (0),

    PunkteSpieler1 TINYINT NOT NULL
        CONSTRAINT DF_Einzelspiel_PunkteSpieler1 DEFAULT (0),

    PunkteSpieler2 TINYINT NOT NULL
        CONSTRAINT DF_Einzelspiel_PunkteSpieler2 DEFAULT (0),

    Spielgrund VARCHAR(20) NOT NULL,
    Status VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Einzelspiel
        PRIMARY KEY (EinzelspielID),

    CONSTRAINT FK_Einzelspiel_Begegnung
        FOREIGN KEY (BegegnungID)
        REFERENCES dbo.Begegnung(BegegnungID),

    CONSTRAINT FK_Einzelspiel_TurnierKategorie
        FOREIGN KEY (TurnierKategorieID)
        REFERENCES dbo.TurnierKategorie(TurnierKategorieID),

    CONSTRAINT FK_Einzelspiel_Spieler1
        FOREIGN KEY (Spieler1Lizenz)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT FK_Einzelspiel_Spieler2
        FOREIGN KEY (Spieler2Lizenz)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT FK_Einzelspiel_Gewinner
        FOREIGN KEY (GewinnerLizenz)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT CK_Einzelspiel_Herkunft
        CHECK
        (
            (BegegnungID IS NOT NULL AND TurnierKategorieID IS NULL)
            OR
            (BegegnungID IS NULL AND TurnierKategorieID IS NOT NULL)
        ),

    CONSTRAINT CK_Einzelspiel_VerschiedeneSpieler
        CHECK
        (
            Spieler1Lizenz IS NULL
            OR Spieler2Lizenz IS NULL
            OR Spieler1Lizenz <> Spieler2Lizenz
        ),

    CONSTRAINT CK_Einzelspiel_Saetze
        CHECK
        (
            SaetzeSpieler1 BETWEEN 0 AND 4
            AND SaetzeSpieler2 BETWEEN 0 AND 4
        ),

    CONSTRAINT CK_Einzelspiel_Punkte
        CHECK
        (
            PunkteSpieler1 IN (0,1)
            AND PunkteSpieler2 IN (0,1)
        ),

    CONSTRAINT CK_Einzelspiel_Spielgrund
        CHECK
        (
            Spielgrund IN
            (
                'REGULAER',
                'AUFGABE',
                'FORFAIT',
                'NICHTANGETRETEN',
                'ANNULLIERT'
            )
        ),

    CONSTRAINT CK_Einzelspiel_Status
        CHECK
        (
            Status IN
            (
                'GEPLANT',
                'LAUFEND',
                'ABGESCHLOSSEN',
                'ANNULLIERT'
            )
        ),

    CONSTRAINT CK_Einzelspiel_RegulaerSpieler
        CHECK
        (
            Spielgrund <> 'REGULAER'
            OR
            (
                Spieler1Lizenz IS NOT NULL
                AND Spieler2Lizenz IS NOT NULL
            )
        ),

    CONSTRAINT CK_Einzelspiel_Gewinner
        CHECK
        (
            GewinnerLizenz IS NULL
            OR GewinnerLizenz = Spieler1Lizenz
            OR GewinnerLizenz = Spieler2Lizenz
        )
);
GO
