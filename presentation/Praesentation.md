<p align="center">
  <img src="../images/stt-logo-wide.png" alt="Swiss Table Tennis" width="600">
</p>

# STT-DB Modulararbeit II

## Relationale Datenbank für Swiss Table Tennis

**Autor:** Christian Abbühl  
**Klasse:** B-TIP-24-T-a  
**Modul:** Datenbanken_und_Big_Data  
**Abgabe / Präsentation:** 21.09.2026

**Technischer Endstand:** 39 Tabellen · 5 Views · 6 Stored Procedures · 5 Seed-Skripte · 3 Demo-Skripte

---

# 1. Ausgangslage

Swiss Table Tennis verwaltet viele miteinander verknüpfte Informationen:

- Spieler und Lizenznummern
- Clubs und Regionalverbände
- Saisons und Vereinszugehörigkeiten
- Elo-Werte und Klassierungen
- Ligawettbewerbe und Mannschaften
- Begegnungen und Resultate
- Turniere und Anmeldungen

Ziel war es, diese Bereiche in einer relationalen Datenbank strukturiert, nachvollziehbar und konsistent abzubilden.

### Was ich dazu sage

Die Herausforderung bestand nicht nur darin, einzelne Tabellen zu erstellen. Die verschiedenen Bereiche hängen stark zusammen und enthalten sowohl dauerhafte Stammdaten als auch saisonabhängige und historische Informationen. Deshalb war eine saubere Modellierung besonders wichtig.

---

# 2. Projektziel

Das Projekt sollte eine Datenbank bereitstellen, die:

- zentrale Prozesse des Schweizer Tischtennisbetriebs abbildet
- Datenintegrität direkt auf Datenbankebene sicherstellt
- historische Elo- und Klassierungsdaten speichert
- Geschäftslogik über Stored Procedures kapselt
- wiederkehrende Auswertungen über Views bereitstellt
- vollständig reproduzierbar aufgebaut werden kann
- einen nachvollziehbaren Demonstrationsablauf ermöglicht

### Abgrenzung

Nicht Bestandteil des Projekts sind:

- vollständige Web- oder Desktop-Anwendung
- komplette Turnierauslosung
- sämtliche Spezialregeln eines produktiven Verbandssystems
- vollständiges Rollen- und Berechtigungskonzept auf Anwendungsebene

### Was ich dazu sage

Der Schwerpunkt liegt bewusst auf Datenmodell, Datenintegrität und Datenbanklogik. Es handelt sich um ein Demonstrationsprojekt und nicht um eine vollständige Nachbildung eines produktiven Systems von Swiss Table Tennis.

---

# 3. Technische Architektur

```text
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

- Windows 11
- Vagrant
- VirtualBox
- Ubuntu 22.04
- Microsoft SQL Server 2022
- SQL Server Management Studio
- Git und GitHub

### Was ich dazu sage

SQL Server läuft nicht direkt auf meinem Windows-System, sondern in einer Linux-VM. Vagrant verwaltet diese Umgebung. SSMS verbindet sich über `127.0.0.1,1433` mit SQL Server. Dadurch sind Infrastruktur und Datenbankprojekt klar voneinander getrennt.

---

# 4. Datenmodell

Der finale Stand umfasst **39 Tabellen**.

Die wichtigsten Fachbereiche sind:

| Bereich | Beispiele |
|---|---|
| Stammdaten | Saison, Verband, Club, Spielort |
| Spieler | Spieler, SpielerSaison, SpielerVerein |
| Elo / Klassierung | SpielerBewertung, SpielerElo, EloProtokoll |
| Liga | Ligawettbewerb, Ligaphase, Mannschaft |
| Begegnungen | Begegnung, Aufstellung, Einzelspiel, Doppelspiel, Satz |
| Turniere | Turnier, TurnierKategorie, Einzelanmeldung, Doppelanmeldung |

Das vollständige ER-Modell befindet sich in:

`docs/ER-Diagramm.md`

### Zentrale Modellierungsentscheidung

Dauerhafte Spieler-Stammdaten werden von saisonabhängigen Daten getrennt.

```text
Spieler
   |
   +-- SpielerSaison
   |
   +-- SpielerVerein
