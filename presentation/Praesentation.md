# STT-DB Modulararbeit II

## Relationale Datenbank für Swiss Table Tennis

**Autor:** Christian Abbühl  
**Klasse:** B-TIP-24-T-a  
**Modul:** Datenbanken_und_Big_Data  
**Abgabe / Präsentation:** 21.09.2026

**Technischer Endstand:** 39 Tabellen · 5 Views · 6 Stored Procedures · 5 Seed-Skripte · 2 Demo-Skripte

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

Für die Präsentation gibt es zwei reproduzierbare Demo-Skripte:

```text
sql/demo/
├── 01_DemoDaten.sql
└── 02_DemoAblauf.sql
```

## Ablauf

```text
Demo-Daten erstellen
      ↓
Spieler anmelden
      ↓
Spieler Mannschaft zuordnen
      ↓
Begegnung erfassen
      ↓
Einzelspiel und Sätze
      ↓
Begegnungsresultat abschliessen
      ↓
Elo aktualisieren
      ↓
Turnieranmeldung
      ↓
Views anzeigen
```

Ein erfolgreicher Ablauf endet mit:

```text
DEMO ERFOLGREICH ABGESCHLOSSEN
```

### Was ich in der Live-Demo zeige

1. `01_DemoDaten.sql` ausführen
2. `02_DemoAblauf.sql` ausführen
3. Begegnung mit Resultat zeigen
4. Elo-Veränderung zeigen
5. Turnieranmeldung zeigen
6. ausgewählte View-Ergebnisse zeigen

### Was ich dazu sage

Die Demo ist bewusst reproduzierbar. Sie hängt nicht von zufällig vorhandenen Datensätzen ab, sondern verwendet eine definierte Demo-Datenbasis.

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
- **2 Demo-Skripte**
- umfangreiche Constraints
- vollständiges ER-Modell
- technische Dokumentation
- erfolgreichen Rebuild-Test
- erfolgreich getesteten Demo-Ablauf
- versionierten Stand auf GitHub

## Ergebnis

Es liegt ein umfangreicher, getesteter, dokumentierter und reproduzierbarer Datenbankkern für zentrale Bereiche von Swiss Table Tennis vor.

### Was ich dazu sage

Das Projekt erfüllt das gesetzte Ziel. Nicht jede Funktion eines realen Verbandssystems ist umgesetzt, aber die gewählten Kernbereiche sind relational modelliert, technisch abgesichert, getestet und reproduzierbar dokumentiert.

---

# Backup für die Präsentation

Falls die Live-Demo nicht funktioniert:

1. GitHub-Repository öffnen
2. `README.md` zeigen
3. `docs/ER-Diagramm.md` zeigen
4. `docs/Tests-und-Qualitaetssicherung.md` zeigen
5. `sql/demo/02_DemoAblauf.sql` zeigen
6. erfolgreichen Rebuild und Demo-Ergebnisse erklären

Repository:

`https://github.com/19boboy97/STT-DB_Modularbeit2/tree/main`
