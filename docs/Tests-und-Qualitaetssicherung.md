# Tests und Qualitätssicherung

## 1. Zweck

Dieses Dokument beschreibt die Qualitätssicherung der STT-Datenbank. Ziel der Tests ist der Nachweis, dass das Datenbankschema reproduzierbar aufgebaut werden kann, zentrale Geschäftsregeln eingehalten werden und die implementierten Stored Procedures sowie Views wie vorgesehen funktionieren.

Die Qualitätssicherung umfasst insbesondere:

- vollständigen Neuaufbau der Datenbank,
- Prüfung der erwarteten Datenbankobjekte,
- Prüfung der Seed-Daten,
- Positiv- und Negativtests der Stored Procedures,
- Prüfung von Constraints und Geschäftsregeln,
- Ausführung der Views,
- Prüfung von Transaktionen und Fehlerbehandlung.

---

## 2. Teststrategie

Die Tests wurden auf mehreren Ebenen durchgeführt.

### 2.1 Strukturtests

Strukturtests prüfen, ob alle vorgesehenen Datenbankobjekte vorhanden sind.

Der finale Stand umfasst:

| Objekttyp | Erwartete Anzahl |
|---|---:|
| Tabellen | 39 |
| Views | 5 |
| Stored Procedures | 6 |
| Seed-Skripte | 5 |

### 2.2 Integritätstests

Die Datenintegrität wird durch Primärschlüssel, Fremdschlüssel, `UNIQUE`-Constraints, `CHECK`-Constraints, Defaultwerte und gefilterte eindeutige Indizes abgesichert.

Negativtests versuchen gezielt, fachlich ungültige Daten einzufügen oder ungültige Zustandsänderungen auszuführen. Ein Test gilt als erfolgreich, wenn SQL Server die Operation wie vorgesehen verhindert.

### 2.3 Funktionstests

Die Stored Procedures wurden mit gültigen und ungültigen Eingaben getestet. Dabei wurde geprüft, ob:

- gültige Vorgänge erfolgreich gespeichert werden,
- ungültige Vorgänge abgewiesen werden,
- abhängige Daten korrekt geprüft werden,
- keine unvollständigen Änderungen zurückbleiben.

### 2.4 Rebuild-Test

Der wichtigste technische Gesamttest ist `sql/scripts/99_RebuildTest.sql`.

Das Skript erstellt eine neue Testdatenbank und führt den gesamten Aufbau in definierter Reihenfolge aus. Dadurch wird geprüft, ob das Projekt unabhängig von einem bereits vorhandenen Datenbankzustand reproduzierbar ist.

---

## 3. Testumgebung

Die Tests wurden in der für das Projekt vorgesehenen Umgebung durchgeführt:

- Windows 11 als Hostsystem
- Vagrant
- VirtualBox
- Ubuntu 22.04 als virtuelle Maschine
- Microsoft SQL Server 2022 unter Linux
- SQL Server Management Studio als Administrations- und Testwerkzeug
- Verbindung über `127.0.0.1,1433`

Für den vollständigen Rebuild wird in SSMS der SQLCMD-Modus verwendet, da das Rebuild-Skript weitere SQL-Dateien über `:r` einbindet.

---

## 4. Rebuild-Test

### 4.1 Ziel

Der Rebuild-Test stellt sicher, dass die Datenbank aus den versionierten SQL-Dateien vollständig neu aufgebaut werden kann.

Damit werden unter anderem folgende Fehler erkannt:

- fehlende SQL-Dateien,
- falsche Ausführungsreihenfolge,
- ungültige Fremdschlüsselabhängigkeiten,
- Syntaxfehler,
- fehlende Views,
- fehlende Stored Procedures,
- fehlerhafte Seed-Daten.

### 4.2 Ablauf

Das Skript

```text
sql/scripts/99_RebuildTest.sql
```

führt im Wesentlichen folgende Schritte aus:

1. Testdatenbank entfernen, falls sie bereits existiert.
2. Testdatenbank neu erstellen.
3. alle 39 Tabellen erstellen,
4. Seed-Daten laden,
5. Views erstellen,
6. Stored Procedures erstellen,
7. Anzahl der Datenbankobjekte kontrollieren,
8. Seed-Daten kontrollieren,
9. alle Views testweise abfragen,
10. bei Abweichungen den Test mit einem Fehler abbrechen.

