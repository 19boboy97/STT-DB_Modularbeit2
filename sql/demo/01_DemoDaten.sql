/*
    Projekt: STT-DB Modulararbeit II
    Datei: 01_DemoDaten.sql

    Zweck:
    Erstellt eine kleine, zusammenhaengende Datenbasis fuer die
    Praesentation des Projekts.

    Voraussetzungen:
    - STT_DB wurde vollstaendig aufgebaut.
    - Seed-Daten wurden geladen.
    - Die Datei ist fuer die Entwicklungs-/Praesentationsdatenbank gedacht.

    Hinweis:
    Die eigentlichen Geschaeftsablaeufe mit Stored Procedures werden
    bewusst erst in 02_DemoAblauf.sql ausgefuehrt.
*/

USE STT_DB;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

PRINT '========================================';
PRINT 'STT-DB DEMODATEN';
PRINT '========================================';
GO

/* ============================================================
   1. BENÖTIGTE SEED-REFERENZEN
   ============================================================ */

DECLARE @RegionalverbandID INT =
(
    SELECT TOP (1) VerbandID
    FROM dbo.Verband
    WHERE Verbandstyp = 'REGIONAL'
      AND Aktiv = 1
    ORDER BY VerbandID
);

DECLARE @VerbandID INT =
(
    SELECT TOP (1) VerbandID
    FROM dbo.Verband
    WHERE Kurzname = 'STT'
      AND Aktiv = 1
    ORDER BY VerbandID
);

IF @VerbandID IS NULL
BEGIN
    SELECT TOP (1) @VerbandID = VerbandID
    FROM dbo.Verband
    WHERE Aktiv = 1
    ORDER BY VerbandID;
END;

DECLARE @SpielsystemID INT =
(
    SELECT TOP (1) SpielsystemID
    FROM dbo.Spielsystem
    WHERE Aktiv = 1
    ORDER BY SpielsystemID
);

DECLARE @BallID INT =
(
    SELECT TOP (1) BallID
    FROM dbo.Ball
    WHERE Aktiv = 1
    ORDER BY BallID
);

IF @RegionalverbandID IS NULL
    THROW 51001, 'Kein aktiver Regionalverband vorhanden. Zuerst Seed-Daten laden.', 1;

IF @VerbandID IS NULL
    THROW 51002, 'Kein aktiver Verband vorhanden. Zuerst Seed-Daten laden.', 1;

IF @SpielsystemID IS NULL
    THROW 51003, 'Kein aktives Spielsystem vorhanden. Zuerst Seed-Daten laden.', 1;

IF @BallID IS NULL
    THROW 51004, 'Kein aktiver Ball vorhanden. Zuerst Seed-Daten laden.', 1;


/* ============================================================
   2. DEMO-SAISON
   ============================================================ */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Saison
    WHERE Bezeichnung = N'DEMO 2026/27'
)
BEGIN
    INSERT INTO dbo.Saison
    (
        Bezeichnung,
        Startdatum,
        Enddatum,
        IstAktuell
    )
    VALUES
    (
        N'DEMO 2026/27',
        '2026-07-01',
        '2027-06-30',
        0
    );
END;

DECLARE @SaisonID INT =
(
    SELECT SaisonID
    FROM dbo.Saison
    WHERE Bezeichnung = N'DEMO 2026/27'
);


/* ============================================================
   3. DEMO-CLUBS
   ============================================================ */

IF NOT EXISTS (SELECT 1 FROM dbo.Club WHERE VereinsNr = 99001)
BEGIN
    INSERT INTO dbo.Club
    (
        VereinsNr,
        Clubname,
        Kurzname,
        RegionalverbandID,
        Gruendungsjahr,
        Webseite,
        Ort,
        Landcode,
        Aktiv
    )
    VALUES
    (
        99001,
        N'TTC Demo Bern',
        N'TTC Demo Bern',
        @RegionalverbandID,
        1985,
        N'https://example.invalid/demo-bern',
        N'Bern',
        'CH',
        1
    );
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Club WHERE VereinsNr = 99002)
BEGIN
    INSERT INTO dbo.Club
    (
        VereinsNr,
        Clubname,
        Kurzname,
        RegionalverbandID,
        Gruendungsjahr,
        Webseite,
        Ort,
        Landcode,
        Aktiv
    )
    VALUES
    (
        99002,
        N'TTC Demo Basel',
        N'TTC Demo Basel',
        @RegionalverbandID,
        1992,
        N'https://example.invalid/demo-basel',
        N'Basel',
        'CH',
        1
    );
