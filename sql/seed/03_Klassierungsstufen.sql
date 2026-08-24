/*
    Seed: Klassierungsstufen
    Zweck:
    Erstellt die festen Klassierungsstufen D1 bis A22.
*/

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 1)
    INSERT INTO dbo.Klassierungsstufe VALUES (1, 'D1');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 2)
    INSERT INTO dbo.Klassierungsstufe VALUES (2, 'D2');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 3)
    INSERT INTO dbo.Klassierungsstufe VALUES (3, 'D3');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 4)
    INSERT INTO dbo.Klassierungsstufe VALUES (4, 'D4');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 5)
    INSERT INTO dbo.Klassierungsstufe VALUES (5, 'D5');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 6)
    INSERT INTO dbo.Klassierungsstufe VALUES (6, 'C6');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 7)
    INSERT INTO dbo.Klassierungsstufe VALUES (7, 'C7');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 8)
    INSERT INTO dbo.Klassierungsstufe VALUES (8, 'C8');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 9)
    INSERT INTO dbo.Klassierungsstufe VALUES (9, 'C9');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 10)
    INSERT INTO dbo.Klassierungsstufe VALUES (10, 'C10');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 11)
    INSERT INTO dbo.Klassierungsstufe VALUES (11, 'B11');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 12)
    INSERT INTO dbo.Klassierungsstufe VALUES (12, 'B12');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 13)
    INSERT INTO dbo.Klassierungsstufe VALUES (13, 'B13');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 14)
    INSERT INTO dbo.Klassierungsstufe VALUES (14, 'B14');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 15)
    INSERT INTO dbo.Klassierungsstufe VALUES (15, 'B15');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 16)
    INSERT INTO dbo.Klassierungsstufe VALUES (16, 'A16');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 17)
    INSERT INTO dbo.Klassierungsstufe VALUES (17, 'A17');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 18)
    INSERT INTO dbo.Klassierungsstufe VALUES (18, 'A18');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 19)
    INSERT INTO dbo.Klassierungsstufe VALUES (19, 'A19');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 20)
    INSERT INTO dbo.Klassierungsstufe VALUES (20, 'A20');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 21)
    INSERT INTO dbo.Klassierungsstufe VALUES (21, 'A21');

IF NOT EXISTS (SELECT 1 FROM dbo.Klassierungsstufe WHERE Stufenwert = 22)
    INSERT INTO dbo.Klassierungsstufe VALUES (22, 'A22');
GO

SELECT
    Stufenwert,
    Bezeichnung
FROM dbo.Klassierungsstufe
ORDER BY Stufenwert;
GO