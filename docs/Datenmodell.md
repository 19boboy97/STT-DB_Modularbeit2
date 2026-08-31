# Datenmodell

## 1. Überblick

Das Datenmodell bildet zentrale Bereiche eines Verwaltungssystems für
Swiss Table Tennis ab. Der finale Implementierungsstand umfasst 39
Tabellen. Die Tabellen sind thematisch in Stammdaten, Spieler- und
Vereinsdaten, Elo und Klassierung, Benutzer und Funktionen, Ligabetrieb,
Begegnungen, Turniere sowie Spielresultate gegliedert.

Die technische Referenz für dieses Dokument sind die finalen
`CREATE TABLE`-Skripte im Ordner `sql/tables`. Detailregeln zu
Primärschlüsseln, Fremdschlüsseln, UNIQUE-Regeln und CHECK-Constraints
werden zusätzlich in `Constraints.md` dokumentiert.

## 2. Modellierungsgrundsätze

Das Modell folgt folgenden Grundsätzen:

-   dauerhafte Stammdaten werden von saison- oder periodenabhängigen
    Daten getrennt;
-   Primär- und Fremdschlüssel sichern die referenzielle Integrität;
-   fachlich begrenzte Wertebereiche werden soweit möglich durch
    CHECK-Constraints abgesichert;
-   Eindeutigkeitsregeln werden durch UNIQUE-Constraints oder gefilterte
    UNIQUE-Indizes umgesetzt;
-   historische Elo- und Bewertungsstände werden separat gespeichert;
-   Einzel- und Doppelspiele können entweder aus einer Ligabegegnung
    oder aus einer Turnierkategorie stammen;
-   Turniermannschaften sind nicht fest an einen Club gebunden;
-   berechenbare Auswertungen werden nicht unnötig als redundante
    Stammdaten gespeichert.

------------------------------------------------------------------------

## 3. Stammdaten

### 3.1 Saison

**Zweck:** Speichert die einzelnen Spielsaisons.

  Feld          Datentyp         NULL Bedeutung
  ------------- -------------- ------ ----------------------------------
  SaisonID      INT IDENTITY     Nein Primärschlüssel
  Bezeichnung   NVARCHAR(20)     Nein Bezeichnung der Saison
  Startdatum    DATE             Nein Beginn der Saison
  Enddatum      DATE             Nein Ende der Saison
  IstAktuell    BIT              Nein Kennzeichnet die aktuelle Saison

Die Saisonbezeichnung ist eindeutig. Das Enddatum muss nach dem
Startdatum liegen. Durch einen gefilterten UNIQUE-Index kann höchstens
eine Saison als aktuell markiert sein.

### 3.2 Verband

**Zweck:** Speichert Swiss Table Tennis sowie die Regionalverbände.

  Feld                       Datentyp          NULL Bedeutung
  -------------------------- --------------- ------ ----------------------------
  VerbandID                  INT IDENTITY      Nein Primärschlüssel
  Kurzname                   VARCHAR(10)       Nein Kurzbezeichnung
  Name                       NVARCHAR(150)     Nein Vollständiger Name
  Verbandstyp                VARCHAR(10)       Nein `NATIONAL` oder `REGIONAL`
  UebergeordneterVerbandID   INT                 Ja Übergeordneter Verband
  Gruendungsdatum            DATE                Ja Gründungsdatum
  Webseite                   NVARCHAR(255)       Ja Webseite
  Aktiv                      BIT               Nein Aktivstatus

Ein nationaler Verband besitzt keinen übergeordneten Verband. Ein
Regionalverband muss einem übergeordneten Verband zugeordnet sein.

### 3.3 Alterskategorie

**Zweck:** Definiert Alterskategorien eines Spielers.

  Feld          Datentyp        NULL Bedeutung
  ------------- ------------- ------ -----------------------------------------
  Bezeichnung   VARCHAR(10)     Nein Primärschlüssel, z. B. `U15`
  MinAlter      TINYINT         Nein Mindestalter
  MaxAlter      TINYINT           Ja Höchstalter; NULL für offene Obergrenze

Die Alterskategorie beschreibt das Alter eines Spielers und ist nicht
automatisch mit der Teilnahmeberechtigung eines Wettbewerbs
gleichzusetzen.

### 3.4 Klassierungsstufe

**Zweck:** Speichert die möglichen Klassierungsstufen von D1 bis A22.

  Feld          Datentyp       NULL Bedeutung
  ------------- ------------ ------ ------------------------------------
  Stufenwert    TINYINT        Nein Primärschlüssel, Werte 1 bis 22
  Bezeichnung   VARCHAR(3)     Nein Eindeutige Klassierungsbezeichnung

### 3.5 Club

**Zweck:** Speichert Tischtennisclubs und deren
Regionalverbandszugehörigkeit.

  Feld                Datentyp          NULL Bedeutung
  ------------------- --------------- ------ -----------------------------
  VereinsNr           INT               Nein Primärschlüssel
  Clubname            NVARCHAR(150)     Nein Clubname
  Kurzname            NVARCHAR(50)        Ja Kurzbezeichnung
  RegionalverbandID   INT               Nein Zugehöriger Regionalverband
  Gruendungsjahr      SMALLINT            Ja Gründungsjahr
  Webseite            NVARCHAR(255)       Ja Webseite
  Ort                 NVARCHAR(100)       Ja Ort
  Landcode            CHAR(2)           Nein Ländercode, Standard `CH`
  Aktiv               BIT               Nein Aktivstatus

### 3.6 Spielort

