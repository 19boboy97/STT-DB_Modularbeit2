/*
    Seed: Verbaende
    Zweck:
    Erstellt Swiss Table Tennis und die 9 Regionalverbaende.
*/

DECLARE @STT_ID INT;

/*
    Nationalverband anlegen.
*/
IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Verband
    WHERE Kurzname = 'STT'
)
BEGIN
    INSERT INTO dbo.Verband
    (
        Kurzname,
        Name,
        Verbandstyp,
        UebergeordneterVerbandID,
        Aktiv
    )
    VALUES
    (
        'STT',
        N'Swiss Table Tennis',
        'NATIONAL',
        NULL,
        1
    );
END;

/*
    ID von STT holen.
*/
SELECT @STT_ID = VerbandID
FROM dbo.Verband
WHERE Kurzname = 'STT';

/*
    Regionalverbaende anlegen.
*/
IF NOT EXISTS (SELECT 1 FROM dbo.Verband WHERE Kurzname = 'ATTT')
BEGIN
    INSERT INTO dbo.Verband
    (
        Kurzname,
        Name,
        Verbandstyp,
        UebergeordneterVerbandID,
        Aktiv
    )
    VALUES
    (
        'ATTT',
        N'Association de Tennis de Table du Tessin',
        'REGIONAL',
        @STT_ID,
        1
    );
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Verband WHERE Kurzname = 'AGTT')
BEGIN
    INSERT INTO dbo.Verband
    (
        Kurzname,
        Name,
        Verbandstyp,
        UebergeordneterVerbandID,
        Aktiv
    )
    VALUES
    (
        'AGTT',
        N'Association Genevoise de Tennis de Table',
        'REGIONAL',
        @STT_ID,
        1
    );
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Verband WHERE Kurzname = 'ANJTT')
BEGIN
    INSERT INTO dbo.Verband
    (
        Kurzname,
        Name,
        Verbandstyp,
        UebergeordneterVerbandID,
        Aktiv
    )
    VALUES
    (
        'ANJTT',
        N'Association Neuchateloise et Jurassienne de Tennis de Table',
        'REGIONAL',
        @STT_ID,
        1
    );
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Verband WHERE Kurzname = 'AVVF')
BEGIN
    INSERT INTO dbo.Verband
    (
        Kurzname,
        Name,
        Verbandstyp,
        UebergeordneterVerbandID,
        Aktiv
    )
    VALUES
    (
        'AVVF',
        N'Association Vaud-Valais-Fribourg de Tennis de Table',
        'REGIONAL',
        @STT_ID,
        1
    );
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Verband WHERE Kurzname = 'MTTV')
BEGIN
    INSERT INTO dbo.Verband
    (
        Kurzname,
        Name,
        Verbandstyp,
        UebergeordneterVerbandID,
        Aktiv
    )
    VALUES
    (
        'MTTV',
        N'Mittellaendischer Tischtennisverband',
        'REGIONAL',
        @STT_ID,
        1
    );
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Verband WHERE Kurzname = 'NWTTV')
BEGIN
    INSERT INTO dbo.Verband
    (
        Kurzname,
        Name,
        Verbandstyp,
        UebergeordneterVerbandID,
        Aktiv
    )
    VALUES
    (
        'NWTTV',
        N'Nordwestschweizer Tischtennisverband',
        'REGIONAL',
        @STT_ID,
        1
    );
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Verband WHERE Kurzname = 'OTTV')
BEGIN
    INSERT INTO dbo.Verband
    (
        Kurzname,
        Name,
        Verbandstyp,
        UebergeordneterVerbandID,
        Aktiv
    )
    VALUES
    (
        'OTTV',
        N'Ostschweizer Tischtennisverband',
        'REGIONAL',
        @STT_ID,
        1
    );
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Verband WHERE Kurzname = 'TTVI')
BEGIN
    INSERT INTO dbo.Verband
    (
        Kurzname,
        Name,
        Verbandstyp,
        UebergeordneterVerbandID,
        Aktiv
    )
    VALUES
    (
        'TTVI',
        N'Tischtennisverband Innerschweiz',
        'REGIONAL',
        @STT_ID,
        1
    );
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Verband WHERE Kurzname = 'TTVZ')
BEGIN
    INSERT INTO dbo.Verband
    (
        Kurzname,
        Name,
        Verbandstyp,
        UebergeordneterVerbandID,
        Aktiv
    )
    VALUES
    (
        'TTVZ',
        N'Tischtennisverband Zuerich',
        'REGIONAL',
        @STT_ID,
        1
    );
END;
GO

SELECT
    VerbandID,
    Kurzname,
    Name,
    Verbandstyp,
    UebergeordneterVerbandID,
    Aktiv
FROM dbo.Verband
ORDER BY VerbandID;
GO