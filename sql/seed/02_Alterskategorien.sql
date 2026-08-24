/*
    Seed: Alterskategorien
    Zweck:
    Erstellt die festen Alterskategorien.
*/

IF NOT EXISTS (SELECT 1 FROM dbo.Alterskategorie WHERE Bezeichnung = 'U11')
BEGIN
    INSERT INTO dbo.Alterskategorie (Bezeichnung, MinAlter, MaxAlter)
    VALUES ('U11', 0, 10);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Alterskategorie WHERE Bezeichnung = 'U13')
BEGIN
    INSERT INTO dbo.Alterskategorie (Bezeichnung, MinAlter, MaxAlter)
    VALUES ('U13', 11, 12);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Alterskategorie WHERE Bezeichnung = 'U15')
BEGIN
    INSERT INTO dbo.Alterskategorie (Bezeichnung, MinAlter, MaxAlter)
    VALUES ('U15', 13, 14);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Alterskategorie WHERE Bezeichnung = 'U19')
BEGIN
    INSERT INTO dbo.Alterskategorie (Bezeichnung, MinAlter, MaxAlter)
    VALUES ('U19', 15, 18);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Alterskategorie WHERE Bezeichnung = 'Aktive')
BEGIN
    INSERT INTO dbo.Alterskategorie (Bezeichnung, MinAlter, MaxAlter)
    VALUES ('Aktive', 19, 39);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Alterskategorie WHERE Bezeichnung = 'O40')
BEGIN
    INSERT INTO dbo.Alterskategorie (Bezeichnung, MinAlter, MaxAlter)
    VALUES ('O40', 40, 49);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Alterskategorie WHERE Bezeichnung = 'O50')
BEGIN
    INSERT INTO dbo.Alterskategorie (Bezeichnung, MinAlter, MaxAlter)
    VALUES ('O50', 50, 69);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Alterskategorie WHERE Bezeichnung = 'O70')
BEGIN
    INSERT INTO dbo.Alterskategorie (Bezeichnung, MinAlter, MaxAlter)
    VALUES ('O70', 70, 79);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Alterskategorie WHERE Bezeichnung = 'O80')
BEGIN
    INSERT INTO dbo.Alterskategorie (Bezeichnung, MinAlter, MaxAlter)
    VALUES ('O80', 80, NULL);
END;
GO

SELECT
    Bezeichnung,
    MinAlter,
    MaxAlter
FROM dbo.Alterskategorie
ORDER BY MinAlter;
GO