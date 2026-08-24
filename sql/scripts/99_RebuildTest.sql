/*
    ============================================================
    STT-DB - KOMPLETTER REBUILD-TEST
    ============================================================

    Zweck:
    - vorhandene Testdatenbank löschen
    - Testdatenbank neu erstellen
    - alle 39 Tabellen erstellen
    - Stammdaten einspielen
    - alle 5 Views erstellen
    - alle 6 Stored Procedures erstellen
    - Ergebnis kontrollieren

    WICHTIG:
    Dieses Skript muss in SSMS im SQLCMD-Modus
    ausgeführt werden.
    ============================================================
*/

USE master;
GO


/*
    ============================================================
    1. VORHANDENE TESTDATENBANK ENTFERNEN
    ============================================================
*/

IF DB_ID(N'STT_DB_REBUILD_TEST') IS NOT NULL
BEGIN
    ALTER DATABASE STT_DB_REBUILD_TEST
        SET SINGLE_USER
        WITH ROLLBACK IMMEDIATE;

    DROP DATABASE STT_DB_REBUILD_TEST;
END;
GO


/*
    ============================================================
    2. FRISCHE TESTDATENBANK ERSTELLEN
    ============================================================
*/

CREATE DATABASE STT_DB_REBUILD_TEST;
GO

USE STT_DB_REBUILD_TEST;
GO


/*
    ============================================================
    3. TABELLEN ERSTELLEN
    ============================================================
*/

:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\01_Saison.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\02_Verband.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\03_Alterskategorie.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\04_Klassierungsstufe.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\05_Club.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\06_Spielort.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\07_Spieler.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\08_SpielerSaison.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\09_SpielerVerein.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\10_Bewertungsperiode.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\11_Klassierungsgrenze.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\12_SpielerBewertung.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\13_EloMonatslauf.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\14_SpielerElo.sql"

/*
    15_EloProtokoll wird bewusst später erstellt.

    Grund:
    EloProtokoll besitzt einen Foreign Key auf Einzelspiel.
    Einzelspiel wird erst mit Datei 37 erstellt.
*/

:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\16_Funktion.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\17_Vereinsfunktionaer.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\18_FunktionaerFunktion.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\19_Benutzer.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\20_Ball.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\21_Spielsystem.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\22_Ligawettbewerb.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\23_Ligaphase.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\24_Mannschaft.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\25_MannschaftSpieler.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\26_BenutzerMannschaft.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\27_Begegnung.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\28_Begegnungsaufstellung.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\29_Begegnungsbemerkung.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\30_BegegnungAenderung.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\31_Turnier.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\32_TurnierKategorie.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\33_Einzelanmeldung.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\34_Doppelanmeldung.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\35_Turniermannschaft.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\36_TurniermannschaftSpieler.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\37_Einzelspiel.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\38_Doppelspiel.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\39_Satz.sql"

/*
    Einzelspiel existiert jetzt.
    EloProtokoll kann deshalb erstellt werden.
*/

:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\15_EloProtokoll.sql"


/*
    ============================================================
    4. STAMMDATEN / SEEDS
    ============================================================
*/

:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\seed\01_Verbaende.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\seed\02_Alterskategorien.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\seed\03_Klassierungsstufen.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\seed\04_Spielsysteme.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\seed\05_Baelle.sql"


/*
    ============================================================
    5. VIEWS
    ============================================================
*/

:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\views\01_vw_SpielerAktuell.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\views\02_vw_MannschaftenLiga.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\views\03_vw_BegegnungenUebersicht.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\views\04_vw_Turnieranmeldungen.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\views\05_vw_Spielresultate.sql"


/*
    ============================================================
    6. STORED PROCEDURES
    ============================================================
*/

:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\procedures\01_sp_SpielerAnmelden.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\procedures\02_sp_MannschaftSpielerHinzufuegen.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\procedures\03_sp_BegegnungErfassen.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\procedures\04_sp_BegegnungResultatErfassen.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\procedures\05_sp_TurnierEinzelAnmelden.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\procedures\06_sp_EloAktualisieren.sql"


/*
    ============================================================
    7. ABSCHLUSSKONTROLLE
    ============================================================
*/

PRINT '========================================';
PRINT 'STT-DB REBUILD ABGESCHLOSSEN';
PRINT '========================================';
GO


/*
    ------------------------------------------------------------
    TABELLEN KONTROLLIEREN
    Erwartet: 39
    ------------------------------------------------------------
*/

SELECT
    COUNT(*) AS AnzahlTabellen
FROM sys.tables
WHERE schema_id = SCHEMA_ID('dbo');
GO


SELECT
    name AS Tabellenname
FROM sys.tables
WHERE schema_id = SCHEMA_ID('dbo')
ORDER BY name;
GO


/*
    ------------------------------------------------------------
    VIEWS KONTROLLIEREN
    Erwartet: 5
    ------------------------------------------------------------
*/

SELECT
    COUNT(*) AS AnzahlViews
