/*
    Projekt: STT-DB Modulararbeit II
    Datei: 02_DemoAblauf.sql

    Zweck:
    Reproduzierbarer Demo-Ablauf fuer die Praesentation.

    Voraussetzung:
    01_DemoDaten.sql wurde vorher erfolgreich ausgefuehrt.

    Demonstriert:
    1. Spieler fuer Saison anmelden
    2. Spieler einer Mannschaft hinzufuegen
    3. Begegnung erfassen
    4. Einzelspiel als fachliche Detaildaten erfassen
    5. Begegnungsresultat erfassen
    6. Elo fuer beide Spieler aktualisieren
    7. Turnier-Einzelanmeldung
    8. Auswertung ueber Views
*/

USE STT_DB;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

PRINT '========================================';
PRINT 'STT-DB DEMOABLAUF';
PRINT '========================================';
GO


/* ============================================================
   DEMO-REFERENZEN ERMITTELN
   ============================================================ */

DECLARE @SaisonID INT =
(
    SELECT SaisonID
    FROM dbo.Saison
    WHERE Bezeichnung = N'DEMO 2026/27'
);

DECLARE @LigawettbewerbID INT =
(
    SELECT TOP (1) lw.LigawettbewerbID
    FROM dbo.Ligawettbewerb AS lw
    WHERE lw.SaisonID = @SaisonID
      AND lw.Bezeichnung = N'Demo Liga'
    ORDER BY lw.LigawettbewerbID
);

DECLARE @LigaphaseID INT =
(
    SELECT LigaphaseID
    FROM dbo.Ligaphase
    WHERE LigawettbewerbID = @LigawettbewerbID
      AND Bezeichnung = N'Demo Hauptrunde'
);

DECLARE @MannschaftBernID INT =
(
    SELECT MannschaftID
    FROM dbo.Mannschaft
    WHERE LigaphaseID = @LigaphaseID
      AND VereinsNr = 99001
      AND MannschaftNummer = 1
);

DECLARE @MannschaftBaselID INT =
(
    SELECT MannschaftID
    FROM dbo.Mannschaft
    WHERE LigaphaseID = @LigaphaseID
      AND VereinsNr = 99002
      AND MannschaftNummer = 1
);

DECLARE @SpielortBernID INT =
(
    SELECT SpielortID
    FROM dbo.Spielort
    WHERE VereinsNr = 99001
      AND Bezeichnung = N'Demo Halle Bern'
);

DECLARE @TurnierKategorieID INT =
(
    SELECT TOP (1) tk.TurnierKategorieID
    FROM dbo.TurnierKategorie AS tk
    INNER JOIN dbo.Turnier AS t
        ON t.TurnierID = tk.TurnierID
    WHERE t.SaisonID = @SaisonID
      AND t.Turniername = N'STT Demo Open 2026'
      AND tk.Bezeichnung = N'Open Einzel Demo'
    ORDER BY tk.TurnierKategorieID
);

DECLARE @EloMonatslaufID BIGINT =
(
    SELECT EloMonatslaufID
    FROM dbo.EloMonatslauf
    WHERE Berechnungsdatum = '2026-09-30'
);

IF @SaisonID IS NULL
    THROW 52001, 'Demo-Saison fehlt. Zuerst 01_DemoDaten.sql ausfuehren.', 1;

IF @LigaphaseID IS NULL
    THROW 52002, 'Demo-Ligaphase fehlt. Zuerst 01_DemoDaten.sql ausfuehren.', 1;

IF @MannschaftBernID IS NULL OR @MannschaftBaselID IS NULL
    THROW 52003, 'Demo-Mannschaften fehlen. Zuerst 01_DemoDaten.sql ausfuehren.', 1;

IF @SpielortBernID IS NULL
    THROW 52004, 'Demo-Spielort fehlt. Zuerst 01_DemoDaten.sql ausfuehren.', 1;

IF @TurnierKategorieID IS NULL
    THROW 52005, 'Demo-Turnierkategorie fehlt. Zuerst 01_DemoDaten.sql ausfuehren.', 1;

