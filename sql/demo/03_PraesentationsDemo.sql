USE STT_DB;
GO

SET NOCOUNT ON;
GO


/* ============================================================
   STT-DB - PRAESENTATIONSDEMO

   1. Technischer Umfang
   2. Alle Tabellen
   3. Alle Views
   4. Alle Stored Procedures
   5. Begegnung
   6. Elo-Aenderung
   7. Turnieranmeldung
   ============================================================ */


/* ============================================================
   1. TECHNISCHER UMFANG
   ============================================================ */

SELECT
    '1. TECHNISCHER UMFANG' AS DemoAbschnitt;

SELECT
    (SELECT COUNT(*) FROM sys.tables) AS Tabellen,
    (SELECT COUNT(*) FROM sys.views) AS Views,
    (SELECT COUNT(*) FROM sys.procedures) AS StoredProcedures;

GO


/* ============================================================
   2. TABELLEN
   ============================================================ */

SELECT
    '2. TABELLEN' AS DemoAbschnitt;

SELECT
    ROW_NUMBER() OVER (ORDER BY name) AS Nr,
    name AS Tabellenname
FROM sys.tables
ORDER BY name;

GO


/* ============================================================
   3. VIEWS
   ============================================================ */

SELECT
    '3. VIEWS' AS DemoAbschnitt;

SELECT
    ROW_NUMBER() OVER (ORDER BY name) AS Nr,
    name AS Viewname
FROM sys.views
ORDER BY name;

GO


/* ============================================================
   4. STORED PROCEDURES
   ============================================================ */

SELECT
    '4. STORED PROCEDURES' AS DemoAbschnitt;

SELECT
    ROW_NUMBER() OVER (ORDER BY name) AS Nr,
    name AS Procedurename
FROM sys.procedures
ORDER BY name;

GO


/* ============================================================
   5. BEGEGNUNG
   ============================================================ */

SELECT
    '5. BEGEGNUNG - abgeschlossenes Mannschaftsspiel'
    AS DemoAbschnitt;

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


/* ============================================================
   6. ELO-AENDERUNG
   ============================================================ */

SELECT
    '6. ELO - historisierte Wertaenderung'
    AS DemoAbschnitt;

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


/* ============================================================
   7. TURNIERANMELDUNG
   ============================================================ */

SELECT
    '7. TURNIER - Einzelanmeldung'
    AS DemoAbschnitt;

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


/* ============================================================
   DEMO ENDE
   ============================================================ */

SELECT
    'PRAESENTATIONSDEMO ERFOLGREICH'
    AS DemoStatus;

GO


/* ============================================================
   FRAGEN / SPONTANE ABFRAGEN

   Diese Befehle NICHT zusammen mit der normalen Demo markieren.
   Bei Bedarf einzelne Abfrage markieren und mit F5 ausfuehren.
   ============================================================ */


/* Beispiel: Spieler anzeigen */
SELECT TOP (20) *
FROM dbo.Spieler;


/* Beispiel: Elo-Historie anzeigen */
SELECT TOP (20) *
FROM dbo.EloProtokoll;


/* Beispiel: Begegnungen anzeigen */
SELECT TOP (20) *
FROM dbo.Begegnung;


/* Beispiel: Turnieranmeldungen anzeigen */
SELECT TOP (20) *
FROM dbo.Einzelanmeldung;