# ER-Diagramm

## 1. Zweck

Dieses Dokument visualisiert das relationale Datenmodell der STT-Datenbank.

Da das finale Schema 39 Tabellen umfasst, werden mehrere fachlich gegliederte Mermaid-Diagramme verwendet. Die Diagramme orientieren sich am tatsächlich implementierten SQL-Schema.

Die vollständigen Detailbeschreibungen befinden sich zusätzlich in:

- `Datenmodell.md`
- `Constraints.md`
- `Geschaeftsregeln.md`

---

## 2. Fachübersicht

```mermaid
flowchart LR
    A["Stammdaten<br/>Saison · Verband · Alterskategorie · Klassierungsstufe · Club · Spielort"]
    B["Spieler / Elo<br/>Spieler · SpielerSaison · SpielerVerein · Bewertungsperiode · SpielerBewertung · SpielerElo · EloProtokoll"]
    C["Benutzer / Funktionen<br/>Funktion · Vereinsfunktionaer · FunktionaerFunktion · Benutzer"]
    D["Ligabetrieb<br/>Ball · Spielsystem · Ligawettbewerb · Ligaphase · Mannschaft · MannschaftSpieler · BenutzerMannschaft"]
    E["Begegnungen<br/>Begegnung · Begegnungsaufstellung · Begegnungsbemerkung · BegegnungAenderung"]
    F["Turniere<br/>Turnier · TurnierKategorie · Einzelanmeldung · Doppelanmeldung · Turniermannschaft · TurniermannschaftSpieler"]
    G["Spiele / Resultate<br/>Einzelspiel · Doppelspiel · Satz"]

    A --> B
    A --> D
    A --> F
    B --> D
    B --> F
    B --> G
    C --> D
    C --> E
    D --> E
    E --> G
    F --> G
```

---

## 3. Gesamtmodell

### 3.1 Stammdaten, Spieler und Elo

