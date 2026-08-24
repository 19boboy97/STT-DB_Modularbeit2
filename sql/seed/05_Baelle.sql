/*
    Seed: Baelle
    Zweck:
    Erstellt die standardmaessig verwendeten Baelle.

    Das Skript ist idempotent und kann mehrfach
    ausgefuehrt werden.
*/

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Ball
    WHERE Marke = N'Nittaku'
      AND Modell = N'Premium 40+'
      AND Farbe = 'WEISS'
)
BEGIN
    INSERT INTO dbo.Ball
    (
        Marke,
        Modell,
        Farbe,
        Aktiv
    )
    VALUES
    (
        N'Nittaku',
        N'Premium 40+',
        'WEISS',
        1
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Ball
    WHERE Marke = N'DHS'
      AND Modell = N'D40+ 3-Star'
      AND Farbe = 'WEISS'
)
BEGIN
    INSERT INTO dbo.Ball
    (
        Marke,
        Modell,
        Farbe,
        Aktiv
    )
    VALUES
    (
        N'DHS',
        N'D40+ 3-Star',
        'WEISS',
        1
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Ball
    WHERE Marke = N'Tibhar'
      AND Modell = N'SYNTT NG 40+'
      AND Farbe = 'WEISS'
)
BEGIN
    INSERT INTO dbo.Ball
    (
        Marke,
        Modell,
        Farbe,
        Aktiv
    )
    VALUES
    (
        N'Tibhar',
        N'SYNTT NG 40+',
        'WEISS',
        1
    );
END;
GO

SELECT
    BallID,
    Marke,
    Modell,
    Farbe,
    Aktiv
FROM dbo.Ball
ORDER BY BallID;
GO