**Zweck:** Speichert die Spiellokale eines Clubs.

  Feld               Datentyp          NULL Bedeutung
  ------------------ --------------- ------ -------------------------
  SpielortID         INT IDENTITY      Nein Primärschlüssel
  VereinsNr          INT               Nein Zugehöriger Club
  Bezeichnung        NVARCHAR(100)     Nein Bezeichnung
  Gebaeude           NVARCHAR(150)       Ja Gebäude
  Strasse            NVARCHAR(100)     Nein Strasse
  Hausnummer         NVARCHAR(10)      Nein Hausnummer
  PLZ                CHAR(4)           Nein Postleitzahl
  Ort                NVARCHAR(100)     Nein Ort
  Landcode           CHAR(2)           Nein Ländercode
  IstHauptspielort   BIT               Nein Hauptspielort des Clubs
  Aktiv              BIT               Nein Aktivstatus

Pro Club darf höchstens ein aktiver Hauptspielort existieren.

------------------------------------------------------------------------

## 4. Spieler, Saison und Vereinszugehörigkeit

### 4.1 Spieler

**Zweck:** Speichert langfristige Stammdaten eines Spielers.

  Feld           Datentyp         NULL Bedeutung
  -------------- -------------- ------ ----------------------------------------
  LizenzNr       INT              Nein Lebenslang eindeutiger Primärschlüssel
  Vorname        NVARCHAR(80)     Nein Vorname
  Nachname       NVARCHAR(80)     Nein Nachname
  Geburtsdatum   DATE             Nein Geburtsdatum
  Geschlecht     CHAR(1)          Nein `M` oder `W`
  Aktiv          BIT              Nein Aktivstatus

### 4.2 SpielerSaison

**Zweck:** Speichert saisonabhängige Eigenschaften eines Spielers.

  --------------------------------------------------------------------------
  Feld              Datentyp                          NULL Bedeutung
  ----------------- ---------------- --------------------- -----------------
  LizenzNr          INT                               Nein Spieler

  SaisonID          INT                               Nein Saison

  Alterskategorie   VARCHAR(10)                       Nein Feste
                                                           Alterskategorie
                                                           der Saison

  LizenzAktiv       BIT                               Nein Lizenzstatus in
                                                           der Saison
  --------------------------------------------------------------------------

Der zusammengesetzte Primärschlüssel besteht aus `LizenzNr` und
`SaisonID`.

### 4.3 SpielerVerein

**Zweck:** Speichert die Vereinszuordnung eines Spielers innerhalb einer
Saison.

  --------------------------------------------------------------------------------
  Feld                 Datentyp                          NULL Bedeutung
  -------------------- ---------------- --------------------- --------------------
  SpielerVereinID      BIGINT IDENTITY                   Nein Primärschlüssel

  LizenzNr             INT                               Nein Spieler

  SaisonID             INT                               Nein Saison

  VereinsNr            INT                               Nein Club

  Zuordnungsart        VARCHAR(20)                       Nein `HAUPTVEREIN` oder
                                                              `MEHRFACHLIZENZ`

  Wettbewerbsbereich   VARCHAR(20)                       Nein Gültigkeitsbereich
  --------------------------------------------------------------------------------

Mögliche Wettbewerbsbereiche sind `ALLE`, `HERREN`, `DAMEN`, `NACHWUCHS`
und `SENIOREN`. Pro Spieler und Saison darf nur ein Hauptverein
existieren.

------------------------------------------------------------------------

## 5. Elo und Klassierungen

### 5.1 Bewertungsperiode

**Zweck:** Speichert die offiziellen Bewertungsstände innerhalb einer
Saison.

  Feld                  Datentyp         NULL Bedeutung
  --------------------- -------------- ------ -----------------------------------
  BewertungsperiodeID   INT IDENTITY     Nein Primärschlüssel
  SaisonID              INT              Nein Saison
  Bezeichnung           VARCHAR(20)      Nein `SAISONBEGINN` oder `SAISONMITTE`
  Stichtag              DATE             Nein Bewertungsstichtag
  GueltigAb             DATE             Nein Beginn der Gültigkeit
  GueltigBis            DATE             Nein Ende der Gültigkeit

### 5.2 Klassierungsgrenze

**Zweck:** Ordnet Elo-Bereiche einer Klassierungsstufe zu.

  Feld                   Datentyp          NULL Bedeutung
  ---------------------- --------------- ------ -----------------------
  KlassierungsgrenzeID   INT IDENTITY      Nein Primärschlüssel
  BewertungsperiodeID    INT               Nein Bewertungsperiode
  Stufenwert             TINYINT           Nein Klassierungsstufe
  Klassierungsart        VARCHAR(10)       Nein `HERREN` oder `DAMEN`
  MinElo                 DECIMAL(10,3)       Ja Untere Grenze
  MittelElo              DECIMAL(10,3)       Ja Mittelwert
  MaxElo                 DECIMAL(10,3)       Ja Obere Grenze

### 5.3 SpielerBewertung

**Zweck:** Speichert offizielle halbjährliche Bewertungswerte eines
Spielers.

  Feld                  Datentyp            NULL Bedeutung
  --------------------- ----------------- ------ ----------------------
  SpielerBewertungID    BIGINT IDENTITY     Nein Primärschlüssel
  LizenzNr              INT                 Nein Spieler
  BewertungsperiodeID   INT                 Nein Bewertungsperiode
  Elo                   DECIMAL(10,3)       Nein Elo-Wert
  HerrenStufenwert      TINYINT             Nein Herrenklassierung
  DamenStufenwert       TINYINT               Ja Damenklassierung
  Alterskategorie       VARCHAR(10)         Nein Alterskategorie
  ErstelltAm            DATETIME2(0)        Nein Erstellungszeitpunkt

