# ER-Diagramm

## 1. Zweck

Dieses Dokument visualisiert das relationale Datenmodell der
STT-Datenbank.

Da das finale Schema 39 Tabellen umfasst, werden zwei Darstellungen
verwendet:

1.  **Fachübersicht** -- zeigt die wichtigsten Bereiche und
    Zusammenhänge in kompakter Form.
2.  **Gesamtmodell** -- zeigt alle 39 Tabellen mit ihren Primär- und
    Fremdschlüsselbeziehungen.

Die vollständigen Attribute, Constraints und Geschäftsregeln sind
separat in `Datenmodell.md`, `Constraints.md` und `Geschaeftsregeln.md`
dokumentiert. Das ER-Diagramm konzentriert sich deshalb bewusst auf
Struktur und Beziehungen.

------------------------------------------------------------------------

## 2. Fachübersicht

``` mermaid
flowchart LR
    Stammdaten["Stammdaten<br/>Saison · Verband · Club<br/>Spielort · Alterskategorie<br/>Klassierungsstufe"]

    Spieler["Spieler / Elo<br/>Spieler · SpielerSaison<br/>SpielerVerein · SpielerBewertung<br/>SpielerElo · EloProtokoll"]

    Liga["Ligabetrieb<br/>Ligawettbewerb · Ligaphase<br/>Mannschaft · MannschaftSpieler<br/>Spielsystem · Ball"]

    Begegnung["Begegnungen<br/>Begegnung · Aufstellung<br/>Bemerkung · Änderung"]

    Spiele["Spiele / Resultate<br/>Einzelspiel · Doppelspiel<br/>Satz"]

    Turnier["Turniere<br/>Turnier · TurnierKategorie<br/>Einzel-/Doppelanmeldung<br/>Turniermannschaft"]

    Benutzer["Benutzer / Funktionen<br/>Benutzer · Funktion<br/>Vereinsfunktionaer"]

    Stammdaten --> Spieler
    Stammdaten --> Liga
    Stammdaten --> Turnier
    Spieler --> Liga
    Liga --> Begegnung
    Begegnung --> Spiele
    Turnier --> Spiele
    Spieler --> Turnier
    Spieler --> Spiele
    Benutzer --> Liga
    Benutzer --> Begegnung
```

------------------------------------------------------------------------

## 3. Gesamtmodell

### 3.1 Stammdaten, Spieler und Elo

``` mermaid
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
        int RegionalverbandID FK
    }

    SPIELORT {
        int SpielortID PK
        int VereinsNr FK
        nvarchar Bezeichnung
        nvarchar Ort
        bit IstHauptspielort
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
        varchar Klassierungstyp
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
    }

    ELOMONATSLAUF {
        bigint EloMonatslaufID PK
        date Berechnungsdatum
        date PeriodeVon
        date PeriodeBis
        varchar Status
    }

    SPIELERELO {
        bigint SpielerEloID PK
        int LizenzNr FK
        bigint EloMonatslaufID FK
        decimal Elo
        decimal EloDelta
        tinyint HerrenStufenwert FK
        tinyint DamenStufenwert FK
    }

    VERBAND ||--o{ VERBAND : "übergeordnet"
    VERBAND ||--o{ CLUB : "Regionalverband"
    CLUB ||--o{ SPIELORT : besitzt

    SPIELER ||--o{ SPIELERSAISON : hat
    SAISON ||--o{ SPIELERSAISON : umfasst
    ALTERSKATEGORIE ||--o{ SPIELERSAISON : klassifiziert

    SPIELER ||--o{ SPIELERVEREIN : gehört_zu
    SAISON ||--o{ SPIELERVEREIN : gilt_in
    CLUB ||--o{ SPIELERVEREIN : Verein

    SAISON ||--o{ BEWERTUNGSPERIODE : besitzt
    BEWERTUNGSPERIODE ||--o{ KLASSIERUNGSGRENZE : definiert
    KLASSIERUNGSSTUFE ||--o{ KLASSIERUNGSGRENZE : Stufe

    SPIELER ||--o{ SPIELERBEWERTUNG : erhält
    BEWERTUNGSPERIODE ||--o{ SPIELERBEWERTUNG : bewertet_in
    KLASSIERUNGSSTUFE ||--o{ SPIELERBEWERTUNG : Herrenstufe
    KLASSIERUNGSSTUFE ||--o{ SPIELERBEWERTUNG : Damenstufe
    ALTERSKATEGORIE ||--o{ SPIELERBEWERTUNG : Altersklasse

    SPIELER ||--o{ SPIELERELO : besitzt
    ELOMONATSLAUF ||--o{ SPIELERELO : erzeugt
    KLASSIERUNGSSTUFE ||--o{ SPIELERELO : Herrenstufe
    KLASSIERUNGSSTUFE ||--o{ SPIELERELO : Damenstufe
```

------------------------------------------------------------------------

### 3.2 Benutzer und Vereinsfunktionen

