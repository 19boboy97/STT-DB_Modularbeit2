USE STT_DB;
GO

/*
    Tabelle: Benutzer
    Zweck:
    Speichert Benutzerkonten für die Verwaltung
    der STT-Datenbank.

    Rollen:
    - CAPTAIN
    - VEREIN
    - KLASSENLEITER
    - ADMIN
*/

CREATE TABLE dbo.Benutzer
(
    BenutzerID INT IDENTITY(1,1) NOT NULL,
    Benutzername NVARCHAR(100) NOT NULL,
    Anzeigename NVARCHAR(150) NOT NULL,
    LizenzNr INT NULL,
    Rolle VARCHAR(20) NOT NULL,
    VereinsNr INT NULL,
    VerbandID INT NULL,
    Aktiv BIT NOT NULL
        CONSTRAINT DF_Benutzer_Aktiv DEFAULT (1),

    CONSTRAINT PK_Benutzer
        PRIMARY KEY (BenutzerID),

    CONSTRAINT UQ_Benutzer_Benutzername
        UNIQUE (Benutzername),

    CONSTRAINT FK_Benutzer_Spieler
        FOREIGN KEY (LizenzNr)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT FK_Benutzer_Club
        FOREIGN KEY (VereinsNr)
        REFERENCES dbo.Club(VereinsNr),

    CONSTRAINT FK_Benutzer_Verband
        FOREIGN KEY (VerbandID)
        REFERENCES dbo.Verband(VerbandID),

    CONSTRAINT CK_Benutzer_Rolle
        CHECK
        (
            Rolle IN
            (
                'CAPTAIN',
                'VEREIN',
                'KLASSENLEITER',
                'ADMIN'
            )
        )
);
GO