Pro Spieler und Bewertungsperiode ist nur ein Bewertungsdatensatz
zulässig.

### 5.4 EloMonatslauf

**Zweck:** Speichert monatliche offizielle Elo-Berechnungsläufe.

  Feld               Datentyp            NULL Bedeutung
  ------------------ ----------------- ------ ---------------------------------------
  EloMonatslaufID    BIGINT IDENTITY     Nein Primärschlüssel
  Berechnungsdatum   DATE                Nein Berechnungsdatum
  PeriodeVon         DATE                Nein Beginn des berücksichtigten Zeitraums
  PeriodeBis         DATE                Nein Ende des Zeitraums
  Status             VARCHAR(20)         Nein Status des Laufs
  GestartetAm        DATETIME2(0)          Ja Startzeitpunkt
  AbgeschlossenAm    DATETIME2(0)          Ja Abschlusszeitpunkt
  Bemerkung          NVARCHAR(500)         Ja Bemerkung

Mögliche Statuswerte sind `GEPLANT`, `LAUFEND`, `ABGESCHLOSSEN` und
`FEHLER`.

### 5.5 SpielerElo

**Zweck:** Speichert die offiziellen monatlichen Elo-Stände eines
Spielers.

  Feld                  Datentyp            NULL Bedeutung
  --------------------- ----------------- ------ -----------------------
  SpielerEloID          BIGINT IDENTITY     Nein Primärschlüssel
  LizenzNr              INT                 Nein Spieler
  EloMonatslaufID       BIGINT              Nein Monatslauf
  Elo                   DECIMAL(10,3)       Nein Elo-Wert
  EloDeltaZumVormonat   DECIMAL(10,3)         Ja Veränderung
  HerrenStufenwert      TINYINT             Nein Herrenklassierung
  DamenStufenwert       TINYINT               Ja Damenklassierung
  HerrenRang            INT                   Ja Herrenrang
  Gesamtrang            INT                   Ja Gesamtrang
  GueltigAb             DATE                Nein Beginn der Gültigkeit
  GueltigBis            DATE                  Ja Ende der Gültigkeit

### 5.6 EloProtokoll

**Zweck:** Protokolliert die Elo-Berechnung eines Spielers für ein
einzelnes Elo-relevantes Einzelspiel.

  ----------------------------------------------------------------------------------------
  Feld                       Datentyp                          NULL Bedeutung
  -------------------------- ---------------- --------------------- ----------------------
  EloProtokollID             BIGINT IDENTITY                   Nein Primärschlüssel

  EinzelspielID              BIGINT                            Nein Einzelspiel

  LizenzNr                   INT                               Nein Spieler

  GegnerLizenzNr             INT                               Nein Gegner

  EloMonatslaufID            BIGINT                            Nein Monatslauf

  StichtagsElo               DECIMAL(10,3)                     Nein Elo des Spielers vor
                                                                    Berechnung

  GegnerStichtagsElo         DECIMAL(10,3)                     Nein Elo des Gegners

  Gewinnwahrscheinlichkeit   DECIMAL(6,5)                      Nein Berechnete
                                                                    Wahrscheinlichkeit

  VorschauElo                DECIMAL(10,3)                     Nein Berechneter neuer
                                                                    Elo-Wert

  ErstelltAm                 DATETIME2(0)                      Nein Erstellungszeitpunkt
  ----------------------------------------------------------------------------------------

Für ein Einzelspiel und einen Spieler ist nur ein Protokolleintrag
zulässig. Normalerweise entstehen für ein Elo-relevantes Einzelspiel
zwei Einträge. Doppelspiele sind nicht Elo-relevant.

------------------------------------------------------------------------

## 6. Vereinsfunktionen und Benutzer

### 6.1 Funktion

**Zweck:** Speichert mögliche Funktionen innerhalb eines Clubs.

  Feld          Datentyp          NULL Bedeutung
  ------------- --------------- ------ ---------------------------------
  FunktionID    INT IDENTITY      Nein Primärschlüssel
  Bezeichnung   NVARCHAR(100)     Nein Eindeutige Funktionsbezeichnung
  Aktiv         BIT               Nein Aktivstatus

### 6.2 Vereinsfunktionaer

**Zweck:** Speichert Kontaktpersonen eines Clubs. Ein Funktionär muss
kein lizenzierter Spieler sein.

  Feld            Datentyp          NULL Bedeutung
  --------------- --------------- ------ -----------------
  FunktionaerID   INT IDENTITY      Nein Primärschlüssel
  VereinsNr       INT               Nein Club
  Vorname         NVARCHAR(80)      Nein Vorname
  Nachname        NVARCHAR(80)      Nein Nachname
  Email           NVARCHAR(255)       Ja E-Mail
  TelefonPrivat   NVARCHAR(30)        Ja Privattelefon
  TelefonMobil    NVARCHAR(30)        Ja Mobiltelefon
  Strasse         NVARCHAR(100)       Ja Strasse
  Hausnummer      NVARCHAR(10)        Ja Hausnummer
  PLZ             CHAR(4)             Ja Postleitzahl
  Ort             NVARCHAR(100)       Ja Ort
  Aktiv           BIT               Nein Aktivstatus

### 6.3 FunktionaerFunktion

**Zweck:** Verknüpft Vereinsfunktionäre mit ihren Funktionen.

  Feld            Datentyp     NULL Bedeutung
  --------------- ---------- ------ -----------------------
  FunktionaerID   INT          Nein Funktionär
  FunktionID      INT          Nein Funktion
  GueltigAb       DATE         Nein Beginn der Gültigkeit
  GueltigBis      DATE           Ja Ende der Gültigkeit