Eine Besonderheit ist `EloProtokoll`. Die Tabelle besitzt eine Fremdschlüsselbeziehung zu `Einzelspiel` und wird deshalb im Rebuild erst nach der Erstellung der dafür benötigten Tabellen eingebunden.

### 4.3 Erwartetes Ergebnis

Ein erfolgreicher vollständiger Neuaufbau endet mit:

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

Der vollständige Rebuild wurde erfolgreich durchgeführt.

---

## 5. Prüfung der Seed-Daten

Die Datenbank enthält definierte Stammdaten, die beim Aufbau automatisch geladen werden.

| Tabelle | Erwartete Datensätze |
|---|---:|
| `Verband` | 10 |
| `Alterskategorie` | 9 |
| `Klassierungsstufe` | 22 |
| `Spielsystem` | 1 |
| `Ball` | 3 |

Diese Werte werden durch den Rebuild-Test kontrolliert.

### 5.1 Verbände

Die Seed-Daten enthalten Swiss Table Tennis als nationalen Verband sowie neun Regionalverbände. Die Regionalverbände sind dem nationalen Verband untergeordnet.

### 5.2 Alterskategorien

Die Alterskategorien reichen von `U11` bis `O80`. Dadurch stehen die für das Datenmodell benötigten Altersgruppen direkt nach dem Neuaufbau zur Verfügung.

### 5.3 Klassierungsstufen

Es werden 22 Klassierungsstufen angelegt:

```text
D1-D5
C6-C10
B11-B15
A16-A22
```

### 5.4 Spielsystem

Als initiales Spielsystem wird das 3er-Mannschaftssystem hinterlegt:

- 3 Spieler,
- 9 Einzel,
- 1 Doppel,
- maximal 10 Spiele.

### 5.5 Bälle

Drei Ballmodelle werden als Stammdaten angelegt.

---

## 6. Tests der Stored Procedures

Die Datenbank stellt sechs Stored Procedures für zentrale fachliche Abläufe bereit.

| Stored Procedure | Aufgabe | Positivtest | Negativtest |
|---|---|:---:|:---:|
| `sp_SpielerAnmelden` | Spieler für Saison/Verein anmelden | Ja | Ja |
| `sp_MannschaftSpielerHinzufuegen` | Spieler einer Mannschaft zuordnen | Ja | Ja |
| `sp_BegegnungErfassen` | Ligabegegnung erfassen | Ja | Ja |
| `sp_BegegnungResultatErfassen` | Begegnungsresultat speichern | Ja | Ja |
| `sp_TurnierEinzelAnmelden` | Einzelanmeldung für Turnier erfassen | Ja | Ja |
| `sp_EloAktualisieren` | Elo-Ergebnis verarbeiten | Ja | Ja |

---

## 7. `sp_SpielerAnmelden`

### Ziel

Die Procedure bildet die saisonbezogene Anmeldung eines Spielers ab.

### Positivtest

Mit gültigem Spieler, gültiger Saison, gültigem Verein und gültiger Alterskategorie kann die Anmeldung durchgeführt werden.

**Erwartung:** Die benötigten saisonbezogenen Daten werden erfolgreich gespeichert.

**Ergebnis:** erfolgreich.

### Negativtests

Geprüft wurden insbesondere ungültige Referenzen und eine bereits vorhandene Saisonanmeldung.

**Erwartung:** Die Procedure bricht ab und verhindert einen inkonsistenten oder doppelten Datensatz.

**Ergebnis:** erfolgreich abgefangen.

Damit wird verhindert, dass ein Spieler für dieselbe Saison unkontrolliert mehrfach angelegt wird oder auf nicht vorhandene Stammdaten verweist.

---

## 8. `sp_MannschaftSpielerHinzufuegen`

### Ziel

Die Procedure ordnet einen Spieler einer Mannschaft zu und kapselt die dafür notwendigen Prüfungen.

### Positivtest

