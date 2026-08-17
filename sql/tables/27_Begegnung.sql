USE STT_DB;
GO

/*
    Tabelle: Begegnung
    Zweck:
    Speichert eine vollständige Mannschaftsbegegnung
    innerhalb einer Ligaphase.
*/

CREATE TABLE dbo.Begegnung
(
    BegegnungID BIGINT IDENTITY(1,1) NOT NULL,
    LigaphaseID INT NOT NULL,
    HeimMannschaftID INT NOT NULL,
    GastMannschaftID INT NOT NULL,
    SpielortID INT NOT NULL,

    Runde TINYINT NULL,
    Datum DATE NOT NULL,
    Startzeit TIME(0) NOT NULL,
    Endzeit TIME(0) NULL,

    SiegeHeim TINYINT NULL,
    SiegeGast TINYINT NULL,

    MannschaftspunkteHeim TINYINT NULL,
    MannschaftspunkteGast TINYINT NULL,

    SaetzeHeim SMALLINT NULL,
    SaetzeGast SMALLINT NULL,

    BaelleHeim SMALLINT NULL,
    BaelleGast SMALLINT NULL,

    ZuschauerAnzahl SMALLINT NULL,
    SchiedsrichterName NVARCHAR(150) NULL,

    MatchblattGenehmigt BIT NOT NULL
        CONSTRAINT DF_Begegnung_MatchblattGenehmigt DEFAULT (0),

    GenehmigtAm DATETIME2(0) NULL,
    GenehmigtVon INT NULL,

    Status VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Begegnung
        PRIMARY KEY (BegegnungID),

    CONSTRAINT FK_Begegnung_Ligaphase
        FOREIGN KEY (LigaphaseID)
        REFERENCES dbo.Ligaphase(LigaphaseID),

    CONSTRAINT FK_Begegnung_HeimMannschaft
        FOREIGN KEY (HeimMannschaftID)
        REFERENCES dbo.Mannschaft(MannschaftID),

    CONSTRAINT FK_Begegnung_GastMannschaft
        FOREIGN KEY (GastMannschaftID)
        REFERENCES dbo.Mannschaft(MannschaftID),

    CONSTRAINT FK_Begegnung_Spielort
        FOREIGN KEY (SpielortID)
        REFERENCES dbo.Spielort(SpielortID),

    CONSTRAINT FK_Begegnung_GenehmigtVon
        FOREIGN KEY (GenehmigtVon)
        REFERENCES dbo.Benutzer(BenutzerID),

    CONSTRAINT CK_Begegnung_Mannschaften
        CHECK (HeimMannschaftID <> GastMannschaftID),

    CONSTRAINT CK_Begegnung_Runde
        CHECK (Runde IS NULL OR Runde > 0),

    CONSTRAINT CK_Begegnung_Zeit
        CHECK (Endzeit IS NULL OR Endzeit >= Startzeit),

    CONSTRAINT CK_Begegnung_SiegeHeim
        CHECK (SiegeHeim IS NULL OR SiegeHeim BETWEEN 0 AND 10),

    CONSTRAINT CK_Begegnung_SiegeGast
        CHECK (SiegeGast IS NULL OR SiegeGast BETWEEN 0 AND 10),

    CONSTRAINT CK_Begegnung_MannschaftspunkteHeim
        CHECK
        (
            MannschaftspunkteHeim IS NULL
            OR MannschaftspunkteHeim BETWEEN 0 AND 4
        ),

    CONSTRAINT CK_Begegnung_MannschaftspunkteGast
        CHECK
        (
            MannschaftspunkteGast IS NULL
            OR MannschaftspunkteGast BETWEEN 0 AND 4
        ),

    CONSTRAINT CK_Begegnung_SaetzeHeim
        CHECK (SaetzeHeim IS NULL OR SaetzeHeim >= 0),

    CONSTRAINT CK_Begegnung_SaetzeGast
        CHECK (SaetzeGast IS NULL OR SaetzeGast >= 0),

    CONSTRAINT CK_Begegnung_BaelleHeim
        CHECK (BaelleHeim IS NULL OR BaelleHeim >= 0),

    CONSTRAINT CK_Begegnung_BaelleGast
        CHECK (BaelleGast IS NULL OR BaelleGast >= 0),

    CONSTRAINT CK_Begegnung_Zuschauer
        CHECK (ZuschauerAnzahl IS NULL OR ZuschauerAnzahl >= 0),

    CONSTRAINT CK_Begegnung_Status
        CHECK
        (
            Status IN
            (
                'GEPLANT',
                'LAUFEND',
                'ABGESCHLOSSEN',
                'GENEHMIGT',
                'ANNULLIERT'
            )
        ),

    CONSTRAINT CK_Begegnung_Genehmigung
        CHECK
        (
            (
                Status = 'GENEHMIGT'
                AND MatchblattGenehmigt = 1
                AND GenehmigtAm IS NOT NULL
                AND GenehmigtVon IS NOT NULL
            )
            OR
            (
                Status <> 'GENEHMIGT'
                AND
                (
                    MatchblattGenehmigt = 0
                    OR
                    (
                        MatchblattGenehmigt = 1
                        AND GenehmigtAm IS NOT NULL
                        AND GenehmigtVon IS NOT NULL
                    )
                )
            )
        )
);
GO