```mermaid
erDiagram

    SAISON {
        int SaisonID PK
        nvarchar Bezeichnung
        date Startdatum
        date Enddatum
        bit IstAktuell
    }

    VERBAND {
        int VerbandID PK
        varchar Kurzname
        nvarchar Name
        varchar Verbandstyp
        int UebergeordneterVerbandID FK
        date Gruendungsdatum
        nvarchar Webseite
        bit Aktiv
    }

    ALTERSKATEGORIE {
        varchar Bezeichnung PK
        tinyint MinAlter
        tinyint MaxAlter
    }

    KLASSIERUNGSSTUFE {
        tinyint Stufenwert PK
        varchar Bezeichnung
    }

    CLUB {
        int VereinsNr PK
        nvarchar Clubname
        nvarchar Kurzname
        int RegionalverbandID FK
        smallint Gruendungsjahr
        nvarchar Webseite
        nvarchar Ort
        char Landcode
        bit Aktiv
    }

    SPIELORT {
        int SpielortID PK
        int VereinsNr FK
        nvarchar Bezeichnung
        nvarchar Gebaeude
        nvarchar Strasse
        nvarchar Hausnummer
        char PLZ
        nvarchar Ort
        char Landcode
        bit IstHauptspielort
        bit Aktiv
    }

    SPIELER {
        int LizenzNr PK
        nvarchar Vorname
        nvarchar Nachname
        date Geburtsdatum
        char Geschlecht
        bit Aktiv
    }

    SPIELERSAISON {
        int LizenzNr PK,FK
        int SaisonID PK,FK
        varchar Alterskategorie FK
        bit LizenzAktiv
    }

    SPIELERVEREIN {
        bigint SpielerVereinID PK
        int LizenzNr FK
        int SaisonID FK
        int VereinsNr FK
        varchar Zuordnungsart
        varchar Wettbewerbsbereich
    }

    BEWERTUNGSPERIODE {
        int BewertungsperiodeID PK
        int SaisonID FK
        varchar Bezeichnung
        date Stichtag
        date GueltigAb
        date GueltigBis
    }

    KLASSIERUNGSGRENZE {
        int KlassierungsgrenzeID PK
        int BewertungsperiodeID FK
        tinyint Stufenwert FK
        varchar Klassierungsart
        decimal MinElo
        decimal MittelElo
        decimal MaxElo
    }

    SPIELERBEWERTUNG {
        bigint SpielerBewertungID PK
        int LizenzNr FK
        int BewertungsperiodeID FK
        decimal Elo
        tinyint HerrenStufenwert FK
        tinyint DamenStufenwert FK
        varchar Alterskategorie FK
        datetime ErstelltAm
    }

    ELOMONATSLAUF {
        bigint EloMonatslaufID PK
        date Berechnungsdatum
        date PeriodeVon
        date PeriodeBis
        varchar Status
        datetime GestartetAm
        datetime AbgeschlossenAm
        nvarchar Bemerkung
    }

    SPIELERELO {
        bigint SpielerEloID PK
        int LizenzNr FK
        bigint EloMonatslaufID FK
        decimal Elo
        decimal EloDeltaZumVormonat
        tinyint HerrenStufenwert FK
        tinyint DamenStufenwert FK
        int HerrenRang
        int Gesamtrang
        date GueltigAb
        date GueltigBis
    }

    ELOPROTOKOLL {
        bigint EloProtokollID PK
        bigint EinzelspielID FK
        int LizenzNr FK
        int GegnerLizenzNr FK
        bigint EloMonatslaufID FK
        decimal StichtagsElo
        decimal GegnerStichtagsElo
        decimal Gewinnwahrscheinlichkeit
        decimal VorschauElo
        datetime ErstelltAm
    }

    VERBAND ||--o{ VERBAND : "übergeordnet"
    VERBAND ||--o{ CLUB : "Regionalverband"
    CLUB ||--o{ SPIELORT : besitzt

    SPIELER ||--o{ SPIELERSAISON : hat
    SAISON ||--o{ SPIELERSAISON : umfasst
    ALTERSKATEGORIE ||--o{ SPIELERSAISON : klassifiziert

    SPIELER ||--o{ SPIELERVEREIN : hat
    SAISON ||--o{ SPIELERVEREIN : gilt_in
    CLUB ||--o{ SPIELERVEREIN : Verein

    SAISON ||--o{ BEWERTUNGSPERIODE : besitzt
    BEWERTUNGSPERIODE ||--o{ KLASSIERUNGSGRENZE : definiert
    KLASSIERUNGSSTUFE ||--o{ KLASSIERUNGSGRENZE : Stufe

    SPIELER ||--o{ SPIELERBEWERTUNG : erhält
    BEWERTUNGSPERIODE ||--o{ SPIELERBEWERTUNG : bewertet
    KLASSIERUNGSSTUFE ||--o{ SPIELERBEWERTUNG : Herrenstufe
    KLASSIERUNGSSTUFE ||--o{ SPIELERBEWERTUNG : Damenstufe
    ALTERSKATEGORIE ||--o{ SPIELERBEWERTUNG : Altersklasse

    SPIELER ||--o{ SPIELERELO : besitzt
    ELOMONATSLAUF ||--o{ SPIELERELO : erzeugt
    KLASSIERUNGSSTUFE ||--o{ SPIELERELO : Herrenstufe
    KLASSIERUNGSSTUFE ||--o{ SPIELERELO : Damenstufe

    SPIELER ||--o{ ELOPROTOKOLL : Spieler
    SPIELER ||--o{ ELOPROTOKOLL : Gegner
    ELOMONATSLAUF ||--o{ ELOPROTOKOLL : gehört_zu
```

---

### 3.2 Benutzer und Vereinsfunktionen

```mermaid
erDiagram

    CLUB {
        int VereinsNr PK
    }

    SPIELER {
        int LizenzNr PK
    }

    VERBAND {
        int VerbandID PK
    }

    FUNKTION {
        int FunktionID PK
        nvarchar Bezeichnung
        bit Aktiv
    }

    VEREINSFUNKTIONAER {
        int FunktionaerID PK
        int VereinsNr FK
        nvarchar Vorname
        nvarchar Nachname
        nvarchar Email
        nvarchar TelefonPrivat
        nvarchar TelefonMobil
        nvarchar Strasse
        nvarchar Hausnummer
        char PLZ
        nvarchar Ort
        bit Aktiv
    }

    FUNKTIONAERFUNKTION {
        int FunktionaerID PK,FK
        int FunktionID PK,FK
        date GueltigAb PK
        date GueltigBis
    }

    BENUTZER {
        int BenutzerID PK
        nvarchar Benutzername
        nvarchar Anzeigename
        int LizenzNr FK
        varchar Rolle
        int VereinsNr FK
        int VerbandID FK
        bit Aktiv
    }

    CLUB ||--o{ VEREINSFUNKTIONAER : besitzt
    VEREINSFUNKTIONAER ||--o{ FUNKTIONAERFUNKTION : hat
    FUNKTION ||--o{ FUNKTIONAERFUNKTION : zugeordnet

    SPIELER ||--o{ BENUTZER : optional
    CLUB ||--o{ BENUTZER : optional
    VERBAND ||--o{ BENUTZER : optional
```

