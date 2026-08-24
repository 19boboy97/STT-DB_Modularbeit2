
/*
    Tabelle: Satz
    Zweck:
    Speichert die tatsächlich gespielten Punkte
    eines einzelnen Satzes.

    Ein Satz gehört entweder zu:
    - einem Einzelspiel
    - oder einem Doppelspiel

    Genau eine dieser beiden Beziehungen muss gesetzt sein.
*/

CREATE TABLE dbo.Satz
(
    SatzID BIGINT IDENTITY(1,1) NOT NULL,

    EinzelspielID BIGINT NULL,
    DoppelspielID BIGINT NULL,

    SatzNummer TINYINT NOT NULL,

    PunkteSeite1 TINYINT NOT NULL,
    PunkteSeite2 TINYINT NOT NULL,

    CONSTRAINT PK_Satz
        PRIMARY KEY (SatzID),

    CONSTRAINT FK_Satz_Einzelspiel
        FOREIGN KEY (EinzelspielID)
        REFERENCES dbo.Einzelspiel(EinzelspielID),

    CONSTRAINT FK_Satz_Doppelspiel
        FOREIGN KEY (DoppelspielID)
        REFERENCES dbo.Doppelspiel(DoppelspielID),

    CONSTRAINT CK_Satz_Herkunft
        CHECK
        (
            (EinzelspielID IS NOT NULL AND DoppelspielID IS NULL)
            OR
            (EinzelspielID IS NULL AND DoppelspielID IS NOT NULL)
        ),

    CONSTRAINT CK_Satz_SatzNummer
        CHECK
        (
            SatzNummer BETWEEN 1 AND 7
        ),

    CONSTRAINT CK_Satz_Punkte
        CHECK
        (
            PunkteSeite1 >= 0
            AND PunkteSeite2 >= 0
            AND PunkteSeite1 <> PunkteSeite2
        )
);
GO

/*
    Eine Satznummer darf innerhalb eines Einzelspiels
    nur einmal vorkommen.
*/
CREATE UNIQUE INDEX UX_Satz_Einzelspiel_SatzNummer
ON dbo.Satz
(
    EinzelspielID,
    SatzNummer
)
WHERE EinzelspielID IS NOT NULL;
GO

/*
    Eine Satznummer darf innerhalb eines Doppelspiels
    nur einmal vorkommen.
*/
CREATE UNIQUE INDEX UX_Satz_Doppelspiel_SatzNummer
ON dbo.Satz
(
    DoppelspielID,
    SatzNummer
)
WHERE DoppelspielID IS NOT NULL;
GO
