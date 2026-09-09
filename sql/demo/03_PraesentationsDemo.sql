USE STT_DB;
GO

SET NOCOUNT ON;
GO

/* ============================================================
   STT-DB – Kurzdemo für die Präsentation
   Zeigt nur die drei wichtigsten Resultate:
   1. Begegnung
   2. Elo-Änderung
   3. Turnieranmeldung
   ============================================================ */


/* ------------------------------------------------------------
   1. Begegnung
   ------------------------------------------------------------ */

PRINT '=== 1. BEGEGNUNG ===';

SELECT
    b.Datum,
    b.Startzeit,
    b.SiegeHeim,
    b.SiegeGast,
    b.MannschaftspunkteHeim,
    b.MannschaftspunkteGast,
    b.Status
FROM dbo.Begegnung AS b
WHERE b.Datum = '2026-09-20';

GO


/* ------------------------------------------------------------
   2. Elo-Änderung
   ------------------------------------------------------------ */

PRINT '=== 2. ELO-AENDERUNG ===';

SELECT
    ep.LizenzNr,
    s.Vorname,
    s.Nachname,
    ep.StichtagsElo,
    ep.GegnerStichtagsElo,
    ep.VorschauElo,
    ep.VorschauElo - ep.StichtagsElo AS EloAenderung
FROM dbo.EloProtokoll AS ep
INNER JOIN dbo.Spieler AS s
    ON s.LizenzNr = ep.LizenzNr
WHERE ep.LizenzNr IN (990001, 990003)
ORDER BY ep.LizenzNr;

GO


/* ------------------------------------------------------------
   3. Turnieranmeldung
   ------------------------------------------------------------ */

PRINT '=== 3. TURNIERANMELDUNG ===';

SELECT
    ea.LizenzNr,
    s.Vorname,
    s.Nachname,
    tk.Bezeichnung AS Kategorie,
    ea.Status
FROM dbo.Einzelanmeldung AS ea
INNER JOIN dbo.Spieler AS s
    ON s.LizenzNr = ea.LizenzNr
INNER JOIN dbo.TurnierKategorie AS tk
    ON tk.TurnierKategorieID = ea.TurnierKategorieID
WHERE ea.LizenzNr = 990001;

GO


PRINT '=== PRAESENTATIONSDEMO ERFOLGREICH ===';
GO