---

### 3.3 Ligabetrieb und Mannschaften

```mermaid
erDiagram

    SAISON {
        int SaisonID PK
    }

    VERBAND {
        int VerbandID PK
    }

    ALTERSKATEGORIE {
        varchar Bezeichnung PK
    }

    CLUB {
        int VereinsNr PK
    }

    SPIELER {
        int LizenzNr PK
    }

    BENUTZER {
        int BenutzerID PK
    }

    BALL {
        int BallID PK
        nvarchar Marke
        nvarchar Modell
        varchar Farbe
        bit Aktiv
    }

    SPIELSYSTEM {
        int SpielsystemID PK
        nvarchar Bezeichnung
        tinyint AnzahlSpieler
        tinyint AnzahlEinzel
        tinyint AnzahlDoppel
        tinyint MaxAnzahlSpiele
        bit Aktiv
    }

    LIGAWETTBEWERB {
        int LigawettbewerbID PK
        int SaisonID FK
        int VerbandID FK
        nvarchar Bezeichnung
        varchar Geschlechtskategorie
        varchar Alterskategorie FK
        int SpielsystemID FK
        bit Aktiv
    }

    LIGAPHASE {
        int LigaphaseID PK
        int LigawettbewerbID FK
        nvarchar Bezeichnung
        varchar Phasentyp
        nvarchar Gruppenbezeichnung
        int KlassenleiterBenutzerID FK
        bit Aktiv
    }

    MANNSCHAFT {
        int MannschaftID PK
        int VereinsNr FK
        int LigaphaseID FK
        tinyint MannschaftNummer
        int KapitaenLizenz FK
        int BallID FK
        bit Aktiv
    }

    MANNSCHAFTSPIELER {
        bigint MannschaftSpielerID PK
        int MannschaftID FK
        int LizenzNr FK
        varchar Meldungsart
        tinyint StammPosition
        bit Spielberechtigt
        nvarchar Bemerkung
    }

    BENUTZERMANNSCHAFT {
        int BenutzerID PK,FK
        int MannschaftID PK,FK
    }

    SAISON ||--o{ LIGAWETTBEWERB : enthält
    VERBAND ||--o{ LIGAWETTBEWERB : organisiert
    ALTERSKATEGORIE ||--o{ LIGAWETTBEWERB : optional
    SPIELSYSTEM ||--o{ LIGAWETTBEWERB : verwendet

    LIGAWETTBEWERB ||--o{ LIGAPHASE : besitzt
    BENUTZER ||--o{ LIGAPHASE : leitet

    CLUB ||--o{ MANNSCHAFT : meldet
    LIGAPHASE ||--o{ MANNSCHAFT : enthält
    SPIELER ||--o{ MANNSCHAFT : Kapitän
    BALL ||--o{ MANNSCHAFT : verwendet

    MANNSCHAFT ||--o{ MANNSCHAFTSPIELER : besitzt
    SPIELER ||--o{ MANNSCHAFTSPIELER : wird_gemeldet

    BENUTZER ||--o{ BENUTZERMANNSCHAFT : verwaltet
    MANNSCHAFT ||--o{ BENUTZERMANNSCHAFT : wird_verwaltet
```

---

### 3.4 Begegnungen