END;


/* ============================================================
   4. SPIELORTE
   ============================================================ */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Spielort
    WHERE VereinsNr = 99001
      AND Bezeichnung = N'Demo Halle Bern'
)
BEGIN
    INSERT INTO dbo.Spielort
    (
        VereinsNr,
        Bezeichnung,
        Gebaeude,
        Strasse,
        Hausnummer,
        PLZ,
        Ort,
        Landcode,
        IstHauptspielort,
        Aktiv
    )
    VALUES
    (
        99001,
        N'Demo Halle Bern',
        N'Sportzentrum Demo',
        N'Musterstrasse',
        N'10',
        '3000',
        N'Bern',
        'CH',
        1,
        1
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Spielort
    WHERE VereinsNr = 99002
      AND Bezeichnung = N'Demo Halle Basel'
)
BEGIN
    INSERT INTO dbo.Spielort
    (
        VereinsNr,
        Bezeichnung,
        Gebaeude,
        Strasse,
        Hausnummer,
        PLZ,
        Ort,
        Landcode,
        IstHauptspielort,
        Aktiv
    )
    VALUES
    (
        99002,
        N'Demo Halle Basel',
        N'Turnhalle Demo',
        N'Beispielweg',
        N'5',
        '4000',
        N'Basel',
        'CH',
        1,
        1
    );
END;

DECLARE @SpielortBernID INT =
(
    SELECT SpielortID
    FROM dbo.Spielort
    WHERE VereinsNr = 99001
      AND Bezeichnung = N'Demo Halle Bern'
);


/* ============================================================
   5. SPIELER-STAMMDATEN
   ============================================================ */

IF NOT EXISTS (SELECT 1 FROM dbo.Spieler WHERE LizenzNr = 990001)
BEGIN
    INSERT INTO dbo.Spieler
        (LizenzNr, Vorname, Nachname, Geburtsdatum, Geschlecht, Aktiv)
    VALUES
        (990001, N'Leon', N'Berger', '1998-04-12', 'M', 1);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Spieler WHERE LizenzNr = 990002)
BEGIN
    INSERT INTO dbo.Spieler
        (LizenzNr, Vorname, Nachname, Geburtsdatum, Geschlecht, Aktiv)
    VALUES
        (990002, N'Marco', N'Keller', '1991-09-23', 'M', 1);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Spieler WHERE LizenzNr = 990003)
BEGIN
    INSERT INTO dbo.Spieler
        (LizenzNr, Vorname, Nachname, Geburtsdatum, Geschlecht, Aktiv)
    VALUES
        (990003, N'Daniel', N'Frei', '1994-02-08', 'M', 1);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Spieler WHERE LizenzNr = 990004)
BEGIN
    INSERT INTO dbo.Spieler
        (LizenzNr, Vorname, Nachname, Geburtsdatum, Geschlecht, Aktiv)
    VALUES
        (990004, N'Noah', N'Meier', '2000-11-17', 'M', 1);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Spieler WHERE LizenzNr = 990005)
BEGIN
    INSERT INTO dbo.Spieler
        (LizenzNr, Vorname, Nachname, Geburtsdatum, Geschlecht, Aktiv)
    VALUES
        (990005, N'Luca', N'Schmid', '1997-06-03', 'M', 1);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Spieler WHERE LizenzNr = 990006)
BEGIN
    INSERT INTO dbo.Spieler
        (LizenzNr, Vorname, Nachname, Geburtsdatum, Geschlecht, Aktiv)
    VALUES
        (990006, N'Jonas', N'Baumann', '1995-12-19', 'M', 1);
END;


/* ============================================================
   6. BASIS-SPIELER FUER DIE BEIDEN MANNSCHAFTEN

   Spieler 990001 wird absichtlich NICHT hier angemeldet.
   Seine Saison-/Vereinsanmeldung wird live in 02_DemoAblauf.sql
   ueber sp_SpielerAnmelden demonstriert.
   ============================================================ */