```

### Was ich dazu sage

Ein Spieler wird nicht für jede Saison neu angelegt. Die Lizenznummer und Stammdaten bleiben bestehen. Saisonabhängige Informationen wie Alterskategorie oder Verein werden separat historisiert. Dadurch werden unnötige Duplikate vermieden.

---

# 5. Datenintegrität

Die Datenbank schützt gültige Zustände auf mehreren Ebenen:

- `PRIMARY KEY`
- `FOREIGN KEY`
- `UNIQUE`
- `CHECK`
- `DEFAULT`
- gefilterte UNIQUE-Indizes
- berechnete persistierte Spalten

Beispiele:

- höchstens eine aktuelle Saison
- Heim- und Gastmannschaft müssen verschieden sein
- ein Spieler kann pro Saison nur einen Hauptverein besitzen
- doppelte Doppelanmeldungen werden auch bei vertauschter Spielerreihenfolge verhindert
- ein Satz gehört genau zu einem Einzel- oder Doppelspiel
- ein Einzelspiel stammt genau aus Liga oder Turnier

### Was ich dazu sage

Ich habe versucht, Regeln möglichst dort abzusichern, wo sie dauerhaft gelten: direkt im Schema. Dadurch können fehlerhafte Datensätze nicht einfach durch eine falsche Anwendungseingabe entstehen.

---

# 6. Views und Stored Procedures

## 5 Views

1. `vw_SpielerAktuell`
2. `vw_MannschaftenLiga`
3. `vw_BegegnungenUebersicht`
4. `vw_Turnieranmeldungen`
5. `vw_Spielresultate`

## 6 Stored Procedures

1. `sp_SpielerAnmelden`
2. `sp_MannschaftSpielerHinzufuegen`
3. `sp_BegegnungErfassen`
4. `sp_BegegnungResultatErfassen`
5. `sp_TurnierEinzelAnmelden`
6. `sp_EloAktualisieren`

### Warum Stored Procedures?

- zentrale Geschäftsregeln an einem Ort
- Validierung vor Änderungen
- Transaktionen für mehrstufige Abläufe
- kontrollierte Fehlerbehandlung mit `TRY/CATCH` und `THROW`

### Was ich dazu sage

Constraints eignen sich für dauerhaft gültige Regeln innerhalb eines Datensatzes oder zwischen Schlüsseln. Abläufe, die mehrere Tabellen und aktuelle Zustände betreffen, habe ich dagegen in Stored Procedures umgesetzt.

---

# 7. Beispiel: Elo-Verarbeitung

Elo-relevant sind:

- `REGULAER`
- `AUFGABE`

Nicht Elo-relevant sind:

- `FORFAIT`
- `NICHTANGETRETEN`
- `ANNULLIERT`
- Doppelspiele

`sp_EloAktualisieren`:

1. prüft das Einzelspiel
2. ermittelt den Gegner
3. prüft den Elo-Monatslauf
4. erstellt einen Eintrag im `EloProtokoll`
5. erstellt oder aktualisiert `SpielerElo`

Beispiel aus der Demo:

| Spieler | Vorher | Nachher | Delta |
|---|---:|---:|---:|
| Leon Berger | 1350.000 | 1359.590 | +9.590 |
| Daniel Frei | 1385.000 | 1375.410 | -9.590 |

### Was ich dazu sage

Besonders wichtig war mir, die Berechnung nachvollziehbar zu machen. Deshalb wird nicht nur der neue Elo-Wert gespeichert, sondern zusätzlich ein Protokolleintrag mit Ausgangswerten, Gegner und Gewinnwahrscheinlichkeit.

---

# 8. Qualitätssicherung

Die Datenbank wurde auf mehreren Ebenen geprüft:

- Positivtests
- Negativtests
- Constraint-Prüfungen
- Seed-Prüfungen
- View-Abfragen
- vollständiger Rebuild
- vollständiger Demonstrationsablauf

## Rebuild-Test

`sql/scripts/99_RebuildTest.sql`

Der Test erstellt eine eigene Datenbank vollständig neu.

Erfolgreiches Ergebnis:

```text
========================================
ALLE REBUILD-PRUEFUNGEN ERFOLGREICH
========================================
39 Tabellen
5 Views
6 Stored Procedures
Seeds korrekt
========================================
```

### Was ich dazu sage

Der Rebuild-Test ist für mich der wichtigste technische Abschlussnachweis. Er zeigt, dass das Repository tatsächlich alle benötigten Skripte enthält und die Datenbank aus einem definierten Ausgangszustand wieder aufgebaut werden kann.

---

# 9. Live-Demo

Für die Demonstration gibt es drei aufeinander aufbauende SQL-Skripte:

```text
sql/demo/
├── 01_DemoDaten.sql
├── 02_DemoAblauf.sql
└── 03_PraesentationsDemo.sql
```

## Zweck der Demo-Skripte

### `01_DemoDaten.sql` – Ausgangslage

Dieses Skript erstellt eine definierte und reproduzierbare Demo-Datenbasis.

Dazu gehören unter anderem:

- Demo-Saison
- Clubs und Spielorte
- Spieler
- Mannschaften
- Liga und Ligaphase
- Turnier und Turnierkategorie
- Ausgangswerte für die Elo-Verarbeitung

Damit hängt die Demonstration nicht von zufällig bereits vorhandenen Daten ab.

### `02_DemoAblauf.sql` – vollständiger Geschäftsablauf

Dieses Skript führt den eigentlichen fachlichen Ablauf aus.

```text
Demo-Daten
    ↓