```mermaid
erDiagram

    LIGAPHASE {
        int LigaphaseID PK
    }

    MANNSCHAFT {
        int MannschaftID PK
    }

    SPIELORT {
        int SpielortID PK
    }

    SPIELER {
        int LizenzNr PK
    }

    BENUTZER {
        int BenutzerID PK
    }

    BEGEGNUNG {
        bigint BegegnungID PK
        int LigaphaseID FK
        int HeimMannschaftID FK
        int GastMannschaftID FK
        int SpielortID FK
        tinyint Runde
        date Datum
        time Startzeit
        time Endzeit
        tinyint SiegeHeim
        tinyint SiegeGast
        tinyint MannschaftspunkteHeim
        tinyint MannschaftspunkteGast
        smallint SaetzeHeim
        smallint SaetzeGast
        smallint BaelleHeim
        smallint BaelleGast
        smallint ZuschauerAnzahl
        nvarchar SchiedsrichterName
        bit MatchblattGenehmigt
        datetime GenehmigtAm
        int GenehmigtVon FK
        varchar Status
    }

    BEGEGNUNGSAUFSTELLUNG {
        bigint BegegnungsaufstellungID PK
        bigint BegegnungID FK
        int MannschaftID FK
        int LizenzNr FK
        varchar Seite
        char Position
    }

    BEGEGNUNGSBEMERKUNG {
        bigint BegegnungsbemerkungID PK
        bigint BegegnungID FK
        int BenutzerID FK
        varchar Bemerkungsart
        nvarchar Text
        datetime ErstelltAm
    }

    BEGEGNUNGAENDERUNG {
        bigint BegegnungAenderungID PK
        bigint BegegnungID FK
        int BenutzerID FK
        datetime Aenderungsdatum
        nvarchar Grund
    }

    LIGAPHASE ||--o{ BEGEGNUNG : enthält
    MANNSCHAFT ||--o{ BEGEGNUNG : Heim
    MANNSCHAFT ||--o{ BEGEGNUNG : Gast
    SPIELORT ||--o{ BEGEGNUNG : findet_statt_in
    BENUTZER ||--o{ BEGEGNUNG : genehmigt

    BEGEGNUNG ||--o{ BEGEGNUNGSAUFSTELLUNG : besitzt
    MANNSCHAFT ||--o{ BEGEGNUNGSAUFSTELLUNG : stellt
    SPIELER ||--o{ BEGEGNUNGSAUFSTELLUNG : spielt

    BEGEGNUNG ||--o{ BEGEGNUNGSBEMERKUNG : besitzt
    BENUTZER ||--o{ BEGEGNUNGSBEMERKUNG : erfasst

    BEGEGNUNG ||--o{ BEGEGNUNGAENDERUNG : protokolliert
    BENUTZER ||--o{ BEGEGNUNGAENDERUNG : ändert
```

---

### 3.5 Turniere und Anmeldungen

```mermaid
erDiagram

    SAISON {
        int SaisonID PK
    }

    BEWERTUNGSPERIODE {
        int BewertungsperiodeID PK
    }

    CLUB {
        int VereinsNr PK
    }

    SPIELORT {
        int SpielortID PK
    }

    ALTERSKATEGORIE {
        varchar Bezeichnung PK
    }

    KLASSIERUNGSSTUFE {
        tinyint Stufenwert PK
    }

    SPIELER {
        int LizenzNr PK
    }

    TURNIER {
        int TurnierID PK
        int SaisonID FK
        int BewertungsperiodeID FK
        nvarchar Turniername
        int VeranstalterNr FK
        int SpielortID FK
        date Startdatum
        date Enddatum
        datetime Meldeschluss
        nvarchar HallenSchiedsrichterName
        varchar Status
    }

    TURNIERKATEGORIE {
        int TurnierKategorieID PK
        int TurnierID FK
        nvarchar Bezeichnung
        varchar Kategorieart
        varchar Wettkampfform
        varchar Geschlechtskategorie
        varchar VerwendeteKlassierungsart
        varchar Alterskategorie FK
        varchar Altersregel
        bit BevorzugePassendeKategorie
        tinyint MinStufenwert FK
        tinyint MaxStufenwert FK
        bit AlleSpielerMuessenKlassierungErfuellen
        decimal MinEloWert
        decimal TopEloWert
        bit AlleSpielerMuessenEloErfuellen
        tinyint SpielerProTeam
        smallint MinKlassierungSumme
        smallint MaxKlassierungSumme
        decimal MinEloSumme
        decimal MaxEloSumme
        tinyint Gewinnsaetze
        varchar Status
    }

    EINZELANMELDUNG {
        bigint EinzelanmeldungID PK
        int TurnierKategorieID FK
        int LizenzNr FK
        datetime Anmeldedatum
        varchar Status
        nvarchar Ablehnungsgrund
    }

    DOPPELANMELDUNG {
        bigint DoppelanmeldungID PK
        int TurnierKategorieID FK
        int Spieler1LizenzNr FK
        int Spieler2LizenzNr FK
        datetime Anmeldedatum
        varchar Status
        nvarchar Ablehnungsgrund
        int SpielerMinLizenz
        int SpielerMaxLizenz
    }

    TURNIERMANNSCHAFT {
        bigint TurniermannschaftID PK
        int TurnierKategorieID FK
        nvarchar Name
        datetime Anmeldedatum
        varchar Status
        nvarchar Ablehnungsgrund
    }

    TURNIERMANNSCHAFTSPIELER {
        bigint TurniermannschaftID PK,FK
        int LizenzNr PK,FK
        tinyint Position
        bit IstCaptain
    }

    SAISON ||--o{ TURNIER : enthält
    BEWERTUNGSPERIODE ||--o{ TURNIER : bewertet_nach
    CLUB ||--o{ TURNIER : veranstaltet
    SPIELORT ||--o{ TURNIER : findet_statt_in

    TURNIER ||--o{ TURNIERKATEGORIE : besitzt
    ALTERSKATEGORIE ||--o{ TURNIERKATEGORIE : optional
    KLASSIERUNGSSTUFE ||--o{ TURNIERKATEGORIE : Mindeststufe
    KLASSIERUNGSSTUFE ||--o{ TURNIERKATEGORIE : Höchststufe

    TURNIERKATEGORIE ||--o{ EINZELANMELDUNG : Einzel
    SPIELER ||--o{ EINZELANMELDUNG : meldet_sich_an

    TURNIERKATEGORIE ||--o{ DOPPELANMELDUNG : Doppel
    SPIELER ||--o{ DOPPELANMELDUNG : Spieler1
    SPIELER ||--o{ DOPPELANMELDUNG : Spieler2

    TURNIERKATEGORIE ||--o{ TURNIERMANNSCHAFT : Mannschaft
    TURNIERMANNSCHAFT ||--o{ TURNIERMANNSCHAFTSPIELER : besitzt
    SPIELER ||--o{ TURNIERMANNSCHAFTSPIELER : spielt
```