IF NOT EXISTS
(
    SELECT 1 FROM dbo.SpielerSaison
    WHERE LizenzNr = 990002 AND SaisonID = @SaisonID
)
BEGIN
    INSERT INTO dbo.SpielerSaison
        (LizenzNr, SaisonID, Alterskategorie, LizenzAktiv)
    VALUES
        (990002, @SaisonID, 'Aktive', 1);
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.SpielerSaison
    WHERE LizenzNr = 990003 AND SaisonID = @SaisonID
)
BEGIN
    INSERT INTO dbo.SpielerSaison
        (LizenzNr, SaisonID, Alterskategorie, LizenzAktiv)
    VALUES
        (990003, @SaisonID, 'Aktive', 1);
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.SpielerSaison
    WHERE LizenzNr = 990004 AND SaisonID = @SaisonID
)
BEGIN
    INSERT INTO dbo.SpielerSaison
        (LizenzNr, SaisonID, Alterskategorie, LizenzAktiv)
    VALUES
        (990004, @SaisonID, 'Aktive', 1);
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.SpielerSaison
    WHERE LizenzNr = 990005 AND SaisonID = @SaisonID
)
BEGIN
    INSERT INTO dbo.SpielerSaison
        (LizenzNr, SaisonID, Alterskategorie, LizenzAktiv)
    VALUES
        (990005, @SaisonID, 'Aktive', 1);
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.SpielerSaison
    WHERE LizenzNr = 990006 AND SaisonID = @SaisonID
)
BEGIN
    INSERT INTO dbo.SpielerSaison
        (LizenzNr, SaisonID, Alterskategorie, LizenzAktiv)
    VALUES
        (990006, @SaisonID, 'Aktive', 1);
END;


IF NOT EXISTS
(
    SELECT 1 FROM dbo.SpielerVerein
    WHERE LizenzNr = 990002
      AND SaisonID = @SaisonID
      AND Zuordnungsart = 'HAUPTVEREIN'
)
BEGIN
    INSERT INTO dbo.SpielerVerein
        (LizenzNr, SaisonID, VereinsNr, Zuordnungsart, Wettbewerbsbereich)
    VALUES
        (990002, @SaisonID, 99001, 'HAUPTVEREIN', 'ALLE');
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.SpielerVerein
    WHERE LizenzNr = 990003
      AND SaisonID = @SaisonID
      AND Zuordnungsart = 'HAUPTVEREIN'
)
BEGIN
    INSERT INTO dbo.SpielerVerein
        (LizenzNr, SaisonID, VereinsNr, Zuordnungsart, Wettbewerbsbereich)
    VALUES
        (990003, @SaisonID, 99002, 'HAUPTVEREIN', 'ALLE');
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.SpielerVerein
    WHERE LizenzNr = 990004
      AND SaisonID = @SaisonID
      AND Zuordnungsart = 'HAUPTVEREIN'
)
BEGIN
    INSERT INTO dbo.SpielerVerein
        (LizenzNr, SaisonID, VereinsNr, Zuordnungsart, Wettbewerbsbereich)
    VALUES
        (990004, @SaisonID, 99001, 'HAUPTVEREIN', 'ALLE');
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.SpielerVerein
    WHERE LizenzNr = 990005
      AND SaisonID = @SaisonID
      AND Zuordnungsart = 'HAUPTVEREIN'
)
BEGIN
    INSERT INTO dbo.SpielerVerein
        (LizenzNr, SaisonID, VereinsNr, Zuordnungsart, Wettbewerbsbereich)
    VALUES
        (990005, @SaisonID, 99002, 'HAUPTVEREIN', 'ALLE');
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.SpielerVerein
    WHERE LizenzNr = 990006
      AND SaisonID = @SaisonID
      AND Zuordnungsart = 'HAUPTVEREIN'
)
BEGIN
    INSERT INTO dbo.SpielerVerein
        (LizenzNr, SaisonID, VereinsNr, Zuordnungsart, Wettbewerbsbereich)
    VALUES
        (990006, @SaisonID, 99002, 'HAUPTVEREIN', 'ALLE');
END;


/* ============================================================
   7. BEWERTUNGSPERIODE
   ============================================================ */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Bewertungsperiode
    WHERE SaisonID = @SaisonID
      AND Bezeichnung = 'SAISONBEGINN'
)
BEGIN
    INSERT INTO dbo.Bewertungsperiode
    (
        SaisonID,
        Bezeichnung,
        Stichtag,
        GueltigAb,
        GueltigBis
    )
    VALUES
    (
        @SaisonID,
        'SAISONBEGINN',
        '2026-07-01',
        '2026-07-01',
        '2026-12-31'
    );
END;

DECLARE @BewertungsperiodeID INT =
(
    SELECT BewertungsperiodeID
    FROM dbo.Bewertungsperiode
    WHERE SaisonID = @SaisonID
      AND Bezeichnung = 'SAISONBEGINN'
);


