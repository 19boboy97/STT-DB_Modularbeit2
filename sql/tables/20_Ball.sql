USE STT_DB;
GO

/*
    Tabelle: Ball
    Zweck:
    Speichert die verschiedenen verwendeten Tischtennisbälle.

    Ballmarke, Modell und Farbe werden separat gespeichert.
*/

CREATE TABLE dbo.Ball
(
    BallID INT IDENTITY(1,1) NOT NULL,
    Marke NVARCHAR(100) NOT NULL,
    Modell NVARCHAR(100) NOT NULL,
    Farbe VARCHAR(20) NOT NULL,
    Aktiv BIT NOT NULL
        CONSTRAINT DF_Ball_Aktiv DEFAULT (1),

    CONSTRAINT PK_Ball
        PRIMARY KEY (BallID),

    CONSTRAINT UQ_Ball_Marke_Modell_Farbe
        UNIQUE
        (
            Marke,
            Modell,
            Farbe
        )
);
GO