Der Primärschlüssel besteht aus `FunktionaerID`, `FunktionID` und
`GueltigAb`.

### 6.4 Benutzer

**Zweck:** Speichert Benutzerkonten für die Verwaltung.

  Feld           Datentyp          NULL Bedeutung
  -------------- --------------- ------ -------------------------------
  BenutzerID     INT IDENTITY      Nein Primärschlüssel
  Benutzername   NVARCHAR(100)     Nein Eindeutiger Benutzername
  Anzeigename    NVARCHAR(150)     Nein Anzeigename
  LizenzNr       INT                 Ja Optional zugeordneter Spieler
  Rolle          VARCHAR(20)       Nein Benutzerrolle
  VereinsNr      INT                 Ja Optionaler Clubbezug
  VerbandID      INT                 Ja Optionaler Verbandsbezug
  Aktiv          BIT               Nein Aktivstatus

Implementierte Rollen sind `CAPTAIN`, `VEREIN`, `KLASSENLEITER` und
`ADMIN`.

------------------------------------------------------------------------

## 7. Ligabetrieb und Mannschaften

### 7.1 Ball

**Zweck:** Speichert verwendete Tischtennisbälle.

  Feld     Datentyp          NULL Bedeutung
  -------- --------------- ------ -----------------
  BallID   INT IDENTITY      Nein Primärschlüssel
  Marke    NVARCHAR(100)     Nein Hersteller
  Modell   NVARCHAR(100)     Nein Modell
  Farbe    VARCHAR(20)       Nein Farbe
  Aktiv    BIT               Nein Aktivstatus

Die Kombination aus Marke, Modell und Farbe ist eindeutig.

### 7.2 Spielsystem

**Zweck:** Definiert Spielsysteme für Mannschaftsbegegnungen.

  Feld              Datentyp          NULL Bedeutung
  ----------------- --------------- ------ --------------------------------
  SpielsystemID     INT IDENTITY      Nein Primärschlüssel
  Bezeichnung       NVARCHAR(100)     Nein Bezeichnung
  AnzahlSpieler     TINYINT           Nein Vorgesehene Spielerzahl
  AnzahlEinzel      TINYINT           Nein Zahl der Einzel
  AnzahlDoppel      TINYINT           Nein Zahl der Doppel
  MaxAnzahlSpiele   TINYINT           Nein Maximale Gesamtzahl der Spiele
  Aktiv             BIT               Nein Aktivstatus

`MaxAnzahlSpiele` muss der Summe aus Einzel- und Doppelspielen
entsprechen.

### 7.3 Ligawettbewerb

**Zweck:** Definiert einen Ligawettbewerb innerhalb einer Saison.

  Feld                   Datentyp          NULL Bedeutung
  ---------------------- --------------- ------ ---------------------------
  LigawettbewerbID       INT IDENTITY      Nein Primärschlüssel
  SaisonID               INT               Nein Saison
  VerbandID              INT               Nein Veranstaltender Verband
  Bezeichnung            NVARCHAR(100)     Nein Wettbewerb
  Geschlechtskategorie   VARCHAR(10)       Nein `HERREN` oder `DAMEN`
  Alterskategorie        VARCHAR(10)         Ja Optionale Alterskategorie
  SpielsystemID          INT               Nein Spielsystem
  Aktiv                  BIT               Nein Aktivstatus

### 7.4 Ligaphase

**Zweck:** Speichert Gruppen beziehungsweise Phasen eines
Ligawettbewerbs.

  Feld                      Datentyp          NULL Bedeutung
  ------------------------- --------------- ------ ----------------------
  LigaphaseID               INT IDENTITY      Nein Primärschlüssel
  LigawettbewerbID          INT               Nein Ligawettbewerb
  Bezeichnung               NVARCHAR(100)     Nein Bezeichnung
  Phasentyp                 VARCHAR(20)       Nein Phasentyp
  Gruppenbezeichnung        NVARCHAR(50)        Ja Gruppenbezeichnung
  KlassenleiterBenutzerID   INT                 Ja Zuständiger Benutzer
  Aktiv                     BIT               Nein Aktivstatus

Mögliche Phasentypen sind `HAUPTRUNDE`, `VORRUNDE` und `FINALRUNDE`.

### 7.5 Mannschaft

**Zweck:** Speichert eine Ligamannschaft eines Clubs.

  Feld               Datentyp         NULL Bedeutung
  ------------------ -------------- ------ -------------------
  MannschaftID       INT IDENTITY     Nein Primärschlüssel
  VereinsNr          INT              Nein Club
  LigaphaseID        INT              Nein Ligaphase
  MannschaftNummer   TINYINT          Nein Mannschaftsnummer
  KapitaenLizenz     INT              Nein Kapitän
  BallID             INT                Ja Verwendeter Ball
  Aktiv              BIT              Nein Aktivstatus

Die Kombination aus Ligaphase, Club und Mannschaftsnummer ist eindeutig.

### 7.6 MannschaftSpieler

**Zweck:** Ordnet Spieler einer Ligamannschaft zu.

  --------------------------------------------------------------------------------
  Feld                  Datentyp                          NULL Bedeutung
  --------------------- ---------------- --------------------- -------------------
  MannschaftSpielerID   BIGINT IDENTITY                   Nein Primärschlüssel

  MannschaftID          INT                               Nein Mannschaft

  LizenzNr              INT                               Nein Spieler

  Meldungsart           VARCHAR(20)                       Nein `STAMMSPIELER` oder
                                                               `ERSATZSPIELER`

  StammPosition         TINYINT                             Ja Stammposition 1 bis
                                                               3

  Spielberechtigt       BIT                               Nein Aktuelle
                                                               Spielberechtigung

  Bemerkung             NVARCHAR(500)                       Ja Optionale Bemerkung
  --------------------------------------------------------------------------------