/* ============================================================
   8. SPIELERBEWERTUNGEN

   Alle Spieler erhalten einen plausiblen Ausgangswert.
   ============================================================ */

IF NOT EXISTS
(
    SELECT 1 FROM dbo.SpielerBewertung
    WHERE LizenzNr = 990001
      AND BewertungsperiodeID = @BewertungsperiodeID
)
BEGIN
    INSERT INTO dbo.SpielerBewertung
        (LizenzNr, BewertungsperiodeID, Elo, HerrenStufenwert, DamenStufenwert, Alterskategorie)
    VALUES
        (990001, @BewertungsperiodeID, 1350.000, 10, NULL, 'Aktive');
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.SpielerBewertung
    WHERE LizenzNr = 990002
      AND BewertungsperiodeID = @BewertungsperiodeID
)
BEGIN
    INSERT INTO dbo.SpielerBewertung
        (LizenzNr, BewertungsperiodeID, Elo, HerrenStufenwert, DamenStufenwert, Alterskategorie)
    VALUES
        (990002, @BewertungsperiodeID, 1420.000, 11, NULL, 'Aktive');
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.SpielerBewertung
    WHERE LizenzNr = 990003
      AND BewertungsperiodeID = @BewertungsperiodeID
)
BEGIN
    INSERT INTO dbo.SpielerBewertung
        (LizenzNr, BewertungsperiodeID, Elo, HerrenStufenwert, DamenStufenwert, Alterskategorie)
    VALUES
        (990003, @BewertungsperiodeID, 1385.000, 10, NULL, 'Aktive');
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.SpielerBewertung
    WHERE LizenzNr = 990004
      AND BewertungsperiodeID = @BewertungsperiodeID
)
BEGIN
    INSERT INTO dbo.SpielerBewertung
        (LizenzNr, BewertungsperiodeID, Elo, HerrenStufenwert, DamenStufenwert, Alterskategorie)
    VALUES
        (990004, @BewertungsperiodeID, 1290.000, 9, NULL, 'Aktive');
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.SpielerBewertung
    WHERE LizenzNr = 990005
      AND BewertungsperiodeID = @BewertungsperiodeID
)
BEGIN
    INSERT INTO dbo.SpielerBewertung
        (LizenzNr, BewertungsperiodeID, Elo, HerrenStufenwert, DamenStufenwert, Alterskategorie)
    VALUES
        (990005, @BewertungsperiodeID, 1325.000, 9, NULL, 'Aktive');
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.SpielerBewertung
    WHERE LizenzNr = 990006
      AND BewertungsperiodeID = @BewertungsperiodeID
)
BEGIN
    INSERT INTO dbo.SpielerBewertung
        (LizenzNr, BewertungsperiodeID, Elo, HerrenStufenwert, DamenStufenwert, Alterskategorie)
    VALUES
        (990006, @BewertungsperiodeID, 1270.000, 8, NULL, 'Aktive');
END;


/* ============================================================
   9. LIGAWETTBEWERB UND LIGAPHASE
   ============================================================ */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Ligawettbewerb
    WHERE SaisonID = @SaisonID
      AND VerbandID = @VerbandID
      AND Bezeichnung = N'Demo Liga'
      AND Geschlechtskategorie = 'HERREN'
      AND Alterskategorie = 'Aktive'
)
BEGIN
    INSERT INTO dbo.Ligawettbewerb
    (
        SaisonID,
        VerbandID,
        Bezeichnung,
        Geschlechtskategorie,
        Alterskategorie,
        SpielsystemID,
        Aktiv
    )
    VALUES
    (
        @SaisonID,
        @VerbandID,
        N'Demo Liga',
        'HERREN',
        'Aktive',
        @SpielsystemID,
        1
    );
END;

DECLARE @LigawettbewerbID INT =
(
    SELECT TOP (1) LigawettbewerbID
    FROM dbo.Ligawettbewerb
    WHERE SaisonID = @SaisonID
      AND VerbandID = @VerbandID
      AND Bezeichnung = N'Demo Liga'
      AND Geschlechtskategorie = 'HERREN'
      AND Alterskategorie = 'Aktive'
    ORDER BY LigawettbewerbID
);

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Ligaphase
    WHERE LigawettbewerbID = @LigawettbewerbID
      AND Bezeichnung = N'Demo Hauptrunde'
)
BEGIN
    INSERT INTO dbo.Ligaphase
    (
        LigawettbewerbID,
        Bezeichnung,
        Phasentyp,
        Gruppenbezeichnung,
        KlassenleiterBenutzerID,
        Aktiv
    )
    VALUES
    (
        @LigawettbewerbID,
        N'Demo Hauptrunde',
        'HAUPTRUNDE',
        N'Gruppe Demo',
        NULL,
        1
    );
