/*
    View: vw_Turnieranmeldungen

    Zweck:
    Fasst Einzel-, Doppel- und Mannschaftsanmeldungen
    eines Turniers in einer gemeinsamen Übersicht zusammen.
*/

CREATE VIEW dbo.vw_Turnieranmeldungen
AS

/*
    ============================================================
    EINZELANMELDUNGEN
    ============================================================
*/
SELECT
    'EINZEL' AS Anmeldeart,

    t.TurnierID,
    t.Turniername,

    tk.TurnierKategorieID,
    tk.Bezeichnung AS Kategorie,
    tk.Wettkampfform,

    ea.EinzelanmeldungID AS AnmeldungID,

    ea.Anmeldedatum,
    ea.Status,
    ea.Ablehnungsgrund,

    ea.LizenzNr AS Spieler1LizenzNr,
    s1.Vorname AS Spieler1Vorname,
    s1.Nachname AS Spieler1Nachname,

    CAST(NULL AS INT) AS Spieler2LizenzNr,
    CAST(NULL AS NVARCHAR(80)) AS Spieler2Vorname,
    CAST(NULL AS NVARCHAR(80)) AS Spieler2Nachname,

    CAST(NULL AS BIGINT) AS TurniermannschaftID,
    CAST(NULL AS NVARCHAR(100)) AS Mannschaftsname

FROM dbo.Einzelanmeldung AS ea

INNER JOIN dbo.TurnierKategorie AS tk
    ON tk.TurnierKategorieID = ea.TurnierKategorieID

INNER JOIN dbo.Turnier AS t
    ON t.TurnierID = tk.TurnierID

INNER JOIN dbo.Spieler AS s1
    ON s1.LizenzNr = ea.LizenzNr


UNION ALL


/*
    ============================================================
    DOPPELANMELDUNGEN
    ============================================================
*/
SELECT
    'DOPPEL' AS Anmeldeart,

    t.TurnierID,
    t.Turniername,

    tk.TurnierKategorieID,
    tk.Bezeichnung AS Kategorie,
    tk.Wettkampfform,

    da.DoppelanmeldungID AS AnmeldungID,

    da.Anmeldedatum,
    da.Status,
    da.Ablehnungsgrund,

    da.Spieler1LizenzNr,
    s1.Vorname AS Spieler1Vorname,
    s1.Nachname AS Spieler1Nachname,

    da.Spieler2LizenzNr,
    s2.Vorname AS Spieler2Vorname,
    s2.Nachname AS Spieler2Nachname,

    CAST(NULL AS BIGINT) AS TurniermannschaftID,
    CAST(NULL AS NVARCHAR(100)) AS Mannschaftsname

FROM dbo.Doppelanmeldung AS da

INNER JOIN dbo.TurnierKategorie AS tk
    ON tk.TurnierKategorieID = da.TurnierKategorieID

INNER JOIN dbo.Turnier AS t
    ON t.TurnierID = tk.TurnierID

INNER JOIN dbo.Spieler AS s1
    ON s1.LizenzNr = da.Spieler1LizenzNr

INNER JOIN dbo.Spieler AS s2
    ON s2.LizenzNr = da.Spieler2LizenzNr


UNION ALL


/*
    ============================================================
    MANNSCHAFTSANMELDUNGEN
    ============================================================
*/
SELECT
    'MANNSCHAFT' AS Anmeldeart,

    t.TurnierID,
    t.Turniername,

    tk.TurnierKategorieID,
    tk.Bezeichnung AS Kategorie,
    tk.Wettkampfform,

    tm.TurniermannschaftID AS AnmeldungID,

    tm.Anmeldedatum,
    tm.Status,
    tm.Ablehnungsgrund,

    CAST(NULL AS INT) AS Spieler1LizenzNr,
    CAST(NULL AS NVARCHAR(80)) AS Spieler1Vorname,
    CAST(NULL AS NVARCHAR(80)) AS Spieler1Nachname,

    CAST(NULL AS INT) AS Spieler2LizenzNr,
    CAST(NULL AS NVARCHAR(80)) AS Spieler2Vorname,
    CAST(NULL AS NVARCHAR(80)) AS Spieler2Nachname,

    tm.TurniermannschaftID,
    tm.Name AS Mannschaftsname

FROM dbo.Turniermannschaft AS tm

INNER JOIN dbo.TurnierKategorie AS tk
    ON tk.TurnierKategorieID = tm.TurnierKategorieID

INNER JOIN dbo.Turnier AS t
    ON t.TurnierID = tk.TurnierID;
GO