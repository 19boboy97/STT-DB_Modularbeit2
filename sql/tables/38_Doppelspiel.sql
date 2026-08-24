
/*
    Tabelle: Doppelspiel
    Zweck:
    Speichert ein Doppelspiel aus einer Ligabegegnung
    oder einer Turnierkategorie.

    Doppelspiele sind nicht Elo-relevant.
*/

CREATE TABLE dbo.Doppelspiel
(
    DoppelspielID BIGINT IDENTITY(1,1) NOT NULL,

    BegegnungID BIGINT NULL,
    TurnierKategorieID INT NULL,

    Spielnummer TINYINT NULL,
    Spielcode VARCHAR(10) NULL,

    Seite1Spieler1Lizenz INT NULL,
    Seite1Spieler2Lizenz INT NULL,
    Seite2Spieler1Lizenz INT NULL,
    Seite2Spieler2Lizenz INT NULL,

    Gewinnerseite TINYINT NULL,

    Spieldatum DATETIME2(0) NOT NULL
        CONSTRAINT DF_Doppelspiel_Spieldatum
        DEFAULT (SYSDATETIME()),

    SaetzeSeite1 TINYINT NOT NULL
        CONSTRAINT DF_Doppelspiel_SaetzeSeite1 DEFAULT (0),

    SaetzeSeite2 TINYINT NOT NULL
        CONSTRAINT DF_Doppelspiel_SaetzeSeite2 DEFAULT (0),

    PunkteSeite1 TINYINT NOT NULL
        CONSTRAINT DF_Doppelspiel_PunkteSeite1 DEFAULT (0),

    PunkteSeite2 TINYINT NOT NULL
        CONSTRAINT DF_Doppelspiel_PunkteSeite2 DEFAULT (0),

    Spielgrund VARCHAR(20) NOT NULL,
    Status VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Doppelspiel
        PRIMARY KEY (DoppelspielID),

    CONSTRAINT FK_Doppelspiel_Begegnung
        FOREIGN KEY (BegegnungID)
        REFERENCES dbo.Begegnung(BegegnungID),

    CONSTRAINT FK_Doppelspiel_TurnierKategorie
        FOREIGN KEY (TurnierKategorieID)
        REFERENCES dbo.TurnierKategorie(TurnierKategorieID),

    CONSTRAINT FK_Doppelspiel_Seite1Spieler1
        FOREIGN KEY (Seite1Spieler1Lizenz)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT FK_Doppelspiel_Seite1Spieler2
        FOREIGN KEY (Seite1Spieler2Lizenz)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT FK_Doppelspiel_Seite2Spieler1
        FOREIGN KEY (Seite2Spieler1Lizenz)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT FK_Doppelspiel_Seite2Spieler2
        FOREIGN KEY (Seite2Spieler2Lizenz)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT CK_Doppelspiel_Herkunft
        CHECK
        (
            (BegegnungID IS NOT NULL AND TurnierKategorieID IS NULL)
            OR
            (BegegnungID IS NULL AND TurnierKategorieID IS NOT NULL)
        ),

    CONSTRAINT CK_Doppelspiel_Gewinnerseite
        CHECK
        (
            Gewinnerseite IS NULL
            OR Gewinnerseite IN (1,2)
        ),

    CONSTRAINT CK_Doppelspiel_Saetze
        CHECK
        (
            SaetzeSeite1 BETWEEN 0 AND 4
            AND SaetzeSeite2 BETWEEN 0 AND 4
        ),

    CONSTRAINT CK_Doppelspiel_Punkte
        CHECK
        (
            PunkteSeite1 IN (0,1)
            AND PunkteSeite2 IN (0,1)
        ),

    CONSTRAINT CK_Doppelspiel_Spielgrund
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

    CONSTRAINT CK_Doppelspiel_Status
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

    CONSTRAINT CK_Doppelspiel_RegulaerSpieler
        CHECK
        (
            Spielgrund <> 'REGULAER'
            OR
            (
                Seite1Spieler1Lizenz IS NOT NULL
                AND Seite1Spieler2Lizenz IS NOT NULL
                AND Seite2Spieler1Lizenz IS NOT NULL
                AND Seite2Spieler2Lizenz IS NOT NULL
            )
        ),

    CONSTRAINT CK_Doppelspiel_VerschiedeneSpieler
        CHECK
        (
            Spielgrund <> 'REGULAER'
            OR
            (
                Seite1Spieler1Lizenz <> Seite1Spieler2Lizenz
                AND Seite1Spieler1Lizenz <> Seite2Spieler1Lizenz
                AND Seite1Spieler1Lizenz <> Seite2Spieler2Lizenz
                AND Seite1Spieler2Lizenz <> Seite2Spieler1Lizenz
                AND Seite1Spieler2Lizenz <> Seite2Spieler2Lizenz
                AND Seite2Spieler1Lizenz <> Seite2Spieler2Lizenz
            )
        )
);
GO