FROM sys.views
WHERE schema_id = SCHEMA_ID('dbo');
GO


SELECT
    name AS Viewname
FROM sys.views
WHERE schema_id = SCHEMA_ID('dbo')
ORDER BY name;
GO


/*
    ------------------------------------------------------------
    STORED PROCEDURES KONTROLLIEREN
    Erwartet: 6
    ------------------------------------------------------------
*/

SELECT
    COUNT(*) AS AnzahlProcedures
FROM sys.procedures
WHERE schema_id = SCHEMA_ID('dbo');
GO


SELECT
    name AS ProcedureName
FROM sys.procedures
WHERE schema_id = SCHEMA_ID('dbo')
ORDER BY name;
GO


/*
    ------------------------------------------------------------
    STAMMDATEN KONTROLLIEREN

    Erwartet:
        Verband              10
        Alterskategorie       9
        Klassierungsstufe    22
        Spielsystem           1
        Ball                  3
    ------------------------------------------------------------
*/

SELECT
    'Verband' AS Tabelle,
    COUNT(*) AS Anzahl
FROM dbo.Verband

UNION ALL

SELECT
    'Alterskategorie',
    COUNT(*)
FROM dbo.Alterskategorie

UNION ALL

SELECT
    'Klassierungsstufe',
    COUNT(*)
FROM dbo.Klassierungsstufe

UNION ALL

SELECT
    'Spielsystem',
    COUNT(*)
FROM dbo.Spielsystem

UNION ALL

SELECT
    'Ball',
    COUNT(*)
FROM dbo.Ball;
GO


/*
    ============================================================
    8. VIEW-FUNKTIONSTEST
    ============================================================

    0 Zeilen sind hier vollkommen in Ordnung.
    Wichtig ist, dass die Views fehlerfrei ausgeführt werden.
    ============================================================
*/

SELECT TOP (1) *
FROM dbo.vw_SpielerAktuell;
GO

SELECT TOP (1) *
FROM dbo.vw_MannschaftenLiga;
GO

SELECT TOP (1) *
FROM dbo.vw_BegegnungenUebersicht;
GO

SELECT TOP (1) *
FROM dbo.vw_Turnieranmeldungen;
GO

SELECT TOP (1) *
FROM dbo.vw_Spielresultate;
GO


/*
    ============================================================
    9. AUTOMATISCHE SOLL-PRUEFUNG
    ============================================================

    Wenn eine erwartete Anzahl nicht stimmt,
    bricht der Rebuild mit einem Fehler ab.
    ============================================================
*/

IF
(
    SELECT COUNT(*)
    FROM sys.tables
    WHERE schema_id = SCHEMA_ID('dbo')
) <> 39
BEGIN
    THROW 51001, 'REBUILD FEHLER: Es wurden nicht genau 39 Tabellen erstellt.', 1;
END;
GO


IF
(
    SELECT COUNT(*)
    FROM sys.views
    WHERE schema_id = SCHEMA_ID('dbo')
) <> 5
BEGIN
    THROW 51002, 'REBUILD FEHLER: Es wurden nicht genau 5 Views erstellt.', 1;
END;
GO


IF
(
    SELECT COUNT(*)
    FROM sys.procedures
    WHERE schema_id = SCHEMA_ID('dbo')
) <> 6
BEGIN
    THROW 51003, 'REBUILD FEHLER: Es wurden nicht genau 6 Stored Procedures erstellt.', 1;
END;
GO


IF (SELECT COUNT(*) FROM dbo.Verband) <> 10
BEGIN
    THROW 51004, 'REBUILD FEHLER: Verband-Seed stimmt nicht.', 1;
END;
GO


IF (SELECT COUNT(*) FROM dbo.Alterskategorie) <> 9
BEGIN
    THROW 51005, 'REBUILD FEHLER: Alterskategorie-Seed stimmt nicht.', 1;
END;
GO


IF (SELECT COUNT(*) FROM dbo.Klassierungsstufe) <> 22
BEGIN
    THROW 51006, 'REBUILD FEHLER: Klassierungsstufe-Seed stimmt nicht.', 1;
END;
GO


IF (SELECT COUNT(*) FROM dbo.Spielsystem) <> 1
BEGIN
    THROW 51007, 'REBUILD FEHLER: Spielsystem-Seed stimmt nicht.', 1;
END;
GO


IF (SELECT COUNT(*) FROM dbo.Ball) <> 3
BEGIN
    THROW 51008, 'REBUILD FEHLER: Ball-Seed stimmt nicht.', 1;
END;
GO


/*
    ============================================================
    10. ERFOLG
    ============================================================
*/

PRINT '========================================';
PRINT 'ALLE REBUILD-PRUEFUNGEN ERFOLGREICH';
PRINT '========================================';
PRINT '39 Tabellen';
PRINT '5 Views';
PRINT '6 Stored Procedures';
PRINT 'Seeds korrekt';
PRINT '========================================';
GO