IF @EloMonatslaufID IS NULL
    THROW 52006, 'Demo-Elo-Monatslauf fehlt. Zuerst 01_DemoDaten.sql ausfuehren.', 1;


/* ============================================================
   1. SPIELER FUER SAISON ANMELDEN
   ============================================================ */

PRINT '';
PRINT 'SCHRITT 1: Spieler fuer Saison anmelden';
PRINT 'Procedure: sp_SpielerAnmelden';

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.SpielerSaison
    WHERE LizenzNr = 990001
      AND SaisonID = @SaisonID
)
BEGIN
    EXEC dbo.sp_SpielerAnmelden
        @LizenzNr = 990001,
        @SaisonID = @SaisonID,
        @Alterskategorie = 'Aktive',
        @VereinsNr = 99001,
        @Zuordnungsart = 'HAUPTVEREIN',
        @Wettbewerbsbereich = 'ALLE',
        @LizenzAktiv = 1;
END
ELSE
BEGIN
    PRINT 'Spieler 990001 ist bereits fuer die Demo-Saison angemeldet - Schritt wird uebersprungen.';
END;


/* ============================================================
   2. SPIELER DER MANNSCHAFT HINZUFUEGEN
   ============================================================ */

PRINT '';
PRINT 'SCHRITT 2: Spieler der Mannschaft hinzufuegen';
PRINT 'Procedure: sp_MannschaftSpielerHinzufuegen';

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.MannschaftSpieler
    WHERE MannschaftID = @MannschaftBernID
      AND LizenzNr = 990001
)
BEGIN
    EXEC dbo.sp_MannschaftSpielerHinzufuegen
        @MannschaftID = @MannschaftBernID,
        @LizenzNr = 990001,
        @Meldungsart = 'STAMMSPIELER',
        @StammPosition = 3,
        @Spielberechtigt = 1,
        @Bemerkung = N'In der Live-Demo ueber Stored Procedure hinzugefuegt';
END
ELSE
BEGIN
    PRINT 'Spieler 990001 ist bereits der Demo-Mannschaft zugeordnet - Schritt wird uebersprungen.';
END;


/* ============================================================
   3. BEGEGNUNG ERFASSEN
   ============================================================ */

PRINT '';
PRINT 'SCHRITT 3: Ligabegegnung erfassen';
PRINT 'Procedure: sp_BegegnungErfassen';

DECLARE @BegegnungID BIGINT;

SELECT TOP (1)
    @BegegnungID = BegegnungID
FROM dbo.Begegnung
WHERE LigaphaseID = @LigaphaseID
  AND HeimMannschaftID = @MannschaftBernID
  AND GastMannschaftID = @MannschaftBaselID
  AND Datum = '2026-09-20'
  AND Runde = 1
ORDER BY BegegnungID;

IF @BegegnungID IS NULL
BEGIN
    EXEC dbo.sp_BegegnungErfassen
        @LigaphaseID = @LigaphaseID,
        @HeimMannschaftID = @MannschaftBernID,
        @GastMannschaftID = @MannschaftBaselID,
        @SpielortID = @SpielortBernID,
        @Runde = 1,
        @Datum = '2026-09-20',
        @Startzeit = '19:30:00',
        @Status = 'GEPLANT';

    SELECT TOP (1)
        @BegegnungID = BegegnungID
    FROM dbo.Begegnung
    WHERE LigaphaseID = @LigaphaseID
      AND HeimMannschaftID = @MannschaftBernID
      AND GastMannschaftID = @MannschaftBaselID
      AND Datum = '2026-09-20'
      AND Runde = 1
    ORDER BY BegegnungID DESC;
END
ELSE
BEGIN
    PRINT 'Demo-Begegnung existiert bereits - vorhandene Begegnung wird verwendet.';
END;


/* ============================================================
   4. AUFSTELLUNG UND EIN ELO-RELEVANTES EINZELSPIEL

   Fuer die Elo-Demo benoetigt sp_EloAktualisieren ein bereits
   abgeschlossenes Einzelspiel. Dieses fachliche Detailobjekt wird
   hier bewusst direkt erfasst; die sechs Projekt-Procedures
   enthalten keine eigene Procedure zum Erfassen eines Einzelspiels.
   ============================================================ */