Ein gültiger und spielberechtigter Spieler kann einer vorhandenen Mannschaft mit einer zulässigen Meldungsart hinzugefügt werden.

**Erwartung:** Die Zuordnung wird gespeichert.

**Ergebnis:** erfolgreich.

### Negativtest

Ungültige beziehungsweise widersprüchliche Eingaben werden abgewiesen.

Dazu gehören insbesondere Konstellationen, die mit den Regeln von `MannschaftSpieler` nicht vereinbar sind.

**Erwartung:** Keine ungültige Mannschaftszuordnung wird gespeichert.

**Ergebnis:** erfolgreich abgefangen.

Zusätzlich unterstützen Tabellen-Constraints die Absicherung von Meldungsart und Stammposition.

---

## 9. `sp_BegegnungErfassen`

### Ziel

Die Procedure erstellt eine Begegnung innerhalb einer Ligaphase.

### Positivtest

Mit gültiger Ligaphase, zwei unterschiedlichen Mannschaften, gültigem Spielort und zulässigen Begegnungsdaten kann eine Begegnung erstellt werden.

**Erwartung:** Die Begegnung wird gespeichert.

**Ergebnis:** erfolgreich.

### Negativtests

Die Procedure prüft unter anderem:

- Existenz der Ligaphase,
- Existenz der Mannschaften,
- Existenz des Spielorts,
- unterschiedliche Heim- und Gastmannschaft,
- gültige Runde,
- gültigen Status.

Eine Begegnung darf über diese Procedure nicht direkt als `GENEHMIGT` angelegt werden.

**Erwartung:** Ungültige Begegnungen werden nicht gespeichert.

**Ergebnis:** erfolgreich abgefangen.

---

## 10. `sp_BegegnungResultatErfassen`

### Ziel

Die Procedure speichert das Gesamtergebnis einer Begegnung.

### Positivtest

Für eine zulässige Begegnung werden gültige Resultatwerte übergeben.

**Erwartung:** Die Resultatfelder werden aktualisiert und der Status wird auf `ABGESCHLOSSEN` gesetzt.

**Ergebnis:** erfolgreich.

### Negativtests

Die Procedure verhindert unter anderem:

- Änderungen an bereits genehmigten Begegnungen,
- Änderungen an annullierten Begegnungen,
- ungültige Wertebereiche,
- unzulässige Zeitangaben,
- eine Gesamtzahl von Siegen, die das verwendete Spielsystem überschreitet.

Beim 3er-Mannschaftssystem dürfen beispielsweise nicht mehr als zehn Spiele in die Siegessumme einfliessen.

**Erwartung:** Ungültige Resultate werden vollständig abgewiesen.

**Ergebnis:** erfolgreich abgefangen.

### Transaktion

Die Änderung erfolgt transaktional. Dadurch soll verhindert werden, dass nur ein Teil des Resultats gespeichert wird, wenn während der Verarbeitung ein Fehler auftritt.

---

## 11. `sp_TurnierEinzelAnmelden`

### Ziel

Die Procedure meldet einen Spieler für eine Einzelkategorie eines Turniers an.

### Positivtest

Ein aktiver Spieler wird innerhalb der Meldefrist für eine offene Einzelkategorie eines offenen Turniers angemeldet.

**Erwartung:** Die Anmeldung wird gespeichert.

**Ergebnis:** erfolgreich.

### Negativtests

Geprüft werden unter anderem:

- Spieler existiert und ist aktiv,
- Kategorie ist eine Einzelkategorie,
- Kategorie ist offen,
- Turnier ist offen,
- Meldeschluss ist noch nicht überschritten,
- Spieler ist nicht bereits für dieselbe Kategorie angemeldet.

**Erwartung:** Unzulässige oder doppelte Anmeldungen werden verhindert.

**Ergebnis:** erfolgreich abgefangen.

### Transaktion

Die Anmeldung wird innerhalb einer Transaktion durchgeführt, damit bei einem Fehler kein unvollständiger Zustand entsteht.

---

## 12. `sp_EloAktualisieren`

### Ziel

Die Procedure verarbeitet die Elo-Auswirkung eines Elo-relevanten Einzelspiels.

### Positivtest

