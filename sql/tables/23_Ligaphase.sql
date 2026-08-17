USE STT_DB;
GO

/*
    Tabelle: Ligaphase
    Zweck:
    Speichert Gruppen bzw. Phasen eines Ligawettbewerbs.

    Beispiele:
    - Gruppe 1
    - Gruppe 2
    - Hauptrunde
    - Finalrunde
*/

CREATE TABLE dbo.Ligaphase
(
    LigaphaseID INT IDENTITY(1,1) NOT NULL,
    LigawettbewerbID INT NOT NULL,
    Bezeichnung NVARCHAR(100) NOT NULL,
    Phasentyp VARCHAR(20) NOT NULL,
    Gruppenbezeichnung NVARCHAR(50) NULL,
    KlassenleiterBenutzerID INT NULL,
    Aktiv BIT NOT NULL
        CONSTRAINT DF_Ligaphase_Aktiv DEFAULT (1),

    CONSTRAINT PK_Ligaphase
        PRIMARY KEY (LigaphaseID),

    CONSTRAINT FK_Ligaphase_Ligawettbewerb
        FOREIGN KEY (LigawettbewerbID)
        REFERENCES dbo.Ligawettbewerb(LigawettbewerbID),

    CONSTRAINT FK_Ligaphase_Klassenleiter
        FOREIGN KEY (KlassenleiterBenutzerID)
        REFERENCES dbo.Benutzer(BenutzerID),

    CONSTRAINT UQ_Ligaphase_Wettbewerb_Bezeichnung
        UNIQUE
        (
            LigawettbewerbID,
            Bezeichnung
        ),

    CONSTRAINT CK_Ligaphase_Phasentyp
        CHECK
        (
            Phasentyp IN
            (
                'HAUPTRUNDE',
                'VORRUNDE',
                'FINALRUNDE'
            )
        )
);
GO