PRINT '';
PRINT 'SCHRITT 4: Aufstellung und Einzelspiel vorbereiten';

IF NOT EXISTS
(
    SELECT 1 FROM dbo.Begegnungsaufstellung
    WHERE BegegnungID = @BegegnungID AND Position = 'A'
)
BEGIN
    INSERT INTO dbo.Begegnungsaufstellung
        (BegegnungID, MannschaftID, LizenzNr, Seite, Position)
    VALUES
        (@BegegnungID, @MannschaftBernID, 990001, 'HEIM', 'A');
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.Begegnungsaufstellung
    WHERE BegegnungID = @BegegnungID AND Position = 'B'
)
BEGIN
    INSERT INTO dbo.Begegnungsaufstellung
        (BegegnungID, MannschaftID, LizenzNr, Seite, Position)
    VALUES
        (@BegegnungID, @MannschaftBernID, 990002, 'HEIM', 'B');
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.Begegnungsaufstellung
    WHERE BegegnungID = @BegegnungID AND Position = 'C'
)
BEGIN
    INSERT INTO dbo.Begegnungsaufstellung
        (BegegnungID, MannschaftID, LizenzNr, Seite, Position)
    VALUES
        (@BegegnungID, @MannschaftBernID, 990004, 'HEIM', 'C');
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.Begegnungsaufstellung
    WHERE BegegnungID = @BegegnungID AND Position = 'X'
)
BEGIN
    INSERT INTO dbo.Begegnungsaufstellung
        (BegegnungID, MannschaftID, LizenzNr, Seite, Position)
    VALUES
        (@BegegnungID, @MannschaftBaselID, 990003, 'GAST', 'X');
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.Begegnungsaufstellung
    WHERE BegegnungID = @BegegnungID AND Position = 'Y'
)
BEGIN
    INSERT INTO dbo.Begegnungsaufstellung
        (BegegnungID, MannschaftID, LizenzNr, Seite, Position)
    VALUES
        (@BegegnungID, @MannschaftBaselID, 990005, 'GAST', 'Y');
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.Begegnungsaufstellung
    WHERE BegegnungID = @BegegnungID AND Position = 'Z'
)
BEGIN
    INSERT INTO dbo.Begegnungsaufstellung
        (BegegnungID, MannschaftID, LizenzNr, Seite, Position)
    VALUES
        (@BegegnungID, @MannschaftBaselID, 990006, 'GAST', 'Z');
END;

DECLARE @EinzelspielID BIGINT;

SELECT TOP (1)
    @EinzelspielID = EinzelspielID
FROM dbo.Einzelspiel
WHERE BegegnungID = @BegegnungID
  AND Spielcode = 'A-X'
ORDER BY EinzelspielID;

IF @EinzelspielID IS NULL
BEGIN
    INSERT INTO dbo.Einzelspiel
    (
        BegegnungID,
        TurnierKategorieID,
        Spielnummer,
        Spielcode,
        Spieler1Lizenz,
        Spieler2Lizenz,
        GewinnerLizenz,
        Spieldatum,
        SaetzeSpieler1,
        SaetzeSpieler2,
        PunkteSpieler1,
        PunkteSpieler2,
        Spielgrund,
        Status
    )
    VALUES
    (
        @BegegnungID,
        NULL,
        1,
        'A-X',
        990001,
        990003,
        990001,
        '2026-09-20T19:35:00',
        3,
        1,
        1,
        0,
        'REGULAER',
        'ABGESCHLOSSEN'
    );

    SET @EinzelspielID = SCOPE_IDENTITY();
END
ELSE
BEGIN
    PRINT 'Demo-Einzelspiel A-X existiert bereits - vorhandenes Spiel wird verwendet.';
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Satz
    WHERE EinzelspielID = @EinzelspielID
      AND SatzNummer = 1
)
BEGIN
    INSERT INTO dbo.Satz
        (EinzelspielID, DoppelspielID, SatzNummer, PunkteSeite1, PunkteSeite2)
    VALUES
        (@EinzelspielID, NULL, 1, 11, 8),
        (@EinzelspielID, NULL, 2, 9, 11),
        (@EinzelspielID, NULL, 3, 11, 7),
        (@EinzelspielID, NULL, 4, 11, 6);
