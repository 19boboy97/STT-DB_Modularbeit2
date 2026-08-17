USE STT_DB;
GO

/*
    Tabelle: Spielsystem
    Zweck:
    Definiert die möglichen Spielsysteme für
    Mannschaftsbegegnungen.

    Hier wird unter anderem festgelegt, wie viele
    Spieler und Einzel-/Doppelspiele vorgesehen sind.
*/

CREATE TABLE dbo.Spielsystem
(
    SpielsystemID INT IDENTITY(1,1) NOT NULL,
    Bezeichnung NVARCHAR(100) NOT NULL,
    AnzahlSpieler TINYINT NOT NULL,
    AnzahlEinzel TINYINT NOT NULL,
    AnzahlDoppel TINYINT NOT NULL,
    MaxAnzahlSpiele TINYINT NOT NULL,
    Aktiv BIT NOT NULL
        CONSTRAINT DF_Spielsystem_Aktiv DEFAULT (1),

    CONSTRAINT PK_Spielsystem
        PRIMARY KEY (SpielsystemID),

    CONSTRAINT UQ_Spielsystem_Bezeichnung
        UNIQUE (Bezeichnung),

    CONSTRAINT CK_Spielsystem_AnzahlSpieler
        CHECK (AnzahlSpieler > 0),

    CONSTRAINT CK_Spielsystem_AnzahlEinzel
        CHECK (AnzahlEinzel >= 0),

    CONSTRAINT CK_Spielsystem_AnzahlDoppel
        CHECK (AnzahlDoppel >= 0),

    CONSTRAINT CK_Spielsystem_MaxAnzahlSpiele
        CHECK
        (
            MaxAnzahlSpiele > 0
            AND MaxAnzahlSpiele = AnzahlEinzel + AnzahlDoppel
        )
);
GO