Spieler anmelden
    ↓
Spieler einer Mannschaft zuordnen
    ↓
Begegnung erfassen
    ↓
Einzelspiel und Sätze speichern
    ↓
Begegnungsresultat abschliessen
    ↓
Elo aktualisieren
    ↓
Turnieranmeldung
    ↓
Views prüfen
```

Dabei werden die implementierten Stored Procedures in einem zusammenhängenden Ablauf verwendet.

Unter anderem:

- `sp_SpielerAnmelden`
- `sp_MannschaftSpielerHinzufuegen`
- `sp_BegegnungErfassen`
- `sp_BegegnungResultatErfassen`
- `sp_EloAktualisieren`
- `sp_TurnierEinzelAnmelden`

Ein erfolgreicher vollständiger Ablauf endet mit:

```text
DEMO ERFOLGREICH ABGESCHLOSSEN
```

### `03_PraesentationsDemo.sql` – kurze Live-Demo

Dieses Skript ist speziell für die zeitlich begrenzte Präsentation vorgesehen.

Es zeigt kompakt:

- technischen Umfang der Datenbank
- alle 39 Tabellen
- alle 5 Views
- alle 6 Stored Procedures
- eine abgeschlossene Begegnung
- die historisierte Elo-Veränderung
- eine erfolgreiche Turnieranmeldung

## Ablauf während der Präsentation

Die gesamte Präsentation inklusive Live-Demo darf maximal **10 Minuten** dauern.

Deshalb werden `01_DemoDaten.sql` und `02_DemoAblauf.sql` nicht während der eigentlichen Präsentation vollständig ausgeführt.

Die Demo-Daten und der vollständige Geschäftsablauf werden vorher vorbereitet und getestet.

Live wird ausgeführt:

```text
03_PraesentationsDemo.sql
```

Dabei werden zunächst Umfang und Datenbankobjekte gezeigt:

```text
39 Tabellen
5 Views
6 Stored Procedures
```

Anschliessend werden die wichtigsten fachlichen Resultate gezeigt.

### Begegnung

```text
Siege Heim: 6
Siege Gast: 4
Mannschaftspunkte: 3 : 1
Status: ABGESCHLOSSEN
```

### Elo-Veränderung

```text
Leon Berger    +9.590
Daniel Frei    -9.590
```

### Turnieranmeldung

```text
Leon Berger
Open Einzel Demo
Status: ANGEMELDET
```

### Was ich dazu sage

Die Demo besteht aus drei Ebenen. `01_DemoDaten.sql` erzeugt zuerst eine reproduzierbare Ausgangslage. `02_DemoAblauf.sql` führt den vollständigen fachlichen Ablauf mit den Stored Procedures aus. Für die eigentliche Live-Präsentation verwende ich `03_PraesentationsDemo.sql`. Dieses Skript zeigt den technischen Umfang und die wichtigsten Ergebnisse kompakt, damit die gesamte Präsentation inklusive Demo innerhalb des Zeitlimits bleibt.

Falls der vollständige Ablauf gefragt ist, kann ich `02_DemoAblauf.sql` direkt zeigen.

Falls eine bestimmte Tabelle gefragt ist, kann ich diese im SSMS Object Explorer öffnen und die Struktur oder vorhandene Daten direkt anzeigen.

---

# 10. Herausforderungen und Lerngewinn

## Herausforderungen

- 39 Tabellen mit vielen Fremdschlüsselabhängigkeiten
- korrekte Erstellungsreihenfolge beim Rebuild
- Entscheidung zwischen Constraint und Stored Procedure
- Historisierung von Elo- und Bewertungsdaten
- lesbares ER-Modell trotz grossem Schema
- reproduzierbare Infrastruktur
- reproduzierbare Präsentationsdaten
- Präsentationsdemo innerhalb des Zeitlimits

## Lerngewinn

Besonders vertieft habe ich:

- referentielle Integrität
- komplexere CHECK-Constraints
- gefilterte UNIQUE-Indizes
- Stored Procedures
- Transaktionen
- `TRY/CATCH` und `THROW`
- Views
- SQLCMD
- Vagrant und SQL Server unter Linux
- Git / GitHub als Projektbasis

### Was ich dazu sage

Der grösste Lerngewinn war das Zusammenspiel dieser Themen. Erst durch Modellierung, Integritätsregeln, Geschäftslogik, Tests und Rebuild wurde aus einzelnen SQL-Skripten ein zusammenhängendes Datenbankprojekt.

---

# 11. Fazit

Der finale Projektstand umfasst:

- **39 Tabellen**
- **5 Views**
- **6 Stored Procedures**
- **5 Seed-Skripte**
- **3 Demo-Skripte**
- umfangreiche Constraints
- vollständiges ER-Modell
- technische Dokumentation
- erfolgreichen Rebuild-Test
- erfolgreich getesteten Demo-Ablauf
- kurze Präsentationsdemo
- versionierten Stand auf GitHub

## Ergebnis

Es liegt ein umfangreicher, getesteter, dokumentierter und reproduzierbarer Datenbankkern für zentrale Bereiche von Swiss Table Tennis vor.

### Was ich dazu sage

Das Projekt erfüllt das gesetzte Ziel. Nicht jede Funktion eines realen Verbandssystems ist umgesetzt, aber die gewählten Kernbereiche sind relational modelliert, technisch abgesichert, getestet und reproduzierbar dokumentiert.

Nach diesem Fazit wechsle ich direkt zu SSMS und führe die kurze Live-Demo aus. Nach der Demo muss nicht mehr zu PowerPoint zurückgewechselt werden.

---

# Präsentationstag – Vorbereitung

## Vor dem Start

- Repository auf aktuellen GitHub-Stand bringen
- VM frühzeitig starten
- SQL Server prüfen
- SSMS öffnen
- Verbindung zu `127.0.0.1,1433` herstellen
- `03_PraesentationsDemo.sql` öffnen
- Präsentationsdemo einmal testen
- PowerPoint öffnen
- Präsentationsmodus testen
- SSMS im Hintergrund für schnellen Wechsel bereithalten
- Benachrichtigungen deaktivieren
- Netzteil anschliessen
- Präsentation mit Stoppuhr üben

## Repository prüfen

```powershell
cd C:\GithubRepo\STT-DB_Modularbeit2
git pull
git status
```

Erwartet:

```text
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