---

### 3.6 Einzelspiele, Doppelspiele, Sätze und Elo-Protokoll

```mermaid
erDiagram

    BEGEGNUNG {
        bigint BegegnungID PK
    }

    TURNIERKATEGORIE {
        int TurnierKategorieID PK
    }

    SPIELER {
        int LizenzNr PK
    }

    ELOMONATSLAUF {
        bigint EloMonatslaufID PK
    }

    EINZELSPIEL {
        bigint EinzelspielID PK
        bigint BegegnungID FK
        int TurnierKategorieID FK
        tinyint Spielnummer
        varchar Spielcode
        int Spieler1Lizenz FK
        int Spieler2Lizenz FK
        int GewinnerLizenz FK
        datetime Spieldatum
        tinyint SaetzeSpieler1
        tinyint SaetzeSpieler2
        tinyint PunkteSpieler1
        tinyint PunkteSpieler2
        varchar Spielgrund
        varchar Status
    }

    DOPPELSPIEL {
        bigint DoppelspielID PK
        bigint BegegnungID FK
        int TurnierKategorieID FK
        tinyint Spielnummer
        varchar Spielcode
        int Seite1Spieler1Lizenz FK
        int Seite1Spieler2Lizenz FK
        int Seite2Spieler1Lizenz FK
        int Seite2Spieler2Lizenz FK
        tinyint Gewinnerseite
        datetime Spieldatum
        tinyint SaetzeSeite1
        tinyint SaetzeSeite2
        tinyint PunkteSeite1
        tinyint PunkteSeite2
        varchar Spielgrund
        varchar Status
    }

    SATZ {
        bigint SatzID PK
        bigint EinzelspielID FK
        bigint DoppelspielID FK
        tinyint SatzNummer
        tinyint PunkteSeite1
        tinyint PunkteSeite2
    }

    ELOPROTOKOLL {
        bigint EloProtokollID PK
        bigint EinzelspielID FK
        int LizenzNr FK
        int GegnerLizenzNr FK
        bigint EloMonatslaufID FK
        decimal StichtagsElo
        decimal GegnerStichtagsElo
        decimal Gewinnwahrscheinlichkeit
        decimal VorschauElo
        datetime ErstelltAm
    }

    BEGEGNUNG ||--o{ EINZELSPIEL : enthält
    TURNIERKATEGORIE ||--o{ EINZELSPIEL : enthält
    SPIELER ||--o{ EINZELSPIEL : Spieler1
    SPIELER ||--o{ EINZELSPIEL : Spieler2
    SPIELER ||--o{ EINZELSPIEL : Gewinner

    BEGEGNUNG ||--o{ DOPPELSPIEL : enthält
    TURNIERKATEGORIE ||--o{ DOPPELSPIEL : enthält
    SPIELER ||--o{ DOPPELSPIEL : Seite1Spieler1
    SPIELER ||--o{ DOPPELSPIEL : Seite1Spieler2
    SPIELER ||--o{ DOPPELSPIEL : Seite2Spieler1
    SPIELER ||--o{ DOPPELSPIEL : Seite2Spieler2

    EINZELSPIEL ||--o{ SATZ : besitzt
    DOPPELSPIEL ||--o{ SATZ : besitzt

    EINZELSPIEL ||--o{ ELOPROTOKOLL : erzeugt
    SPIELER ||--o{ ELOPROTOKOLL : Spieler
    SPIELER ||--o{ ELOPROTOKOLL : Gegner
    ELOMONATSLAUF ||--o{ ELOPROTOKOLL : gehört_zu
```