END;


/* ============================================================
   5. BEGEGNUNGSRESULTAT ERFASSEN
   ============================================================ */

PRINT '';
PRINT 'SCHRITT 5: Begegnungsresultat erfassen';
PRINT 'Procedure: sp_BegegnungResultatErfassen';

IF EXISTS
(
    SELECT 1
    FROM dbo.Begegnung
    WHERE BegegnungID = @BegegnungID
      AND Status NOT IN ('GENEHMIGT', 'ANNULLIERT')
)
BEGIN
    EXEC dbo.sp_BegegnungResultatErfassen
        @BegegnungID = @BegegnungID,
        @SiegeHeim = 6,
        @SiegeGast = 4,
        @MannschaftspunkteHeim = 3,
        @MannschaftspunkteGast = 1,
        @SaetzeHeim = 22,
        @SaetzeGast = 17,
        @BaelleHeim = 392,
        @BaelleGast = 361,
        @Endzeit = '22:05:00',
        @ZuschauerAnzahl = 28,
        @SchiedsrichterName = N'Max Demo';
END;


/* ============================================================
   6. ELO FUER BEIDE SPIELER AKTUALISIEREN
   ============================================================ */

PRINT '';
PRINT 'SCHRITT 6: Elo-Aktualisierung';
PRINT 'Procedure: sp_EloAktualisieren';

IF NOT EXISTS
(
    SELECT 1 FROM dbo.EloProtokoll
    WHERE EinzelspielID = @EinzelspielID
      AND LizenzNr = 990001
)
BEGIN
    EXEC dbo.sp_EloAktualisieren
        @EinzelspielID = @EinzelspielID,
        @LizenzNr = 990001,
        @EloMonatslaufID = @EloMonatslaufID,
        @StichtagsElo = 1350.000,
        @GegnerStichtagsElo = 1385.000,
        @Gewinnwahrscheinlichkeit = 0.40060,
        @VorschauElo = 1359.590,
        @HerrenStufenwert = 10,
        @DamenStufenwert = NULL,
        @GueltigAb = '2026-10-01';
END
ELSE
BEGIN
    PRINT 'Elo fuer Spieler 990001 wurde fuer dieses Spiel bereits verarbeitet.';
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.EloProtokoll
    WHERE EinzelspielID = @EinzelspielID
      AND LizenzNr = 990003
)
BEGIN
    EXEC dbo.sp_EloAktualisieren
        @EinzelspielID = @EinzelspielID,
        @LizenzNr = 990003,
        @EloMonatslaufID = @EloMonatslaufID,
        @StichtagsElo = 1385.000,
        @GegnerStichtagsElo = 1350.000,
        @Gewinnwahrscheinlichkeit = 0.59940,
        @VorschauElo = 1375.410,
        @HerrenStufenwert = 10,
        @DamenStufenwert = NULL,
        @GueltigAb = '2026-10-01';
END
ELSE
BEGIN
    PRINT 'Elo fuer Spieler 990003 wurde fuer dieses Spiel bereits verarbeitet.';
END;


/* ============================================================
   7. TURNIER-EINZELANMELDUNG
   ============================================================ */

PRINT '';
PRINT 'SCHRITT 7: Spieler fuer Turnier anmelden';
PRINT 'Procedure: sp_TurnierEinzelAnmelden';

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Einzelanmeldung
    WHERE TurnierKategorieID = @TurnierKategorieID
      AND LizenzNr = 990001
)
BEGIN
    EXEC dbo.sp_TurnierEinzelAnmelden
        @TurnierKategorieID = @TurnierKategorieID,
        @LizenzNr = 990001;
END
ELSE
BEGIN
    PRINT 'Spieler 990001 ist bereits fuer die Demo-Turnierkategorie angemeldet.';
END;