Ein Stammspieler benötigt eine Stammposition zwischen 1 und 3. Ein
Ersatzspieler besitzt keine Stammposition.

### 7.7 BenutzerMannschaft

**Zweck:** Ordnet Benutzer einer oder mehreren Mannschaften zu.

  Feld           Datentyp     NULL Bedeutung
  -------------- ---------- ------ ------------
  BenutzerID     INT          Nein Benutzer
  MannschaftID   INT          Nein Mannschaft

Der zusammengesetzte Primärschlüssel verhindert doppelte Zuordnungen.
Die Tabelle ist insbesondere für Benutzer mit der Rolle `CAPTAIN`
vorgesehen.

------------------------------------------------------------------------

## 8. Begegnungen

### 8.1 Begegnung

**Zweck:** Speichert eine vollständige Mannschaftsbegegnung innerhalb
einer Ligaphase.

  Feld                    Datentyp            NULL Bedeutung
  ----------------------- ----------------- ------ -------------------------
  BegegnungID             BIGINT IDENTITY     Nein Primärschlüssel
  LigaphaseID             INT                 Nein Ligaphase
  HeimMannschaftID        INT                 Nein Heimmannschaft
  GastMannschaftID        INT                 Nein Gastmannschaft
  SpielortID              INT                 Nein Spielort
  Runde                   TINYINT               Ja Runde
  Datum                   DATE                Nein Datum
  Startzeit               TIME(0)             Nein Startzeit
  Endzeit                 TIME(0)               Ja Endzeit
  SiegeHeim               TINYINT               Ja Gewonnene Spiele Heim
  SiegeGast               TINYINT               Ja Gewonnene Spiele Gast
  MannschaftspunkteHeim   TINYINT               Ja Tabellenpunkte Heim
  MannschaftspunkteGast   TINYINT               Ja Tabellenpunkte Gast
  SaetzeHeim              SMALLINT              Ja Gesamtsätze Heim
  SaetzeGast              SMALLINT              Ja Gesamtsätze Gast
  BaelleHeim              SMALLINT              Ja Gesamtbälle Heim
  BaelleGast              SMALLINT              Ja Gesamtbälle Gast
  ZuschauerAnzahl         SMALLINT              Ja Zuschauer
  SchiedsrichterName      NVARCHAR(150)         Ja Schiedsrichter
  MatchblattGenehmigt     BIT                 Nein Genehmigungskennzeichen
  GenehmigtAm             DATETIME2(0)          Ja Genehmigungszeitpunkt
  GenehmigtVon            INT                   Ja Genehmigender Benutzer
  Status                  VARCHAR(20)         Nein Begegnungsstatus

Mögliche Statuswerte sind `GEPLANT`, `LAUFEND`, `ABGESCHLOSSEN`,
`GENEHMIGT` und `ANNULLIERT`. Heim- und Gastmannschaft müssen
verschieden sein. Für eine genehmigte Begegnung müssen
Genehmigungskennzeichen, Zeitpunkt und Benutzer vorhanden sein.

Die aggregierten Resultate werden bewusst in der Begegnung gespeichert.
Die detaillierten Einzel-, Doppel- und Satzresultate bleiben zusätzlich
erhalten.

### 8.2 Begegnungsaufstellung

**Zweck:** Speichert die Spieleraufstellung einer konkreten Begegnung.

  Feld                      Datentyp            NULL Bedeutung
  ------------------------- ----------------- ------ --------------------
  BegegnungsaufstellungID   BIGINT IDENTITY     Nein Primärschlüssel
  BegegnungID               BIGINT              Nein Begegnung
  MannschaftID              INT                 Nein Mannschaft
  LizenzNr                  INT                 Nein Spieler
  Seite                     VARCHAR(4)          Nein `HEIM` oder `GAST`
  Position                  CHAR(1)             Nein Position

Heimpositionen sind `A`, `B`, `C`; Gastpositionen `X`, `Y`, `Z`.
Innerhalb einer Begegnung dürfen weder eine Position noch ein Spieler
doppelt vorkommen.

### 8.3 Begegnungsbemerkung

**Zweck:** Speichert Bemerkungen zu einer Begegnung.

  Feld                    Datentyp            NULL Bedeutung
  ----------------------- ----------------- ------ ----------------------
  BegegnungsbemerkungID   BIGINT IDENTITY     Nein Primärschlüssel
  BegegnungID             BIGINT              Nein Begegnung
  BenutzerID              INT                 Nein Verfasser
  Bemerkungsart           VARCHAR(20)         Nein Art der Bemerkung
  Text                    NVARCHAR(MAX)       Nein Bemerkung
  ErstelltAm              DATETIME2(0)        Nein Erstellungszeitpunkt

Mögliche Arten sind `VEREIN`, `KLASSENLEITER` und `ADMIN`.

### 8.4 BegegnungAenderung

**Zweck:** Dokumentiert nachträgliche Änderungen an bereits genehmigten
Begegnungen.

  Feld                   Datentyp            NULL Bedeutung
  ---------------------- ----------------- ------ --------------------
  BegegnungAenderungID   BIGINT IDENTITY     Nein Primärschlüssel
  BegegnungID            BIGINT              Nein Begegnung
  BenutzerID             INT                 Nein Ändernder Benutzer
  Aenderungsdatum        DATETIME2(0)        Nein Zeitpunkt
  Grund                  NVARCHAR(500)       Nein Änderungsgrund