``` mermaid
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
        int VereinsfunktionaerID PK
        int VereinsNr FK
        nvarchar Vorname
        nvarchar Nachname
        bit Aktiv
    }

    FUNKTIONAERFUNKTION {
        int VereinsfunktionaerID PK,FK
        int FunktionID PK,FK
        date GueltigAb PK
        date GueltigBis
    }

    BENUTZER {
        int BenutzerID PK
        nvarchar Benutzername
        int LizenzNr FK
        int VereinsNr FK
        int VerbandID FK
        varchar Rolle
        bit Aktiv
    }

    CLUB ||--o{ VEREINSFUNKTIONAER : beschäftigt
    VEREINSFUNKTIONAER ||--o{ FUNKTIONAERFUNKTION : besitzt
    FUNKTION ||--o{ FUNKTIONAERFUNKTION : wird_zugeordnet

    SPIELER ||--o{ BENUTZER : kann_besitzen
    CLUB ||--o{ BENUTZER : kann_besitzen
    VERBAND ||--o{ BENUTZER : kann_besitzen
```

------------------------------------------------------------------------

### 3.3 Ligabetrieb und Mannschaften

``` mermaid
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
        nvarchar Farbe
    }

    SPIELSYSTEM {
        int SpielsystemID PK
        nvarchar Bezeichnung
        tinyint AnzahlSpieler
        tinyint AnzahlEinzel
        tinyint AnzahlDoppel
        tinyint MaxAnzahlSpiele
    }

    LIGAWETTBEWERB {
        int LigawettbewerbID PK
        int SaisonID FK
        int VerbandID FK
        varchar Alterskategorie FK
        int SpielsystemID FK
        varchar Geschlecht
    }

    LIGAPHASE {
        int LigaphaseID PK
        int LigawettbewerbID FK
        int KlassenleiterBenutzerID FK
        varchar Phasentyp
        nvarchar Gruppenbezeichnung
    }

    MANNSCHAFT {
        int MannschaftID PK
        int VereinsNr FK
        int LigaphaseID FK
        int KapitaenLizenz FK
        int BallID FK
        int MannschaftsNr
        bit Aktiv
    }

    MANNSCHAFTSPIELER {
        bigint MannschaftSpielerID PK
        int MannschaftID FK
        int LizenzNr FK
        varchar Meldungsart
        tinyint StammPosition
        bit Spielberechtigt
    }

    BENUTZERMANNSCHAFT {
        int BenutzerID PK,FK
        int MannschaftID PK,FK
    }

    SAISON ||--o{ LIGAWETTBEWERB : enthält
    VERBAND ||--o{ LIGAWETTBEWERB : organisiert
    ALTERSKATEGORIE ||--o{ LIGAWETTBEWERB : begrenzt
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

------------------------------------------------------------------------

### 3.4 Begegnungen

``` mermaid
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
        int GenehmigtVonBenutzerID FK
        int Runde
        date Spieldatum
        varchar Status
        bit MatchblattGenehmigt
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
    }

    BEGEGNUNGAENDERUNG {
        bigint BegegnungAenderungID PK
        bigint BegegnungID FK
        int BenutzerID FK
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

------------------------------------------------------------------------

### 3.5 Turniere und Anmeldungen

``` mermaid
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
        int VeranstalterVereinsNr FK
        int SpielortID FK
        nvarchar Name
        date Startdatum
        date Meldeschluss
        varchar Status
    }

    TURNIERKATEGORIE {
        int TurnierKategorieID PK
        int TurnierID FK
        varchar Alterskategorie FK
        tinyint MinStufenwert FK
        tinyint MaxStufenwert FK
        varchar Kategorieart
        varchar Wettkampfform
        varchar Geschlecht
        varchar Altersregel
    }

    EINZELANMELDUNG {
        bigint EinzelanmeldungID PK
        int TurnierKategorieID FK
        int LizenzNr FK
        varchar Status
    }

    DOPPELANMELDUNG {
        bigint DoppelanmeldungID PK
        int TurnierKategorieID FK
        int Spieler1LizenzNr FK
        int Spieler2LizenzNr FK
        int SpielerMinLizenz
        int SpielerMaxLizenz
        varchar Status
    }

    TURNIERMANNSCHAFT {
        int TurniermannschaftID PK
        int TurnierKategorieID FK
        nvarchar Mannschaftsname
        varchar Status
    }

    TURNIERMANNSCHAFTSPIELER {
        int TurniermannschaftID PK,FK
        int LizenzNr PK,FK
        tinyint Position
        bit IstCaptain
    }

    SAISON ||--o{ TURNIER : enthält
    BEWERTUNGSPERIODE ||--o{ TURNIER : bewertet_nach
    CLUB ||--o{ TURNIER : veranstaltet
    SPIELORT ||--o{ TURNIER : findet_statt_in

    TURNIER ||--o{ TURNIERKATEGORIE : besitzt
    ALTERSKATEGORIE ||--o{ TURNIERKATEGORIE : Altersgrenze
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

------------------------------------------------------------------------

### 3.6 Einzelspiele, Doppelspiele, Sätze und Elo-Protokoll

``` mermaid
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
        int Spieler1LizenzNr FK
        int Spieler2LizenzNr FK
        int GewinnerLizenzNr FK
        varchar Spielgrund
        varchar Status
    }

    DOPPELSPIEL {
        bigint DoppelspielID PK
        bigint BegegnungID FK
        int TurnierKategorieID FK
        int Spieler1LizenzNr FK
        int Spieler2LizenzNr FK
        int Spieler3LizenzNr FK
        int Spieler4LizenzNr FK
        tinyint GewinnerSeite
        varchar Spielgrund
        varchar Status
    }

    SATZ {
        bigint SatzID PK
        bigint EinzelspielID FK
        bigint DoppelspielID FK
        tinyint SatzNummer
        smallint Punkte1
        smallint Punkte2
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
    }

    BEGEGNUNG ||--o{ EINZELSPIEL : enthält
    TURNIERKATEGORIE ||--o{ EINZELSPIEL : enthält
    SPIELER ||--o{ EINZELSPIEL : Spieler1
    SPIELER ||--o{ EINZELSPIEL : Spieler2
    SPIELER ||--o{ EINZELSPIEL : Gewinner

    BEGEGNUNG ||--o{ DOPPELSPIEL : enthält
    TURNIERKATEGORIE ||--o{ DOPPELSPIEL : enthält
    SPIELER ||--o{ DOPPELSPIEL : Spieler1
    SPIELER ||--o{ DOPPELSPIEL : Spieler2
    SPIELER ||--o{ DOPPELSPIEL : Spieler3
    SPIELER ||--o{ DOPPELSPIEL : Spieler4

    EINZELSPIEL ||--o{ SATZ : besitzt
    DOPPELSPIEL ||--o{ SATZ : besitzt

    EINZELSPIEL ||--o{ ELOPROTOKOLL : erzeugt
    SPIELER ||--o{ ELOPROTOKOLL : Spieler
    SPIELER ||--o{ ELOPROTOKOLL : Gegner
    ELOMONATSLAUF ||--o{ ELOPROTOKOLL : gehört_zu
```

------------------------------------------------------------------------

## 4. Zentrale Beziehungen

Die wichtigsten fachlichen Beziehungsketten des Modells sind:

### Spieler und Saison

``` text
Saison
  |
  +-- SpielerSaison -- Spieler
  |
  +-- SpielerVerein -- Club
```

Dadurch bleiben dauerhafte Spieler-Stammdaten von saisonabhängigen
Informationen getrennt.

### Klassierung und Elo

``` text
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

Offizielle Bewertungen und laufende monatliche Elo-Entwicklung werden
damit getrennt historisiert.

### Liga

``` text
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

``` text
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

``` text
Einzelspiel ----+
                +---- Satz
Doppelspiel ----+

Einzelspiel ---- EloProtokoll
```

Nur Einzelspiele können eine Elo-Berechnung auslösen.

------------------------------------------------------------------------

## 5. Modellierungsentscheidungen

### Saisonabhängige Daten

Spieler-Stammdaten werden nicht für jede Saison dupliziert.
Saisonabhängige Informationen befinden sich in eigenen Tabellen wie
`SpielerSaison` und `SpielerVerein`.

### Historisierung

Bewertungen und Elo-Werte werden nicht einfach überschrieben.
Bewertungsperioden und Monatsläufe ermöglichen eine historische
Nachvollziehbarkeit.

### Liga und Turnier teilen Resultattabellen

`Einzelspiel` und `Doppelspiel` werden sowohl für Ligabegegnungen als
auch für Turnierkategorien verwendet. Ein Spiel gehört dabei genau zu
einer dieser beiden Quellen.

### Gemeinsame Satztabelle

Einzel- und Doppelspiele verwenden dieselbe Tabelle `Satz`. Ein Satz
gehört genau zu einem Einzel- oder Doppelspiel.

### Flexible Turnierstruktur

Turnierkategorien bilden unterschiedliche Wettkampfformen und
Einschränkungen ab. Dadurch werden Einzel-, Doppel- und
Mannschaftswettbewerbe innerhalb desselben Modells unterstützt.

### Nachvollziehbare Elo-Berechnung

Das `EloProtokoll` verbindet ein Elo-relevantes Einzelspiel mit Spieler,
Gegner und Monatslauf. Dadurch kann die Berechnungsgrundlage später
nachvollzogen werden.

------------------------------------------------------------------------

## 6. Lesbarkeit des Gesamtmodells

Eine einzige grafische Darstellung aller 39 Tabellen inklusive aller
Attribute und Beziehungen wäre nur schwer lesbar.

Deshalb ist das Modell in diesem Dokument fachlich aufgeteilt:

1.  Stammdaten, Spieler und Elo
2.  Benutzer und Vereinsfunktionen
3.  Ligabetrieb und Mannschaften
4.  Begegnungen
5.  Turniere und Anmeldungen
6.  Spiele, Resultate und Elo-Protokoll

Zusammen bilden diese Teilmodelle das vollständige relationale Schema
der Datenbank.

Für Detailinformationen zu einzelnen Tabellen siehe:

-   `Datenmodell.md`
-   `Constraints.md`
-   `Geschaeftsregeln.md`