END;

DECLARE @LigaphaseID INT =
(
    SELECT LigaphaseID
    FROM dbo.Ligaphase
    WHERE LigawettbewerbID = @LigawettbewerbID
      AND Bezeichnung = N'Demo Hauptrunde'
);


/* ============================================================
   10. MANNSCHAFTEN
   ============================================================ */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Mannschaft
    WHERE LigaphaseID = @LigaphaseID
      AND VereinsNr = 99001
      AND MannschaftNummer = 1
)
BEGIN
    INSERT INTO dbo.Mannschaft
    (
        VereinsNr,
        LigaphaseID,
        MannschaftNummer,
        KapitaenLizenz,
        BallID,
        Aktiv
    )
    VALUES
    (
        99001,
        @LigaphaseID,
        1,
        990002,
        @BallID,
        1
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Mannschaft
    WHERE LigaphaseID = @LigaphaseID
      AND VereinsNr = 99002
      AND MannschaftNummer = 1
)
BEGIN
    INSERT INTO dbo.Mannschaft
    (
        VereinsNr,
        LigaphaseID,
        MannschaftNummer,
        KapitaenLizenz,
        BallID,
        Aktiv
    )
    VALUES
    (
        99002,
        @LigaphaseID,
        1,
        990003,
        @BallID,
        1
    );
END;

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


/* ============================================================
   11. BASIS-MANNSCHAFTSSPIELER

   990001 bleibt absichtlich frei fuer die Live-Demo.
   ============================================================ */

IF NOT EXISTS
(
    SELECT 1 FROM dbo.MannschaftSpieler
    WHERE MannschaftID = @MannschaftBernID
      AND LizenzNr = 990002
)
BEGIN
    INSERT INTO dbo.MannschaftSpieler
        (MannschaftID, LizenzNr, Meldungsart, StammPosition, Spielberechtigt, Bemerkung)
    VALUES
        (@MannschaftBernID, 990002, 'STAMMSPIELER', 1, 1, N'Demo-Kapitaen');
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.MannschaftSpieler
    WHERE MannschaftID = @MannschaftBernID
      AND LizenzNr = 990004
)
BEGIN
    INSERT INTO dbo.MannschaftSpieler
        (MannschaftID, LizenzNr, Meldungsart, StammPosition, Spielberechtigt, Bemerkung)
    VALUES
        (@MannschaftBernID, 990004, 'STAMMSPIELER', 2, 1, N'Demo-Stammspieler');
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.MannschaftSpieler
    WHERE MannschaftID = @MannschaftBaselID
      AND LizenzNr = 990003
)
BEGIN
    INSERT INTO dbo.MannschaftSpieler
        (MannschaftID, LizenzNr, Meldungsart, StammPosition, Spielberechtigt, Bemerkung)
    VALUES
        (@MannschaftBaselID, 990003, 'STAMMSPIELER', 1, 1, N'Demo-Kapitaen');
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.MannschaftSpieler
    WHERE MannschaftID = @MannschaftBaselID
      AND LizenzNr = 990005
)
BEGIN
    INSERT INTO dbo.MannschaftSpieler
        (MannschaftID, LizenzNr, Meldungsart, StammPosition, Spielberechtigt, Bemerkung)
    VALUES
        (@MannschaftBaselID, 990005, 'STAMMSPIELER', 2, 1, N'Demo-Stammspieler');
END;

IF NOT EXISTS
(
    SELECT 1 FROM dbo.MannschaftSpieler
    WHERE MannschaftID = @MannschaftBaselID
      AND LizenzNr = 990006
)
BEGIN
    INSERT INTO dbo.MannschaftSpieler
        (MannschaftID, LizenzNr, Meldungsart, StammPosition, Spielberechtigt, Bemerkung)
    VALUES
        (@MannschaftBaselID, 990006, 'STAMMSPIELER', 3, 1, N'Demo-Stammspieler');
END;