Der Änderungsgrund darf nicht leer sein.

------------------------------------------------------------------------

## 9. Turniere und Anmeldungen

### 9.1 Turnier

**Zweck:** Speichert die allgemeinen Stammdaten eines Turniers.

  Feld                       Datentyp          NULL Bedeutung
  -------------------------- --------------- ------ ----------------------
  TurnierID                  INT IDENTITY      Nein Primärschlüssel
  SaisonID                   INT               Nein Saison
  BewertungsperiodeID        INT               Nein Bewertungsgrundlage
  Turniername                NVARCHAR(150)     Nein Name
  VeranstalterNr             INT               Nein Veranstaltender Club
  SpielortID                 INT               Nein Spielort
  Startdatum                 DATE              Nein Start
  Enddatum                   DATE                Ja Ende
  Meldeschluss               DATETIME2(0)      Nein Meldeschluss
  HallenSchiedsrichterName   NVARCHAR(150)       Ja Hallenschiedsrichter
  Status                     VARCHAR(20)       Nein Status

Mögliche Statuswerte sind `GEPLANT`, `OFFEN`, `AUSGELOST`, `LAUFEND`,
`BEENDET` und `ABGESAGT`.

### 9.2 TurnierKategorie

**Zweck:** Speichert eine Kategorie beziehungsweise Konkurrenz eines
Turniers.

  ------------------------------------------------------------------------------------------------------
  Feld                                     Datentyp                          NULL Bedeutung
  ---------------------------------------- ---------------- --------------------- ----------------------
  TurnierKategorieID                       INT IDENTITY                      Nein Primärschlüssel

  TurnierID                                INT                               Nein Turnier

  Bezeichnung                              NVARCHAR(150)                     Nein Kategoriebezeichnung

  Kategorieart                             VARCHAR(20)                       Nein Art der Einschränkung

  Wettkampfform                            VARCHAR(15)                       Nein `EINZEL`, `DOPPEL`
                                                                                  oder `MANNSCHAFT`

  Geschlechtskategorie                     VARCHAR(10)                       Nein Geschlechtskategorie

  VerwendeteKlassierungsart                VARCHAR(10)                         Ja `HERREN` oder `DAMEN`

  Alterskategorie                          VARCHAR(10)                         Ja Alterskategorie

  Altersregel                              VARCHAR(20)                       Nein Altersregel

  BevorzugePassendeKategorie               BIT                               Nein Präferenzregel

  MinStufenwert                            TINYINT                             Ja Minimale Klassierung

  MaxStufenwert                            TINYINT                             Ja Maximale Klassierung

  AlleSpielerMuessenKlassierungErfuellen   BIT                               Nein Teamregel Klassierung

  MinEloWert                               DECIMAL(10,3)                       Ja Minimaler Einzel-Elo

  TopEloWert                               DECIMAL(10,3)                       Ja Oberer Einzel-Elo

  AlleSpielerMuessenEloErfuellen           BIT                               Nein Teamregel Elo

  SpielerProTeam                           TINYINT                             Ja Spielerzahl bei
                                                                                  Mannschaft

  MinKlassierungSumme                      SMALLINT                            Ja Minimale
                                                                                  Klassierungssumme

  MaxKlassierungSumme                      SMALLINT                            Ja Maximale
                                                                                  Klassierungssumme

  MinEloSumme                              DECIMAL(10,3)                       Ja Minimale Elo-Summe

  MaxEloSumme                              DECIMAL(10,3)                       Ja Maximale Elo-Summe

  Gewinnsaetze                             TINYINT                           Nein 3 oder 4 Gewinnsätze

  Status                                   VARCHAR(20)                       Nein Status
  ------------------------------------------------------------------------------------------------------

Kategoriearten sind `ALTER`, `KLASSIERUNG`, `ELO`, `OFFEN` und
`KOMBINIERT`. Altersregeln sind `ALLE`, `BIS_MAXALTER`, `AB_MINALTER`
und `EXAKT`.

### 9.3 Einzelanmeldung

**Zweck:** Speichert die Anmeldung eines Spielers zu einer
Einzelkategorie.

  Feld                 Datentyp            NULL Bedeutung
  -------------------- ----------------- ------ -----------------
  EinzelanmeldungID    BIGINT IDENTITY     Nein Primärschlüssel
  TurnierKategorieID   INT                 Nein Kategorie
  LizenzNr             INT                 Nein Spieler
  Anmeldedatum         DATETIME2(0)        Nein Anmeldung
  Status               VARCHAR(20)         Nein Status
  Ablehnungsgrund      NVARCHAR(500)         Ja Ablehnungsgrund

Elo, Klassierung und Alterskategorie werden nicht redundant in der
Anmeldung gespeichert. Die Kombination aus Kategorie und Spieler ist
eindeutig.

### 9.4 Doppelanmeldung

**Zweck:** Speichert die Anmeldung eines Doppelpaares.

  -----------------------------------------------------------------------------
  Feld                 Datentyp                          NULL Bedeutung
  -------------------- ---------------- --------------------- -----------------
  DoppelanmeldungID    BIGINT IDENTITY                   Nein Primärschlüssel

  TurnierKategorieID   INT                               Nein Kategorie

  Spieler1LizenzNr     INT                               Nein Spieler 1

  Spieler2LizenzNr     INT                               Nein Spieler 2

  Anmeldedatum         DATETIME2(0)                      Nein Anmeldung

  Status               VARCHAR(20)                       Nein Status

  Ablehnungsgrund      NVARCHAR(500)                       Ja Ablehnungsgrund

  SpielerMinLizenz     berechnet,                      Nein\* Kleinere
                       PERSISTED                              Lizenznummer

  SpielerMaxLizenz     berechnet,                      Nein\* Grössere
                       PERSISTED                              Lizenznummer
  -----------------------------------------------------------------------------

