USE STT_DB;
GO

/*
    Tabelle: TurniermannschaftSpieler
    Zweck:
    Ordnet Spieler einer Turniermannschaft zu.

    Spieler verschiedener Clubs dürfen gemeinsam
    in derselben Turniermannschaft antreten.
*/

CREATE TABLE dbo.TurniermannschaftSpieler
(
    TurniermannschaftID BIGINT NOT NULL,
    LizenzNr INT NOT NULL,
    Position TINYINT NULL,
    IstCaptain BIT NOT NULL
        CONSTRAINT DF_TurniermannschaftSpieler_IstCaptain
        DEFAULT (0),

    CONSTRAINT PK_TurniermannschaftSpieler
        PRIMARY KEY
        (
            TurniermannschaftID,
            LizenzNr
        ),

    CONSTRAINT FK_TurniermannschaftSpieler_Mannschaft
        FOREIGN KEY (TurniermannschaftID)
        REFERENCES dbo.Turniermannschaft(TurniermannschaftID),

    CONSTRAINT FK_TurniermannschaftSpieler_Spieler
        FOREIGN KEY (LizenzNr)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT CK_TurniermannschaftSpieler_Position
        CHECK
        (
            Position IS NULL
            OR Position > 0
        )
);
GO

/*
    Innerhalb einer Turniermannschaft darf dieselbe
    Positionsnummer nur einmal vergeben werden.

    NULL ist zulässig.
*/
CREATE UNIQUE INDEX UX_TurniermannschaftSpieler_Position
ON dbo.TurniermannschaftSpieler
(
    TurniermannschaftID,
    Position
)
WHERE Position IS NOT NULL;
GO

/*
    Pro Turniermannschaft darf maximal ein Captain existieren.
*/
CREATE UNIQUE INDEX UX_TurniermannschaftSpieler_Captain
ON dbo.TurniermannschaftSpieler
(
    TurniermannschaftID
)
WHERE IstCaptain = 1;
GO