USE STT_DB;
GO

/*
    Tabelle: Ligawettbewerb
    Zweck:
    Definiert einen Ligawettbewerb innerhalb einer Saison.

    Beispiele:
    - Nationalliga A
    - Nationalliga B
    - 1. Liga
    - O40
*/

CREATE TABLE dbo.Ligawettbewerb
(
    LigawettbewerbID INT IDENTITY(1,1) NOT NULL,
    SaisonID INT NOT NULL,
    VerbandID INT NOT NULL,
    Bezeichnung NVARCHAR(100) NOT NULL,
    Geschlechtskategorie VARCHAR(10) NOT NULL,
    Alterskategorie VARCHAR(10) NULL,
    SpielsystemID INT NOT NULL,
    Aktiv BIT NOT NULL
        CONSTRAINT DF_Ligawettbewerb_Aktiv DEFAULT (1),

    CONSTRAINT PK_Ligawettbewerb
        PRIMARY KEY (LigawettbewerbID),

    CONSTRAINT FK_Ligawettbewerb_Saison
        FOREIGN KEY (SaisonID)
        REFERENCES dbo.Saison(SaisonID),

    CONSTRAINT FK_Ligawettbewerb_Verband
        FOREIGN KEY (VerbandID)
        REFERENCES dbo.Verband(VerbandID),

    CONSTRAINT FK_Ligawettbewerb_Alterskategorie
        FOREIGN KEY (Alterskategorie)
        REFERENCES dbo.Alterskategorie(Bezeichnung),

    CONSTRAINT FK_Ligawettbewerb_Spielsystem
        FOREIGN KEY (SpielsystemID)
        REFERENCES dbo.Spielsystem(SpielsystemID),

    CONSTRAINT UQ_Ligawettbewerb
        UNIQUE
        (
            SaisonID,
            VerbandID,
            Bezeichnung,
            Geschlechtskategorie,
            Alterskategorie
        ),

    CONSTRAINT CK_Ligawettbewerb_Geschlechtskategorie
        CHECK
        (
            Geschlechtskategorie IN ('HERREN', 'DAMEN')
        )
);
GO