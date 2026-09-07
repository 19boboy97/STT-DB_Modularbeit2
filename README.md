<p align="center">
  <img src="images/stt-logo-wide.png" alt="Swiss Table Tennis" width="600">
</p>

# STT-DB Modulararbeit II

Datenbankimplementierung für Swiss Table Tennis auf Basis von Microsoft
SQL Server 2022.

Das Projekt bildet zentrale Bereiche des Schweizer Tischtennisbetriebs
relational ab: Verbände und Clubs, Spieler und Vereinszugehörigkeiten,
Elo und Klassierungen, Ligawettbewerbe und Mannschaften, Begegnungen und
Resultate sowie Turniere und Anmeldungen.

## Projektziel

Ziel der Modulararbeit ist die Konzeption und Implementierung einer
strukturierten, nachvollziehbaren und reproduzierbaren relationalen
Datenbank.

Neben dem eigentlichen Datenmodell liegt ein Schwerpunkt auf:

-   Datenintegrität durch Primär- und Fremdschlüssel, UNIQUE-Regeln und
    CHECK-Constraints
-   Historisierung von Elo- und Klassierungsdaten
-   Abbildung von Liga- und Turnierbetrieb
-   Geschäftslogik über Stored Procedures
-   wiederverwendbaren Auswertungen über Views
-   Transaktionen und Fehlerbehandlung
-   reproduzierbarer Infrastruktur mit Vagrant
-   automatisiertem vollständigem Rebuild-Test

## Technische Architektur

``` text
Windows 11
    |
    | Vagrant / VirtualBox
    v
Ubuntu 22.04 VM
    |
    v
Microsoft SQL Server 2022
    ^
    |
    | TCP 1433
    |
SQL Server Management Studio
```

Verwendete Technologien:

-   Windows 11
-   Vagrant
-   VirtualBox
-   Ubuntu 22.04
-   Microsoft SQL Server 2022
-   SQL Server Management Studio (SSMS)
-   Git
-   GitHub

## Implementierungsumfang

Der finale Datenbankstand umfasst:

  Bereich               Umfang
  ------------------- --------
  Tabellen                  39
  Views                      5
  Stored Procedures          6
  Seed-Skripte               5

Die Datenbank kann über den Rebuild-Test vollständig neu erstellt und
kontrolliert werden.

## Fachliche Bereiche

### Verbände und Clubs

Abgebildet werden der nationale Verband, Regionalverbände, Clubs und
deren Spielorte.

### Spieler und Vereinszugehörigkeiten

Spieler besitzen eine dauerhafte Lizenznummer. Saisonabhängige
Informationen wie Alterskategorie, Lizenzstatus, Hauptverein und
Mehrfachlizenz werden getrennt gespeichert.

### Elo und Klassierungen

Das Modell unterscheidet zwischen offiziellen Bewertungsperioden und
monatlichen Elo-Läufen.

Unter anderem werden gespeichert:

-   Elo-Werte
-   Herrenklassierung
-   optionale Damenklassierung
-   Klassierungsgrenzen
-   Ranginformationen
-   monatliche Elo-Historie
-   Elo-Protokolle einzelner relevanter Spiele

### Ligabetrieb

Der Ligabereich umfasst:

-   Ligawettbewerbe
-   Ligaphasen
-   Spielsysteme
-   Mannschaften
-   Stamm- und Ersatzspieler
-   Mannschaftskapitäne
-   Begegnungen
-   Aufstellungen
-   Bemerkungen und Änderungen

### Resultate

Resultate können bis auf Satzebene gespeichert werden.

Das Modell unterscheidet:

-   Einzelspiele
-   Doppelspiele
-   Sätze

Einzel- und Doppelspiele können sowohl aus einer Ligabegegnung als auch
aus einer Turnierkategorie stammen.

### Turniere

Der Turnierbereich unterstützt:

-   Turniere
-   flexible Turnierkategorien
-   Einzelanmeldungen
-   Doppelanmeldungen
-   Turniermannschaften
-   Spieler von Turniermannschaften