Für ein abgeschlossenes und Elo-relevantes Einzelspiel werden gültige Spieler-, Gegner-, Monatslauf-, Elo- und Klassierungswerte übergeben.

**Erwartung:**

- Ein Eintrag im `EloProtokoll` wird erstellt.
- Der aktuelle Wert in `SpielerElo` wird für den Monatslauf eingefügt beziehungsweise aktualisiert.

**Ergebnis:** erfolgreich.

### Negativtests

Die Procedure prüft unter anderem:

- Existenz des Einzelspiels,
- zulässigen Spielstatus,
- Elo-Relevanz des Spielgrundes,
- Spieler und Gegner,
- Elo-Monatslauf,
- Elo-Werte,
- Klassierungswerte,
- bereits vorhandenen Protokolleintrag.

**Erwartung:** Eine ungültige oder doppelte Elo-Verarbeitung wird verhindert.

**Ergebnis:** erfolgreich abgefangen.

### Transaktion

Protokollierung und Aktualisierung des Elo-Werts erfolgen zusammenhängend in einer Transaktion. Damit wird verhindert, dass nur einer der beiden Schritte gespeichert wird.

---

## 13. Prüfung der Views

Die Datenbank enthält fünf Views.

| View | Zweck |
|---|---|
| `vw_SpielerAktuell` | aktuelle spielerbezogene Informationen |
| `vw_MannschaftenLiga` | Mannschaften im Ligakontext |
| `vw_BegegnungenUebersicht` | Übersicht über Begegnungen |
| `vw_Turnieranmeldungen` | Übersicht über Turnieranmeldungen |
| `vw_Spielresultate` | Auswertung von Spielresultaten |

Im Rebuild-Test wird jede View nach ihrer Erstellung mit einer Abfrage nach dem Muster

```sql
SELECT TOP (1) ...
```

ausgeführt.

Dadurch wird nicht nur geprüft, ob die View als Datenbankobjekt existiert, sondern auch, ob ihre Abfrage nach dem vollständigen Neuaufbau ausführbar ist.

Alle fünf Views wurden erfolgreich erstellt und ausgeführt.

---

## 14. Prüfung der Datenintegrität

Ein wesentlicher Teil der Qualitätssicherung findet direkt auf Tabellenebene statt.

### 14.1 Primärschlüssel

Primärschlüssel verhindern doppelte Identitäten innerhalb einer Tabelle.

Bei Zuordnungstabellen werden teilweise zusammengesetzte Primärschlüssel verwendet, beispielsweise bei saison- oder funktionsabhängigen Zuordnungen.

### 14.2 Fremdschlüssel

Fremdschlüssel sichern die referenzielle Integrität.

Dadurch können beispielsweise:

- Mannschaften nicht auf nicht vorhandene Clubs verweisen,
- Spiele nicht auf nicht vorhandene Spieler verweisen,
- Ligaphasen nicht auf nicht vorhandene Ligawettbewerbe verweisen,
- Turnierkategorien nicht auf nicht vorhandene Turniere verweisen.

### 14.3 Eindeutigkeit

`UNIQUE`-Constraints und eindeutige Indizes verhindern fachlich unerlaubte Mehrfachdatensätze.

Beispiele sind:

- eindeutige Saisonbezeichnungen,
- eindeutige Benutzernamen,
- nur ein Hauptverein pro Spieler und Saison,
- nur ein aktiver Hauptspielort pro Club,
- keine doppelte Einzelanmeldung pro Kategorie und Spieler,
- keine doppelte Doppelanmeldung bei vertauschter Spielerreihenfolge.

### 14.4 CHECK-Constraints

`CHECK`-Constraints begrenzen Werte und prüfen Beziehungen zwischen Spalten.

Beispiele:

- Saisonende liegt nach dem Saisonstart.
- Heim- und Gastmannschaft sind unterschiedlich.
- Spieler eines Doppels müssen unterschiedlich sein.
- Satzpunkte dürfen nicht gleich sein.
- Gewinner müssen zu den beteiligten Spielern gehören.
- Statuswerte müssen aus den vorgesehenen Wertemengen stammen.
- Stammspieler benötigen eine Stammposition.
- Ersatzspieler besitzen keine Stammposition.
- Einzel- und Doppelspiele gehören jeweils genau zu einer Quelle: Ligabegegnung oder Turnierkategorie.
- Ein Satz gehört genau zu einem Einzel- oder Doppelspiel.

