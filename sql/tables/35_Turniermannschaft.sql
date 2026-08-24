
/*
    Tabelle: Turniermannschaft
    Zweck:
    Speichert eine speziell für ein Turnier gebildete Mannschaft.

    Spieler aus unterschiedlichen Clubs dürfen gemeinsam
    in derselben Turniermannschaft spielen.
*/

CREATE TABLE dbo.Turniermannschaft
(
    TurniermannschaftID BIGINT IDENTITY(1,1) NOT NULL,
    TurnierKategorieID INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,

    Anmeldedatum DATETIME2(0) NOT NULL
        CONSTRAINT DF_Turniermannschaft_Anmeldedatum
        DEFAULT (SYSDATETIME()),

    Status VARCHAR(20) NOT NULL
        CONSTRAINT DF_Turniermannschaft_Status
        DEFAULT ('ANGEMELDET'),

    Ablehnungsgrund NVARCHAR(500) NULL,

    CONSTRAINT PK_Turniermannschaft
        PRIMARY KEY (TurniermannschaftID),

    CONSTRAINT FK_Turniermannschaft_TurnierKategorie
        FOREIGN KEY (TurnierKategorieID)
        REFERENCES dbo.TurnierKategorie(TurnierKategorieID),

    CONSTRAINT UQ_Turniermannschaft_Kategorie_Name
        UNIQUE
        (
            TurnierKategorieID,
            Name
        ),

    CONSTRAINT CK_Turniermannschaft_Status
        CHECK
        (
            Status IN
            (
                'ANGEMELDET',
                'BESTAETIGT',
                'ABGELEHNT',
                'ZURUECKGEZOGEN'
            )
        )
);
GO