Turnierkategorien können unter anderem nach Alter, Klassierung, Elo,
Geschlecht und Wettkampfform definiert werden.

## Projektstruktur

``` text
STT-DB_Modulararbeit2/
├── docs/
│   ├── Fachkonzept.md
│   ├── Datenmodell.md
│   ├── Constraints.md
│   └── Geschaeftsregeln.md
│
├── infrastructure/
│   ├── Vagrantfile
│   └── README.md
│
├── sql/
│   ├── tables/
│   ├── seed/
│   ├── views/
│   ├── procedures/
│   └── scripts/
│
├── images/
├── tests/
└── README.md
```

## Tabellen

Die 39 Tabellenskripte befinden sich unter:

``` text
sql/tables/
```

Die Nummerierung unterstützt eine nachvollziehbare Struktur. Beim
vollständigen Rebuild wird die tatsächliche Erstellungsreihenfolge
zusätzlich an die Fremdschlüsselabhängigkeiten angepasst.

Die Tabellen decken unter anderem folgende Bereiche ab:

-   Stammdaten
-   Spieler und Saison
-   Vereine und Verbände
-   Elo und Klassierungen
-   Benutzer und Funktionen
-   Ligabetrieb
-   Begegnungen
-   Turniere
-   Spielresultate

## Seed-Daten

Unter:

``` text
sql/seed/
```

befinden sich fünf Seed-Skripte für grundlegende Referenzdaten.

Enthalten sind:

-   10 Verbände
-   9 Alterskategorien
-   22 Klassierungsstufen
-   1 Spielsystem
-   3 Bälle

Diese Daten werden auch durch den vollständigen Rebuild-Test
kontrolliert.

## Views

Die Datenbank enthält fünf Views:

1.  `vw_SpielerAktuell`
2.  `vw_MannschaftenLiga`
3.  `vw_BegegnungenUebersicht`
4.  `vw_Turnieranmeldungen`
5.  `vw_Spielresultate`

Die Views stellen häufig benötigte Informationen bereits zusammengeführt
zur Verfügung und vereinfachen Auswertungen.

## Stored Procedures

Für zentrale Geschäftsabläufe wurden sechs Stored Procedures
implementiert:

1.  `sp_SpielerAnmelden`
2.  `sp_MannschaftSpielerHinzufuegen`
3.  `sp_BegegnungErfassen`
4.  `sp_BegegnungResultatErfassen`
5.  `sp_TurnierEinzelAnmelden`
6.  `sp_EloAktualisieren`

Die Procedures führen fachliche Prüfungen durch und verwenden bei
zusammengehörenden Änderungen Transaktionen.

Beispiele dafür sind:

-   saisonale Spieleranmeldung
-   Hinzufügen eines Mannschaftsspielers
-   Erfassen einer Begegnung
-   Abschluss eines Begegnungsresultats
-   Einzelanmeldung zu einem Turnier
-   Aktualisierung eines Elo-Stands

## Datenintegrität

Die Datenbank verwendet verschiedene Mechanismen zur Absicherung der
Daten:

-   `PRIMARY KEY`
-   `FOREIGN KEY`
-   `UNIQUE`
-   `CHECK`
-   `DEFAULT`
-   gefilterte UNIQUE-Indizes

Beispiele für speziell abgesicherte Regeln:

-   höchstens eine aktuelle Saison
-   höchstens ein aktiver Hauptspielort pro Club
-   höchstens ein Hauptverein pro Spieler und Saison
-   keine vertauschten doppelten Doppelanmeldungen
-   höchstens ein Captain pro Turniermannschaft
-   eindeutige Satznummern innerhalb eines Spiels
-   konsistente Herkunft von Einzelspielen, Doppelspielen und Sätzen

Die technischen Details sind in `docs/Constraints.md` dokumentiert.

## Rebuild-Test

Der vollständige Rebuild-Test befindet sich unter:

``` text
sql/scripts/99_RebuildTest.sql
```