---

## 4. Zentrale Beziehungen

### Spieler und Saison

```text
Saison
  |
  +-- SpielerSaison -- Spieler
  |
  +-- SpielerVerein -- Club
```

### Klassierung und Elo

```text
Saison
  |
  +-- Bewertungsperiode
          |
          +-- Klassierungsgrenze
          |
          +-- SpielerBewertung

EloMonatslauf
  |
  +-- SpielerElo
  |
  +-- EloProtokoll -- Einzelspiel
```

### Liga

```text
Saison
  |
  +-- Ligawettbewerb
          |
          +-- Ligaphase
                  |
                  +-- Mannschaft
                  |      |
                  |      +-- MannschaftSpieler
                  |
                  +-- Begegnung
                         |
                         +-- Begegnungsaufstellung
                         +-- Einzelspiel
                         +-- Doppelspiel
```

### Turnier

```text
Turnier
  |
  +-- TurnierKategorie
          |
          +-- Einzelanmeldung
          +-- Doppelanmeldung
          +-- Turniermannschaft
          |      |
          |      +-- TurniermannschaftSpieler
          |
          +-- Einzelspiel
          +-- Doppelspiel
```

### Resultate

```text
Einzelspiel ----+
                +---- Satz
Doppelspiel ----+

Einzelspiel ---- EloProtokoll
```

Nur Einzelspiele können Elo-Protokolle erzeugen.

---

## 5. Modellierungsentscheidungen

### Saisonabhängige Daten

Spieler-Stammdaten werden nicht pro Saison dupliziert. Saisonabhängige Informationen liegen in `SpielerSaison` und `SpielerVerein`.

### Historisierung

Offizielle Bewertungen und monatliche Elo-Werte werden nicht überschrieben, sondern über Bewertungsperioden und Monatsläufe historisiert.

### Liga und Turnier teilen Resultattabellen

`Einzelspiel` und `Doppelspiel` können entweder einer `Begegnung` oder einer `TurnierKategorie` zugeordnet sein.

### Gemeinsame Satztabelle

Die Tabelle `Satz` wird sowohl für Einzel- als auch Doppelspiele verwendet.

### Flexible Turnierstruktur

`TurnierKategorie` unterstützt unterschiedliche Wettkampfformen und Einschränkungen über Alter, Klassierung, Elo und Geschlecht.

### Nachvollziehbare Elo-Berechnung

`EloProtokoll` verbindet ein Elo-relevantes Einzelspiel mit Spieler, Gegner und Monatslauf.

---

## 6. Lesbarkeit des Gesamtmodells

Eine einzige Darstellung aller 39 Tabellen mit sämtlichen Attributen wäre nur schwer lesbar.

Deshalb ist das Gesamtmodell in folgende Fachbereiche aufgeteilt:

1. Stammdaten, Spieler und Elo
2. Benutzer und Vereinsfunktionen
3. Ligabetrieb und Mannschaften
4. Begegnungen
5. Turniere und Anmeldungen
6. Spiele, Resultate und Elo-Protokoll

Zusammen bilden diese Teilmodelle das vollständige relationale Schema.

Für Detailinformationen siehe:

- `Datenmodell.md`
- `Constraints.md`
- `Geschaeftsregeln.md`
