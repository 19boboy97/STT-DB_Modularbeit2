
/*
    Tabelle: Doppelanmeldung
    Zweck:
    Speichert die Anmeldung eines Doppelpaares
    zu einer Doppel-Kategorie eines Turniers.

    Die Reihenfolge der beiden Spieler spielt für
    die Eindeutigkeit des Doppelpaares keine Rolle.
*/

CREATE TABLE dbo.Doppelanmeldung
(
    DoppelanmeldungID BIGINT IDENTITY(1,1) NOT NULL,
    TurnierKategorieID INT NOT NULL,

    Spieler1LizenzNr INT NOT NULL,
    Spieler2LizenzNr INT NOT NULL,

    Anmeldedatum DATETIME2(0) NOT NULL
        CONSTRAINT DF_Doppelanmeldung_Anmeldedatum
        DEFAULT (SYSDATETIME()),

    Status VARCHAR(20) NOT NULL
        CONSTRAINT DF_Doppelanmeldung_Status
        DEFAULT ('ANGEMELDET'),

    Ablehnungsgrund NVARCHAR(500) NULL,

    -- Normalisierte Spielerreihenfolge für die
    -- eindeutige Identifikation eines Doppelpaares.
    SpielerMinLizenz AS
    (
        CASE
            WHEN Spieler1LizenzNr < Spieler2LizenzNr
                THEN Spieler1LizenzNr
            ELSE Spieler2LizenzNr
        END
    ) PERSISTED,

    SpielerMaxLizenz AS
    (
        CASE
            WHEN Spieler1LizenzNr > Spieler2LizenzNr
                THEN Spieler1LizenzNr
            ELSE Spieler2LizenzNr
        END
    ) PERSISTED,

    CONSTRAINT PK_Doppelanmeldung
        PRIMARY KEY (DoppelanmeldungID),

    CONSTRAINT FK_Doppelanmeldung_TurnierKategorie
        FOREIGN KEY (TurnierKategorieID)
        REFERENCES dbo.TurnierKategorie(TurnierKategorieID),

    CONSTRAINT FK_Doppelanmeldung_Spieler1
        FOREIGN KEY (Spieler1LizenzNr)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT FK_Doppelanmeldung_Spieler2
        FOREIGN KEY (Spieler2LizenzNr)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT CK_Doppelanmeldung_VerschiedeneSpieler
        CHECK
        (
            Spieler1LizenzNr <> Spieler2LizenzNr
        ),

    CONSTRAINT CK_Doppelanmeldung_Status
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

/*
    Verhindert dieselbe Paarung auch bei
    vertauschter Spielerreihenfolge.

    Beispiel:
    512038 + 512039
    und
    512039 + 512038
    gelten als dasselbe Doppel.
*/
CREATE UNIQUE INDEX UX_Doppelanmeldung_Paar
ON dbo.Doppelanmeldung
(
    TurnierKategorieID,
    SpielerMinLizenz,
    SpielerMaxLizenz
);
GO
