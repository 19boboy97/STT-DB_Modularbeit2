USE STT_DB;
GO

/*
    Tabelle: Club
    Zweck:
    Speichert die Tischtennisclubs und ihre
    Zugehörigkeit zu einem Regionalverband.
*/

CREATE TABLE dbo.Club
(
    VereinsNr INT NOT NULL,
    Clubname NVARCHAR(150) NOT NULL,
    Kurzname NVARCHAR(50) NULL,
    RegionalverbandID INT NOT NULL,
    Gruendungsjahr SMALLINT NULL,
    Webseite NVARCHAR(255) NULL,
    Ort NVARCHAR(100) NULL,
    Landcode CHAR(2) NOT NULL
        CONSTRAINT DF_Club_Landcode DEFAULT ('CH'),
    Aktiv BIT NOT NULL
        CONSTRAINT DF_Club_Aktiv DEFAULT (1),

    CONSTRAINT PK_Club
        PRIMARY KEY (VereinsNr),

    CONSTRAINT FK_Club_Regionalverband
        FOREIGN KEY (RegionalverbandID)
        REFERENCES dbo.Verband(VerbandID),

    CONSTRAINT CK_Club_Gruendungsjahr
        CHECK
        (
            Gruendungsjahr IS NULL
            OR Gruendungsjahr > 0
        ),

    CONSTRAINT CK_Club_Landcode
        CHECK (LEN(Landcode) = 2)
);
GO