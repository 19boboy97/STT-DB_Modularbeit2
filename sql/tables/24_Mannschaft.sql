USE STT_DB;
GO

/*
    Tabelle: Mannschaft
    Zweck:
    Speichert eine Ligamannschaft eines Clubs.

    Der sichtbare Mannschaftsname wird später
    aus Club-Kurzname und MannschaftNummer gebildet.
*/

CREATE TABLE dbo.Mannschaft
(
    MannschaftID INT IDENTITY(1,1) NOT NULL,
    VereinsNr INT NOT NULL,
    LigaphaseID INT NOT NULL,
    MannschaftNummer TINYINT NOT NULL,
    KapitaenLizenz INT NOT NULL,
    BallID INT NULL,
    Aktiv BIT NOT NULL
        CONSTRAINT DF_Mannschaft_Aktiv DEFAULT (1),

    CONSTRAINT PK_Mannschaft
        PRIMARY KEY (MannschaftID),

    CONSTRAINT FK_Mannschaft_Club
        FOREIGN KEY (VereinsNr)
        REFERENCES dbo.Club(VereinsNr),

    CONSTRAINT FK_Mannschaft_Ligaphase
        FOREIGN KEY (LigaphaseID)
        REFERENCES dbo.Ligaphase(LigaphaseID),

    CONSTRAINT FK_Mannschaft_Kapitaen
        FOREIGN KEY (KapitaenLizenz)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT FK_Mannschaft_Ball
        FOREIGN KEY (BallID)
        REFERENCES dbo.Ball(BallID),

    CONSTRAINT UQ_Mannschaft
        UNIQUE
        (
            LigaphaseID,
            VereinsNr,
            MannschaftNummer
        ),

    CONSTRAINT CK_Mannschaft_MannschaftNummer
        CHECK (MannschaftNummer > 0)
);
GO