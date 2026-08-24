
/*
    Tabelle: EloProtokoll
    Zweck:
    Protokolliert die Elo-Berechnung eines Spielers
    für ein einzelnes Elo-relevantes Einzelspiel.

    Für jedes Einzelspiel entstehen normalerweise
    zwei Protokolleinträge:
    - einer für Spieler 1
    - einer für Spieler 2

    Doppelspiele sind nicht Elo-relevant.
*/

CREATE TABLE dbo.EloProtokoll
(
    EloProtokollID BIGINT IDENTITY(1,1) NOT NULL,

    EinzelspielID BIGINT NOT NULL,
    LizenzNr INT NOT NULL,
    GegnerLizenzNr INT NOT NULL,
    EloMonatslaufID BIGINT NOT NULL,

    StichtagsElo DECIMAL(10,3) NOT NULL,
    GegnerStichtagsElo DECIMAL(10,3) NOT NULL,

    Gewinnwahrscheinlichkeit DECIMAL(6,5) NOT NULL,

    VorschauElo DECIMAL(10,3) NOT NULL,

    ErstelltAm DATETIME2(0) NOT NULL
        CONSTRAINT DF_EloProtokoll_ErstelltAm
        DEFAULT (SYSDATETIME()),

    CONSTRAINT PK_EloProtokoll
        PRIMARY KEY (EloProtokollID),

    CONSTRAINT FK_EloProtokoll_Einzelspiel
        FOREIGN KEY (EinzelspielID)
        REFERENCES dbo.Einzelspiel(EinzelspielID),

    CONSTRAINT FK_EloProtokoll_Spieler
        FOREIGN KEY (LizenzNr)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT FK_EloProtokoll_Gegner
        FOREIGN KEY (GegnerLizenzNr)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT FK_EloProtokoll_Monatslauf
        FOREIGN KEY (EloMonatslaufID)
        REFERENCES dbo.EloMonatslauf(EloMonatslaufID),

    CONSTRAINT UQ_EloProtokoll_Einzelspiel_Spieler
        UNIQUE
        (
            EinzelspielID,
            LizenzNr
        ),

    CONSTRAINT CK_EloProtokoll_VerschiedeneSpieler
        CHECK
        (
            LizenzNr <> GegnerLizenzNr
        ),

    CONSTRAINT CK_EloProtokoll_StichtagsElo
        CHECK
        (
            StichtagsElo >= 0
        ),

    CONSTRAINT CK_EloProtokoll_GegnerStichtagsElo
        CHECK
        (
            GegnerStichtagsElo >= 0
        ),

    CONSTRAINT CK_EloProtokoll_Gewinnwahrscheinlichkeit
        CHECK
        (
            Gewinnwahrscheinlichkeit BETWEEN 0 AND 1
        ),

    CONSTRAINT CK_EloProtokoll_VorschauElo
        CHECK
        (
            VorschauElo >= 0
        )
);
GO