\* Die beiden Werte sind persistierte berechnete Spalten aus den beiden
nicht-nullbaren Lizenznummern.

Die Reihenfolge der Spieler spielt für die Eindeutigkeit nicht mit. Ein
UNIQUE-Index über Kategorie, kleinere Lizenznummer und grössere
Lizenznummer verhindert sowohl `(A,B)` als auch `(B,A)` als doppelte
Anmeldung.

### 9.5 Turniermannschaft

**Zweck:** Speichert eine speziell für ein Turnier gebildete Mannschaft.

  Feld                  Datentyp            NULL Bedeutung
  --------------------- ----------------- ------ -----------------
  TurniermannschaftID   BIGINT IDENTITY     Nein Primärschlüssel
  TurnierKategorieID    INT                 Nein Kategorie
  Name                  NVARCHAR(100)       Nein Mannschaftsname
  Anmeldedatum          DATETIME2(0)        Nein Anmeldung
  Status                VARCHAR(20)         Nein Status
  Ablehnungsgrund       NVARCHAR(500)         Ja Ablehnungsgrund

Spieler verschiedener Clubs dürfen gemeinsam in derselben
Turniermannschaft antreten.

### 9.6 TurniermannschaftSpieler

**Zweck:** Ordnet Spieler einer Turniermannschaft zu.

  Feld                  Datentyp     NULL Bedeutung
  --------------------- ---------- ------ ---------------------
  TurniermannschaftID   BIGINT       Nein Turniermannschaft
  LizenzNr              INT          Nein Spieler
  Position              TINYINT        Ja Optionale Position
  IstCaptain            BIT          Nein Captain-Kennzeichen

Der Primärschlüssel besteht aus `TurniermannschaftID` und `LizenzNr`.
Eine vergebene Position darf innerhalb einer Mannschaft nur einmal
vorkommen. Durch einen gefilterten UNIQUE-Index kann höchstens ein
Spieler pro Turniermannschaft Captain sein.

Für Einzel-, Doppel- und Mannschaftsanmeldungen werden die Statuswerte
`ANGEMELDET`, `BESTAETIGT`, `ABGELEHNT` und `ZURUECKGEZOGEN` verwendet.

------------------------------------------------------------------------

## 10. Einzel-, Doppel- und Satzresultate

### 10.1 Einzelspiel

**Zweck:** Speichert ein Einzelspiel aus einer Ligabegegnung oder einer
Turnierkategorie.

  Feld                 Datentyp            NULL Bedeutung
  -------------------- ----------------- ------ ---------------------------
  EinzelspielID        BIGINT IDENTITY     Nein Primärschlüssel
  BegegnungID          BIGINT                Ja Herkunft Ligabegegnung
  TurnierKategorieID   INT                   Ja Herkunft Turnier
  Spielnummer          TINYINT               Ja Spielnummer
  Spielcode            VARCHAR(10)           Ja Spielcode
  Spieler1Lizenz       INT                   Ja Spieler 1
  Spieler2Lizenz       INT                   Ja Spieler 2
  GewinnerLizenz       INT                   Ja Gewinner
  Spieldatum           DATETIME2(0)        Nein Spielzeitpunkt
  SaetzeSpieler1       TINYINT             Nein Gewonnene Sätze Spieler 1
  SaetzeSpieler2       TINYINT             Nein Gewonnene Sätze Spieler 2
  PunkteSpieler1       TINYINT             Nein Wertungspunkt Spieler 1
  PunkteSpieler2       TINYINT             Nein Wertungspunkt Spieler 2
  Spielgrund           VARCHAR(20)         Nein Art des Resultats
  Status               VARCHAR(20)         Nein Status

Ein Einzelspiel gehört genau zu einer Ligabegegnung oder zu einer
Turnierkategorie. `REGULAER` und `AUFGABE` sind Elo-relevant. `FORFAIT`,
`NICHTANGETRETEN` und `ANNULLIERT` sind nicht Elo-relevant.

Bei einem regulären Spiel müssen beide Spieler bekannt sein. Nullable
Spielerfelder ermöglichen die Abbildung besonderer Fälle wie Forfait
oder Nichtantreten.

### 10.2 Doppelspiel

**Zweck:** Speichert ein Doppelspiel aus einer Ligabegegnung oder einer
Turnierkategorie.

  Feld                   Datentyp            NULL Bedeutung
  ---------------------- ----------------- ------ -------------------------
  DoppelspielID          BIGINT IDENTITY     Nein Primärschlüssel
  BegegnungID            BIGINT                Ja Herkunft Ligabegegnung
  TurnierKategorieID     INT                   Ja Herkunft Turnier
  Spielnummer            TINYINT               Ja Spielnummer
  Spielcode              VARCHAR(10)           Ja Spielcode
  Seite1Spieler1Lizenz   INT                   Ja Spieler 1, Seite 1
  Seite1Spieler2Lizenz   INT                   Ja Spieler 2, Seite 1
  Seite2Spieler1Lizenz   INT                   Ja Spieler 1, Seite 2
  Seite2Spieler2Lizenz   INT                   Ja Spieler 2, Seite 2
  Gewinnerseite          TINYINT               Ja Gewinnerseite 1 oder 2
  Spieldatum             DATETIME2(0)        Nein Spielzeitpunkt
  SaetzeSeite1           TINYINT             Nein Gewonnene Sätze Seite 1
  SaetzeSeite2           TINYINT             Nein Gewonnene Sätze Seite 2
  PunkteSeite1           TINYINT             Nein Wertungspunkt Seite 1
  PunkteSeite2           TINYINT             Nein Wertungspunkt Seite 2
  Spielgrund             VARCHAR(20)         Nein Art des Resultats
  Status                 VARCHAR(20)         Nein Status