## VM starten

```powershell
cd C:\GithubRepo\STT-DB_Modularbeit2\infrastructure
vagrant up
```

Status prüfen:

```powershell
vagrant status
```

Erwartet:

```text
default                   running (virtualbox)
```

SSH prüfen:

```powershell
vagrant ssh -c "echo VM_OK"
```

Erwartet:

```text
VM_OK
```

SQL Server prüfen:

```powershell
vagrant ssh -c "systemctl is-active mssql-server"
```

Erwartet:

```text
active
```

### Bekannte Besonderheit der VM

Beim ersten `vagrant up` kann Vagrant bei:

```text
Waiting for machine to boot...
```

hängen, obwohl VirtualBox die VM bereits gestartet hat.

Deshalb die VM am Präsentationstag frühzeitig starten und nicht erst unmittelbar vor der Präsentation.

---

# Fragen während oder nach der Präsentation

## Bestimmte Tabelle zeigen

Im SSMS Object Explorer:

```text
Databases
└── STT_DB
    └── Tables
```

Die gewünschte Tabelle auswählen.

Um vorhandene Daten zu zeigen:

```text
Rechtsklick → Select Top 1000 Rows
```

Um Struktur, Spalten und Datentypen zu zeigen:

```text
Rechtsklick → Design
```

