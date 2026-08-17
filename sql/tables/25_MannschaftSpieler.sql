USE STT_DB;
GO

/*
    Tabelle: MannschaftSpieler
    Zweck:
    Speichert die Zuordnung eines Spielers
    zu einer Ligamannschaft.

    Es werden Stammspieler und Ersatzspieler unterschieden.
*/

CREATE TABLE dbo.MannschaftSpieler
(
    MannschaftSpielerID BIGINT IDENTITY(1,1) NOT NULL,
    MannschaftID INT NOT NULL,
    LizenzNr INT NOT NULL,
    Meldungsart VARCHAR(20) NOT NULL,
    StammPosition TINYINT NULL,
    Spielberechtigt BIT NOT NULL
        CONSTRAINT DF_MannschaftSpieler_Spielberechtigt DEFAULT (1),
    Bemerkung NVARCHAR(500) NULL,

    CONSTRAINT PK_MannschaftSpieler
        PRIMARY KEY (MannschaftSpielerID),

    CONSTRAINT FK_MannschaftSpieler_Mannschaft
        FOREIGN KEY (MannschaftID)
        REFERENCES dbo.Mannschaft(MannschaftID),

    CONSTRAINT FK_MannschaftSpieler_Spieler
        FOREIGN KEY (LizenzNr)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT UQ_MannschaftSpieler
        UNIQUE
        (
            MannschaftID,
            LizenzNr
        ),

    CONSTRAINT CK_MannschaftSpieler_Meldungsart
        CHECK
        (
            Meldungsart IN
            (
                'STAMMSPIELER',
                'ERSATZSPIELER'
            )
        ),

    CONSTRAINT CK_MannschaftSpieler_StammPosition
        CHECK
        (
            StammPosition IS NULL
            OR StammPosition BETWEEN 1 AND 3
        ),

    CONSTRAINT CK_MannschaftSpieler_MeldungPosition
        CHECK
        (
            (Meldungsart = 'STAMMSPIELER' AND StammPosition BETWEEN 1 AND 3)
            OR
            (Meldungsart = 'ERSATZSPIELER' AND StammPosition IS NULL)
        )
);
GO