Ein Doppelspiel gehört genau zu einer Begegnung oder zu einer
Turnierkategorie. Bei regulären Doppelspielen müssen alle vier Spieler
gesetzt und voneinander verschieden sein. Doppelspiele beeinflussen den
Elo-Wert nicht.

### 10.3 Satz

**Zweck:** Speichert die tatsächlich gespielten Punkte eines Satzes.

  Feld            Datentyp            NULL Bedeutung
  --------------- ----------------- ------ -------------------------
  SatzID          BIGINT IDENTITY     Nein Primärschlüssel
  EinzelspielID   BIGINT                Ja Zugehöriges Einzelspiel
  DoppelspielID   BIGINT                Ja Zugehöriges Doppelspiel
  SatzNummer      TINYINT             Nein Satznummer 1 bis 7
  PunkteSeite1    TINYINT             Nein Punkte Seite 1
  PunkteSeite2    TINYINT             Nein Punkte Seite 2

Ein Satz gehört genau zu einem Einzel- oder einem Doppelspiel. Die
beiden Punktestände dürfen nicht identisch sein. Gefilterte
UNIQUE-Indizes verhindern, dass dieselbe Satznummer innerhalb eines
Einzel- beziehungsweise Doppelspiels mehrfach gespeichert wird.

------------------------------------------------------------------------

## 11. Beziehungen und Datenintegrität

### 11.1 Zentrale Beziehungen

Das Modell besitzt mehrere fachliche Beziehungsketten:

-   `Verband` → `Club` → `Spielort`
-   `Saison` → `SpielerSaison` → `Spieler`
-   `Spieler` → `SpielerVerein` → `Club`
-   `Saison` → `Bewertungsperiode` → `SpielerBewertung`
-   `EloMonatslauf` → `SpielerElo`
-   `Einzelspiel` → `EloProtokoll`
-   `Saison` → `Ligawettbewerb` → `Ligaphase` → `Mannschaft`
-   `Mannschaft` → `MannschaftSpieler`
-   `Ligaphase` → `Begegnung` → `Einzelspiel` / `Doppelspiel` → `Satz`
-   `Turnier` → `TurnierKategorie` → Einzel-, Doppel- oder
    Mannschaftsanmeldung
-   `Turniermannschaft` → `TurniermannschaftSpieler`

### 11.2 Historisierung

Nicht alle Daten werden gleich behandelt. Spieler-Stammdaten liegen
dauerhaft in `Spieler`, während saisonabhängige Informationen in
`SpielerSaison` und `SpielerVerein` ausgelagert sind.

Offizielle halbjährliche Bewertungen werden in `SpielerBewertung`
gespeichert. Monatliche Elo-Stände werden über `EloMonatslauf` und
`SpielerElo` historisiert. `EloProtokoll` dokumentiert zusätzlich die
Berechnungsgrundlage einzelner Elo-relevanter Spiele.

### 11.3 Redundanz und abgeleitete Daten

Das Modell vermeidet unnötige Redundanz. Beispielsweise werden Elo,
Klassierung und Alterskategorie bei Turnieranmeldungen nicht erneut
gespeichert, sondern über die zugehörigen Bewertungsdaten bestimmt.

Bestimmte aggregierte Werte einer Mannschaftsbegegnung werden dagegen
bewusst in `Begegnung` gespeichert. Dazu gehören Siege,
Mannschaftspunkte, Sätze und Bälle. Damit steht das offizielle
Gesamtergebnis direkt zur Verfügung, während die detaillierten Spiel-
und Satzdaten weiterhin separat gespeichert werden.

### 11.4 Sonderfälle

Das Modell berücksichtigt verschiedene fachliche Sonderfälle:

-   Hauptverein und Mehrfachlizenz;
-   Stamm- und Ersatzspieler;
-   fehlende Spieler bei Forfait oder Nichtantreten;
-   Aufgabe nach Spielbeginn;
-   genehmigte und nachträglich geänderte Begegnungen;
-   Doppelpaare unabhängig von der Reihenfolge der Spieler;
-   Turniermannschaften mit Spielern verschiedener Clubs;
-   Einzel- und Doppelspiele mit Herkunft aus Liga oder Turnier.

------------------------------------------------------------------------

## 12. Zusammenfassung

Das finale relationale Datenmodell besteht aus 39 Tabellen und deckt die
wesentlichen Bereiche der Projektaufgabe ab. Die Struktur trennt
langfristige Stammdaten von saison- und periodenabhängigen Informationen
und bildet sowohl Liga- als auch Turnierbetrieb ab.

Besondere Schwerpunkte sind die Historisierung von Elo und
Klassierungen, die Abbildung von Mannschaftsbegegnungen bis auf
Satzebene, flexible Turnierkategorien sowie die Absicherung fachlicher
Regeln durch Beziehungen, Constraints und eindeutige Indizes.

Die detaillierte technische Beschreibung der Integritätsregeln befindet
sich in `Constraints.md`. Geschäftsregeln werden ergänzend in
`Geschaeftsregeln.md` beschrieben.