Das Skript wird in SSMS im SQLCMD-Modus ausgeführt.

Es erstellt eine separate Testdatenbank neu und bindet Tabellen,
Seed-Daten, Views und Stored Procedures ein.

Anschließend werden die erwarteten Objektzahlen und Seed-Daten geprüft.
Zusätzlich werden die Views ausgeführt.

Ein erfolgreicher Durchlauf endet mit:

``` text
========================================
ALLE REBUILD-PRUEFUNGEN ERFOLGREICH
========================================
39 Tabellen
5 Views
6 Stored Procedures
Seeds korrekt
========================================
```

Damit wird nachgewiesen, dass die Datenbank aus den versionierten
Skripten vollständig reproduzierbar aufgebaut werden kann.

## Infrastruktur starten

In PowerShell:

``` powershell
cd C:\GithubRepo\STT-DB_Modularbeit2\infrastructure
vagrant up
```

Status prüfen:

``` powershell
vagrant status
```

Die Verbindung mit SQL Server Management Studio erfolgt über:

``` text
127.0.0.1,1433
```

Weitere Informationen befinden sich in:

``` text
infrastructure/README.md
```

## Infrastruktur herunterfahren

Nach der Arbeit:

``` powershell
cd C:\GithubRepo\STT-DB_Modularbeit2\infrastructure
vagrant halt
```

Danach kann der Zustand geprüft werden:

``` powershell
vagrant status
```

Erwartet wird:

``` text
default poweroff (virtualbox)
```

## Dokumentation

Die Projektdokumentation ist auf mehrere Dateien verteilt:

### `docs/Fachkonzept.md`

Beschreibt Ausgangslage, Projektziel, fachliche Schwerpunkte, Abgrenzung
und die grundlegende Zielsetzung des Systems.

### `docs/Datenmodell.md`

Beschreibt die 39 Tabellen, ihre Aufgaben, zentralen Attribute und
Beziehungen.

### `docs/Constraints.md`

Dokumentiert die tatsächlich implementierten Integritätsregeln wie
Primärschlüssel, Fremdschlüssel, CHECK-Constraints und eindeutige
Indizes.

### `docs/Geschaeftsregeln.md`

Beschreibt die fachlichen Regeln und Abläufe unabhängig von ihrer
konkreten technischen Umsetzung.

### `infrastructure/README.md`

Dokumentiert die virtuelle Umgebung, SQL-Server-Verbindung, Start und
Stopp der VM sowie den Rebuild-Ablauf.

## Qualitätssicherung

Die Implementierung wurde auf mehreren Ebenen geprüft:

-   Positivtests für Stored Procedures
-   Negativtests für ungültige Eingaben
-   Prüfung von Constraints
-   Prüfung von Fremdschlüsselabhängigkeiten
-   Ausführung der Views
-   Prüfung der Seed-Daten
-   vollständiger Neuaufbau über `99_RebuildTest.sql`

Der erfolgreiche Rebuild ist die zentrale technische Abschlusskontrolle.

## Demonstrationsablauf

Für eine Präsentation lässt sich ein zusammenhängender Ablauf
demonstrieren:

``` text
Spieler anmelden
      ↓
Mannschaft zuordnen
      ↓
Begegnung erfassen
      ↓
Resultat erfassen
      ↓
Elo aktualisieren
      ↓
Views auswerten
```

Zum Abschluss kann der vollständige Rebuild-Test ausgeführt werden.

## Projektstand

Die Kernimplementierung der Datenbank ist abgeschlossen.

Der aktuelle Stand umfasst:

-   finales relationales Schema
-   39 Tabellen
-   Seed-Daten
-   5 Views
-   6 Stored Procedures
-   Constraints und Geschäftsregeln
-   Vagrant-/SQL-Server-Infrastruktur
-   erfolgreichen vollständigen Rebuild-Test
-   technische Projektdokumentation

Damit liegt eine reproduzierbare und dokumentierte
Datenbankimplementierung für die im Projekt definierten Bereiche von
Swiss Table Tennis vor.