### 14.5 Gefilterte eindeutige Indizes

Gefilterte eindeutige Indizes werden dort eingesetzt, wo eine normale `UNIQUE`-Regel die fachliche Anforderung nicht ausreichend ausdrücken würde.

Beispiele:

- maximal eine aktuelle Saison,
- maximal ein aktiver Hauptspielort pro Club,
- maximal ein Hauptverein pro Spieler und Saison,
- eindeutige Positionen innerhalb einer Turniermannschaft,
- maximal ein Captain innerhalb einer Turniermannschaft.

---

## 15. Positiv- und Negativtests

Die Kombination aus Positiv- und Negativtests ist wichtig, weil ein erfolgreicher `INSERT` oder `UPDATE` allein die Datenqualität nicht nachweist.

### Positivtest

Ein Positivtest verwendet fachlich gültige Eingaben.

Der Test ist erfolgreich, wenn:

1. die Operation ohne Fehler ausgeführt wird,
2. der erwartete Datensatz gespeichert beziehungsweise geändert wird,
3. abhängige Daten den erwarteten Zustand besitzen.

### Negativtest

Ein Negativtest verwendet gezielt ungültige Eingaben.

Der Test ist erfolgreich, wenn:

1. die Operation mit einer vorgesehenen Fehlermeldung beziehungsweise SQL-Fehlerreaktion abbricht,
2. keine ungültigen Daten gespeichert werden,
3. bei transaktionalen Abläufen keine Teiländerungen bestehen bleiben.

Ein erwarteter Fehler ist bei einem Negativtest deshalb ein **erfolgreiches Testergebnis**.

---

## 16. Transaktionssicherheit

Für mehrstufige fachliche Vorgänge werden Transaktionen eingesetzt.

Besonders relevant ist dies bei:

- `sp_BegegnungResultatErfassen`,
- `sp_TurnierEinzelAnmelden`,
- `sp_EloAktualisieren`.

Das Prinzip lautet:

```text
Prüfung
   |
   v
Transaktion starten
   |
   v
Änderungen durchführen
   |
   +---- Fehler ----> Rollback
   |
   v
Commit
```

Dadurch werden inkonsistente Zwischenzustände vermieden.

---

## 17. Fehlerbehandlung

Die Stored Procedures prüfen zentrale Vorbedingungen vor der eigentlichen Datenänderung.

Fehlerhafte Aufrufe werden bewusst abgebrochen, statt ungültige Daten stillschweigend zu übernehmen.

Die Fehlerbehandlung ergänzt die Constraints auf Tabellenebene:

```text
Anwendung / Aufrufer
        |
        v
Stored Procedure
        |
        +-- fachliche Validierung
        |
        v
Tabellen
        |
        +-- PK / FK / UNIQUE / CHECK
```

Damit existieren mehrere Schutzebenen.

---

## 18. Reproduzierbarkeit

Ein wichtiges Qualitätsmerkmal des Projekts ist, dass die Datenbank nicht nur in einer bereits eingerichteten Entwicklungsumgebung funktioniert.

Der vollständige Aufbau ist versioniert und automatisiert:

```text
Git-Repository
      |
      v
Vagrant / VirtualBox
      |
      v
Ubuntu 22.04
      |
      v
SQL Server 2022
      |
      v
99_RebuildTest.sql
      |
      v
39 Tabellen
5 Views
6 Stored Procedures
Seed-Daten
```

Der erfolgreiche Rebuild zeigt, dass die wesentlichen Datenbankobjekte aus dem Projektstand reproduziert werden können.

---

## 19. Testmatrix