Eine Tabelle kann zusätzlich aufgeklappt werden. Dort sind beispielsweise sichtbar:

```text
Columns
Keys
Constraints
Indexes
Statistics
```

## Vollständigen Geschäftsablauf zeigen

Falls gefragt wird, ob `03_PraesentationsDemo.sql` nur SELECT-Abfragen enthält:

> `03_PraesentationsDemo.sql` ist bewusst als kurze Präsentationsansicht aufgebaut. Der vollständige reproduzierbare Geschäftsablauf befindet sich in `02_DemoAblauf.sql`. Die definierte Ausgangslage wird mit `01_DemoDaten.sql` erzeugt.

Danach kann bei Bedarf `02_DemoAblauf.sql` im Editor gezeigt werden.

---

# Backup für die Präsentation

Falls die Live-Demo nicht funktioniert:

1. nicht während der Präsentation lange debuggen
2. `03_PraesentationsDemo.sql` im Editor zeigen
3. `02_DemoAblauf.sql` als vollständigen Geschäftsablauf zeigen
4. GitHub-Repository öffnen
5. `README.md` zeigen
6. `docs/ER-Diagramm.md` zeigen
7. `docs/Tests-und-Qualitaetssicherung.md` zeigen
8. erfolgreichen Rebuild und die bereits getesteten Demo-Ergebnisse erklären

Der technische Projektstand wurde vor der Präsentation vollständig getestet.

---

# Letzter Kurzcheck

Unmittelbar vor der Präsentation:

- [ ] Netzteil angeschlossen
- [ ] VM läuft
- [ ] SSH funktioniert
- [ ] SQL Server ist `active`
- [ ] SSMS ist verbunden
- [ ] `03_PraesentationsDemo.sql` ist geöffnet
- [ ] Präsentationsdemo wurde getestet
- [ ] PowerPoint ist geöffnet
- [ ] richtige Präsentationsversion ist geöffnet
- [ ] Präsentationsmodus funktioniert
- [ ] SSMS liegt für den schnellen Wechsel bereit
- [ ] Benachrichtigungen sind deaktiviert
- [ ] Zeitlimit im Kopf: maximal 10 Minuten
- [ ] Präsentation und Demo wurden mit Stoppuhr geübt

## Wichtig

Am Präsentationstag keine neuen Funktionen mehr einbauen und keine unnötigen Änderungen am Datenbankstand durchführen.

Der Schwerpunkt liegt auf einer kurzen, verständlichen Präsentation und einer stabilen Live-Demo.

---

Repository:

`https://github.com/19boboy97/STT-DB_Modularbeit2/tree/main`