/* ============================================================
   12. TURNIER UND OFFENE EINZELKATEGORIE
   ============================================================ */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Turnier
    WHERE SaisonID = @SaisonID
      AND Turniername = N'STT Demo Open 2026'
)
BEGIN
    INSERT INTO dbo.Turnier
    (
        SaisonID,
        BewertungsperiodeID,
        Turniername,
        VeranstalterNr,
        SpielortID,
        Startdatum,
        Enddatum,
        Meldeschluss,
        HallenSchiedsrichterName,
        Status
    )
    VALUES
    (
        @SaisonID,
        @BewertungsperiodeID,
        N'STT Demo Open 2026',
        99001,
        @SpielortBernID,
        '2026-12-12',
        '2026-12-12',
        '2026-12-01T23:59:59',
        N'Demo Schiedsrichter',
        'OFFEN'
    );
END;

DECLARE @TurnierID INT =
(
    SELECT TurnierID
    FROM dbo.Turnier
    WHERE SaisonID = @SaisonID
      AND Turniername = N'STT Demo Open 2026'
);

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TurnierKategorie
    WHERE TurnierID = @TurnierID
      AND Bezeichnung = N'Open Einzel Demo'
)
BEGIN
    INSERT INTO dbo.TurnierKategorie
    (
        TurnierID,
        Bezeichnung,
        Kategorieart,
        Wettkampfform,
        Geschlechtskategorie,
        VerwendeteKlassierungsart,
        Alterskategorie,
        Altersregel,
        BevorzugePassendeKategorie,
        MinStufenwert,
        MaxStufenwert,
        AlleSpielerMuessenKlassierungErfuellen,
        MinEloWert,
        TopEloWert,
        AlleSpielerMuessenEloErfuellen,
        SpielerProTeam,
        MinKlassierungSumme,
        MaxKlassierungSumme,
        MinEloSumme,
        MaxEloSumme,
        Gewinnsaetze,
        Status
    )
    VALUES
    (
        @TurnierID,
        N'Open Einzel Demo',
        'OFFEN',
        'EINZEL',
        'OFFEN',
        NULL,
        NULL,
        'ALLE',
        1,
        NULL,
        NULL,
        1,
        NULL,
        NULL,
        1,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        3,
        'OFFEN'
    );
END;


/* ============================================================
   13. ELO-MONATSLAUF FUER DIE LIVE-DEMO
   ============================================================ */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.EloMonatslauf
    WHERE Berechnungsdatum = '2026-09-30'
)
BEGIN
    INSERT INTO dbo.EloMonatslauf
    (
        Berechnungsdatum,
        PeriodeVon,
        PeriodeBis,
        Status,
        GestartetAm,
        AbgeschlossenAm,
        Bemerkung
    )
    VALUES
    (
        '2026-09-30',
        '2026-09-01',
        '2026-09-30',
        'LAUFEND',
        SYSDATETIME(),
        NULL,
        N'Demo-Monatslauf fuer die Praesentation'
    );
END;


/* ============================================================
   14. KONTROLLAUSGABE
   ============================================================ */

PRINT '';
PRINT 'Demo-Grunddaten wurden vorbereitet.';
PRINT 'Spieler 990001 ist absichtlich noch nicht fuer die Demo-Saison angemeldet.';
PRINT 'Die eigentlichen Ablaufschritte folgen in 02_DemoAblauf.sql.';
PRINT '';

SELECT
    @SaisonID AS SaisonID,
    @LigawettbewerbID AS LigawettbewerbID,
    @LigaphaseID AS LigaphaseID,
    @MannschaftBernID AS MannschaftBernID,
    @MannschaftBaselID AS MannschaftBaselID,
    @TurnierID AS TurnierID,
    @BewertungsperiodeID AS BewertungsperiodeID;

SELECT
    LizenzNr,
    Vorname,
    Nachname,
    Aktiv
FROM dbo.Spieler
WHERE LizenzNr BETWEEN 990001 AND 990006
ORDER BY LizenzNr;

SELECT
    m.MannschaftID,
    c.Clubname,
    m.MannschaftNummer,
    m.KapitaenLizenz
FROM dbo.Mannschaft AS m
INNER JOIN dbo.Club AS c
    ON c.VereinsNr = m.VereinsNr
WHERE m.MannschaftID IN (@MannschaftBernID, @MannschaftBaselID)
ORDER BY c.Clubname;

PRINT '========================================';
PRINT '01_DemoDaten.sql erfolgreich beendet';
PRINT '========================================';
GO