/* ============================================================
   8. AUSWERTUNG DER GESCHAEFTSOBJEKTE
   ============================================================ */

PRINT '';
PRINT 'SCHRITT 8: Kontrollergebnisse';

SELECT
    ss.LizenzNr,
    s.Vorname,
    s.Nachname,
    sa.Bezeichnung AS Saison,
    ss.Alterskategorie,
    sv.VereinsNr,
    c.Clubname
FROM dbo.SpielerSaison AS ss
INNER JOIN dbo.Spieler AS s
    ON s.LizenzNr = ss.LizenzNr
INNER JOIN dbo.Saison AS sa
    ON sa.SaisonID = ss.SaisonID
LEFT JOIN dbo.SpielerVerein AS sv
    ON sv.LizenzNr = ss.LizenzNr
   AND sv.SaisonID = ss.SaisonID
   AND sv.Zuordnungsart = 'HAUPTVEREIN'
LEFT JOIN dbo.Club AS c
    ON c.VereinsNr = sv.VereinsNr
WHERE ss.LizenzNr = 990001
  AND ss.SaisonID = @SaisonID;

SELECT
    ms.MannschaftID,
    ms.LizenzNr,
    s.Vorname,
    s.Nachname,
    ms.Meldungsart,
    ms.StammPosition,
    ms.Spielberechtigt
FROM dbo.MannschaftSpieler AS ms
INNER JOIN dbo.Spieler AS s
    ON s.LizenzNr = ms.LizenzNr
WHERE ms.MannschaftID = @MannschaftBernID
ORDER BY ms.StammPosition, ms.LizenzNr;

SELECT
    BegegnungID,
    Datum,
    Startzeit,
    Endzeit,
    SiegeHeim,
    SiegeGast,
    MannschaftspunkteHeim,
    MannschaftspunkteGast,
    Status
FROM dbo.Begegnung
WHERE BegegnungID = @BegegnungID;

SELECT
    ep.EinzelspielID,
    ep.LizenzNr,
    ep.GegnerLizenzNr,
    ep.StichtagsElo,
    ep.GegnerStichtagsElo,
    ep.Gewinnwahrscheinlichkeit,
    ep.VorschauElo,
    se.EloDeltaZumVormonat
FROM dbo.EloProtokoll AS ep
INNER JOIN dbo.SpielerElo AS se
    ON se.LizenzNr = ep.LizenzNr
   AND se.EloMonatslaufID = ep.EloMonatslaufID
WHERE ep.EinzelspielID = @EinzelspielID
ORDER BY ep.LizenzNr;

SELECT
    ea.EinzelanmeldungID,
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
WHERE ea.TurnierKategorieID = @TurnierKategorieID
  AND ea.LizenzNr = 990001;


/* ============================================================
   9. PROJEKT-VIEWS
   ============================================================ */

PRINT '';
PRINT 'SCHRITT 9: Projekt-Views';

SELECT *
FROM dbo.vw_SpielerAktuell
WHERE LizenzNr BETWEEN 990001 AND 990006;

SELECT *
FROM dbo.vw_MannschaftenLiga
WHERE MannschaftID IN (@MannschaftBernID, @MannschaftBaselID);

SELECT *
FROM dbo.vw_BegegnungenUebersicht
WHERE BegegnungID = @BegegnungID;

SELECT *
FROM dbo.vw_Turnieranmeldungen
WHERE Spieler1LizenzNr = 990001;

SELECT *
FROM dbo.vw_Spielresultate
WHERE Spielart = 'EINZEL'
  AND SpielID = @EinzelspielID;


PRINT '';
PRINT '========================================';
PRINT 'DEMO ERFOLGREICH ABGESCHLOSSEN';
PRINT '========================================';
PRINT 'Gezeigt wurden:';
PRINT '- Spieleranmeldung';
PRINT '- Mannschaftszuordnung';
PRINT '- Begegnungserfassung';
PRINT '- Resultaterfassung';
PRINT '- Elo-Verarbeitung';
PRINT '- Turnieranmeldung';
PRINT '- Auswertung ueber Views';
PRINT '========================================';
GO
