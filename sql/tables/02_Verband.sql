USE STT_DB;
GO

/*
    Tabelle: Verband
    Zweck:
    Speichert Swiss Table Tennis und die Regionalverbände.
*/

CREATE TABLE dbo.Verband
(
    VerbandID INT IDENTITY(1,1) NOT NULL,
    Kurzname VARCHAR(10) NOT NULL,
    Name NVARCHAR(150) NOT NULL,
    Verbandstyp VARCHAR(10) NOT NULL,
    UebergeordneterVerbandID INT NULL,
    Gruendungsdatum DATE NULL,
    Webseite NVARCHAR(255) NULL,
    Aktiv BIT NOT NULL
        CONSTRAINT DF_Verband_Aktiv DEFAULT (1),

    CONSTRAINT PK_Verband
        PRIMARY KEY (VerbandID),

    CONSTRAINT UQ_Verband_Kurzname
        UNIQUE (Kurzname),

    CONSTRAINT CK_Verband_Verbandstyp
        CHECK (Verbandstyp IN ('NATIONAL', 'REGIONAL')),

    CONSTRAINT CK_Verband_Hierarchie
        CHECK
        (
            (Verbandstyp = 'NATIONAL' AND UebergeordneterVerbandID IS NULL)
            OR
            (Verbandstyp = 'REGIONAL' AND UebergeordneterVerbandID IS NOT NULL)
        ),

    CONSTRAINT FK_Verband_UebergeordneterVerband
        FOREIGN KEY (UebergeordneterVerbandID)
        REFERENCES dbo.Verband(VerbandID)
);
GO