| Nr. | Testbereich | Test | Erwartetes Ergebnis | Status |
|---:|---|---|---|:---:|
| 1 | Rebuild | Datenbank vollständig neu erstellen | Aufbau ohne Fehler | Bestanden |
| 2 | Struktur | Tabellen zählen | 39 Tabellen | Bestanden |
| 3 | Struktur | Views zählen | 5 Views | Bestanden |
| 4 | Struktur | Stored Procedures zählen | 6 Procedures | Bestanden |
| 5 | Seed | Verbände zählen | 10 Datensätze | Bestanden |
| 6 | Seed | Alterskategorien zählen | 9 Datensätze | Bestanden |
| 7 | Seed | Klassierungsstufen zählen | 22 Datensätze | Bestanden |
| 8 | Seed | Spielsysteme zählen | 1 Datensatz | Bestanden |
| 9 | Seed | Bälle zählen | 3 Datensätze | Bestanden |
| 10 | Views | `vw_SpielerAktuell` ausführen | Abfrage ausführbar | Bestanden |
| 11 | Views | `vw_MannschaftenLiga` ausführen | Abfrage ausführbar | Bestanden |
| 12 | Views | `vw_BegegnungenUebersicht` ausführen | Abfrage ausführbar | Bestanden |
| 13 | Views | `vw_Turnieranmeldungen` ausführen | Abfrage ausführbar | Bestanden |
| 14 | Views | `vw_Spielresultate` ausführen | Abfrage ausführbar | Bestanden |
| 15 | Procedure | Spieler gültig anmelden | Anmeldung erfolgreich | Bestanden |
| 16 | Procedure | ungültige/doppelte Spieleranmeldung | Vorgang wird abgewiesen | Bestanden |
| 17 | Procedure | Mannschaftsspieler gültig hinzufügen | Zuordnung erfolgreich | Bestanden |
| 18 | Procedure | ungültige Mannschaftszuordnung | Vorgang wird abgewiesen | Bestanden |
| 19 | Procedure | Begegnung gültig erfassen | Begegnung wird erstellt | Bestanden |
| 20 | Procedure | ungültige Begegnung erfassen | Vorgang wird abgewiesen | Bestanden |
| 21 | Procedure | gültiges Resultat erfassen | Resultat und Status gespeichert | Bestanden |
| 22 | Procedure | ungültiges Resultat erfassen | Vorgang wird abgewiesen | Bestanden |
| 23 | Procedure | gültige Einzelanmeldung | Anmeldung wird gespeichert | Bestanden |
| 24 | Procedure | ungültige/doppelte Einzelanmeldung | Vorgang wird abgewiesen | Bestanden |
| 25 | Procedure | gültige Elo-Aktualisierung | Protokoll und Elo-Wert gespeichert | Bestanden |
| 26 | Procedure | ungültige/doppelte Elo-Aktualisierung | Vorgang wird abgewiesen | Bestanden |

---

## 20. Bewertung der Testabdeckung

Die Tests decken die wichtigsten technischen und fachlichen Bereiche des Projekts ab:

- Datenbankaufbau,
- Stammdaten,
- referenzielle Integrität,
- zentrale Geschäftsregeln,
- Ligabetrieb,
- Turnieranmeldung,
- Resultaterfassung,
- Elo-Verarbeitung,
- Auswertungs-Views,
- Fehlerfälle,
- Transaktionssicherheit.

Die Datenbank wird damit nicht nur auf syntaktische Korrektheit geprüft. Es wird ebenfalls kontrolliert, ob zentrale fachliche Regeln tatsächlich durch das Datenmodell und die implementierte Geschäftslogik geschützt werden.

---

## 21. Fazit

Die Qualitätssicherung kombiniert deklarative Datenbankregeln mit prozeduralen Prüfungen und einem automatisierten vollständigen Rebuild.

Besonders wichtig sind dabei drei Ebenen:

1. **Constraints** schützen die Daten unabhängig vom aufrufenden Programm.
2. **Stored Procedures** bilden komplexere Geschäftsabläufe und Validierungen ab.
3. **Rebuild-Tests** prüfen die Reproduzierbarkeit des gesamten Datenbankprojekts.

Der erfolgreiche Neuaufbau mit 39 Tabellen, 5 Views, 6 Stored Procedures und den erwarteten Seed-Daten zeigt, dass der aktuelle Datenbankstand konsistent und reproduzierbar aufgebaut werden kann.
