/*
    Seed: Spielsysteme
    Zweck:
    Erstellt die standardmaessig benoetigten Spielsysteme.

    Das Skript ist idempotent und kann mehrfach
    ausgefuehrt werden.
*/

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Spielsystem
    WHERE Bezeichnung = N'3er-Mannschaft'
)
BEGIN
    INSERT INTO dbo.Spielsystem
    (
        Bezeichnung,
        AnzahlSpieler,
        AnzahlEinzel,
        AnzahlDoppel,
        MaxAnzahlSpiele,
        Aktiv
    )
    VALUES
    (
        N'3er-Mannschaft',
        3,
        9,
        1,
        10,
        1
    );
END;
GO

SELECT
    SpielsystemID,
    Bezeichnung,
    AnzahlSpieler,
    AnzahlEinzel,
    AnzahlDoppel,
    MaxAnzahlSpiele,
    Aktiv
FROM dbo.Spielsystem
ORDER BY SpielsystemID;
GO