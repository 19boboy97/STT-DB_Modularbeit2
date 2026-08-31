**STT-DB**

**Abgabedokumentation zur Modulararbeit II**

Relationale Datenbank für Swiss Table Tennis

| **Autor/in**              | \[Name eintragen\]   |
|---------------------------|----------------------|
| **Klasse / Bildungsgang** | \[Klasse eintragen\] |
| **Modul**                 | Modulararbeit II     |
| **Abgabedatum**           | \[Datum eintragen\]  |
| **Repository**            | STT-DB_Modularbeit2  |

**Technischer Endstand**

39 Tabellen \| 5 Views \| 6 Stored Procedures \| vollständiger
Rebuild-Test

# Inhaltsverzeichnis

| **1**  | Management Summary                              |     |
|--------|-------------------------------------------------|-----|
| **2**  | Ausgangslage und Zielsetzung                    |     |
| **3**  | Anforderungen und Abgrenzung                    |     |
| **4**  | Technische Umgebung und Architektur             |     |
| **5**  | Datenbankdesign                                 |     |
| **6**  | Implementierung                                 |     |
| **7**  | Geschäftslogik und zentrale Abläufe             |     |
| **8**  | Qualitätssicherung und Tests                    |     |
| **9**  | Reproduzierbarkeit und Deployment               |     |
| **10** | Herausforderungen und technische Entscheidungen |     |
| **11** | Vertiefung und Lerngewinn                       |     |
| **12** | Reflexion                                       |     |
| **13** | Fazit                                           |     |
| **A**  | Anhang: Objektübersicht                         |     |
| **B**  | Anhang: Testmatrix                              |     |
| **C**  | Anhang: Bezug zu den Bewertungskriterien        |     |

*Seitenzahlen können bei Bedarf in Word ergänzt werden.*

# 1. Management Summary

Im Rahmen dieser Modulararbeit wurde eine relationale Datenbank für
zentrale Prozesse von Swiss Table Tennis konzipiert und mit Microsoft
SQL Server 2022 umgesetzt. Das Projekt bildet Verbände und Clubs,
Spieler und saisonabhängige Vereinszugehörigkeiten, Elo- und
Klassierungsdaten, Ligawettbewerbe, Mannschaften, Begegnungen, Einzel-
und Doppelspiele sowie Turniere und Anmeldungen ab.

Der finale technische Stand umfasst 39 Tabellen, 5 Views und 6 Stored
Procedures. Für grundlegende Referenzdaten existieren Seed-Skripte. Ein
vollständiger Rebuild-Test erstellt eine separate Testdatenbank von
Grund auf neu und kontrolliert anschließend Objektzahlen, Seed-Daten und
die Ausführbarkeit der Views.

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<thead>
<tr class="header">
<th><p><strong>Kernaussage</strong></p>
<p>Die Datenbank ist nicht nur funktional implementiert, sondern aus
versionierten SQL-Skripten reproduzierbar aufbaubar und durch
Constraints, Stored Procedures, Positiv-/Negativtests und einen
automatisierten Rebuild abgesichert.</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

| **Bereich**        | **Ergebnis** |
|--------------------|--------------|
| Tabellen           | 39           |
| Views              | 5            |
| Stored Procedures  | 6            |
| Seed-Skripte       | 5            |
| Rebuild            | erfolgreich  |
| Versionsverwaltung | Git / GitHub |

Die Arbeit legt besonderen Wert auf Datenintegrität. Neben Primär- und
Fremdschlüsseln kommen CHECK-Constraints, UNIQUE-Regeln, gefilterte
UNIQUE-Indizes, Defaultwerte, Transaktionen sowie kontrollierte
Fehlerbehandlung zum Einsatz. Komplexere fachliche Abläufe werden durch
Stored Procedures gekapselt.

# 2. Ausgangslage und Zielsetzung

## 2.1 Ausgangslage

Ein Tischtennisverband verwaltet zahlreiche miteinander verknüpfte
Informationen. Spieler gehören je nach Saison zu Vereinen, besitzen
Alterskategorien, Klassierungen und Elo-Werte. Clubs melden Mannschaften
in Ligawettbewerben, Begegnungen enthalten Aufstellungen und Resultate,
und Turniere besitzen eigene Kategorien sowie unterschiedliche
Anmeldeformen.

Diese Informationen eignen sich für ein relationales Datenbanksystem,
weil viele Daten langfristig konsistent bleiben müssen, gleichzeitig
aber saison- oder periodenabhängige Historien benötigt werden. Ein
zentrales Ziel war deshalb, Stammdaten, saisonabhängige Informationen
und historische Bewertungsstände sauber voneinander zu trennen.

## 2.2 Projektziel

Ziel der Arbeit ist eine technisch nachvollziehbare
Datenbankimplementierung, die die wichtigsten fachlichen Bereiche eines
Swiss-Table-Tennis-Verwaltungssystems abbildet. Die Datenbank soll
gültige Zustände möglichst direkt auf Datenbankebene absichern und
zentrale Geschäftsabläufe über definierte Stored Procedures
bereitstellen.

- Relationales Datenmodell für die wichtigsten Fachbereiche entwickeln.

- Datenintegrität über Schlüssel, Constraints und eindeutige Indizes
  absichern.

- Wiederkehrende Auswertungen mit Views vereinfachen.

- Zentrale Abläufe durch Stored Procedures kapseln.

- Fehlerfälle bewusst testen und kontrolliert abweisen.

- Den vollständigen Datenbankaufbau reproduzierbar machen.

# 3. Anforderungen und Abgrenzung

## 3.1 Fachliche Anforderungen

- Verbände, Regionalverbände, Clubs und Spielorte verwalten.

- Spieler mit lebenslang eindeutiger Lizenznummer führen.

- Saisonabhängige Lizenz-, Alters- und Vereinsdaten abbilden.

- Offizielle Bewertungsperioden und monatliche Elo-Stände historisieren.

- Ligawettbewerbe, Ligaphasen, Mannschaften und Mannschaftsspieler
  verwalten.

- Begegnungen mit Heim-/Gastmannschaft, Aufstellung und Gesamtergebnis
  speichern.

- Einzel-, Doppel- und Satzresultate sowohl für Liga als auch Turniere
  abbilden.

- Turniere mit flexiblen Kategorien und Einzel-, Doppel- sowie
  Mannschaftsanmeldungen unterstützen.

## 3.2 Technische Anforderungen

- Microsoft SQL Server als relationales Datenbanksystem.

- Linux-basierte SQL-Server-Instanz in einer Vagrant-/VirtualBox-VM.

- Versionierung aller relevanten Skripte mit Git und GitHub.

- Modularer Aufbau der SQL-Dateien nach Tabellen, Seeds, Views,
  Procedures und Skripten.

- Vollständiger Rebuild der Datenbank aus dem Repository.

- Nachweis durch Positiv- und Negativtests.

## 3.3 Abgrenzung

Die Arbeit konzentriert sich auf Datenmodell, Datenintegrität und
Datenbanklogik. Eine vollständige Web- oder Desktop-Anwendung ist nicht
Bestandteil des Projekts. Ebenfalls werden komplexe Spezialprozesse
eines produktiven Verbandsystems, beispielsweise vollständige
Turnierauslosungen oder sämtliche möglichen Liga- und
Auf-/Abstiegsregeln, nicht vollständig umgesetzt.

# 4. Technische Umgebung und Architektur

## 4.1 Systemarchitektur

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<thead>
<tr class="header">
<th><p><strong>Architektur</strong></p>
<p>Windows 11 (Entwicklung / SSMS) → Vagrant + VirtualBox → Ubuntu 22.04
VM → Microsoft SQL Server 2022. Der Zugriff von SSMS erfolgt über
TCP-Port 1433.</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

| **Komponente**  | **Verwendung**                                     |
|-----------------|----------------------------------------------------|
| Windows 11      | Hostsystem und Entwicklungsumgebung                |
| Vagrant         | Lebenszyklus und Konfiguration der VM              |
| VirtualBox      | Virtualisierungsplattform                          |
| Ubuntu 22.04    | Gastbetriebssystem                                 |
| SQL Server 2022 | Datenbankserver unter Linux                        |
| SSMS            | Administration und Ausführung der SQL-Skripte      |
| Git / GitHub    | Versionsverwaltung und Sicherung des Projektstands |

## 4.2 Betrieb der VM

Die Entwicklungsumgebung wird mit vagrant up gestartet und mit vagrant
halt kontrolliert heruntergefahren. vagrant status dient zur
Zustandskontrolle. Dadurch bleibt die Datenbankserver-Umgebung vom
Windows-Host getrennt und kann reproduzierbar betrieben werden.

## 4.3 Projektstruktur

Das Repository trennt Fach- und Technikdokumentation, Infrastruktur und
SQL-Implementierung. Die SQL-Dateien sind nach Tabellen, Seed-Daten,
Views, Stored Procedures und übergeordneten Skripten gegliedert. Diese
Trennung erleichtert Wartung, Fehlersuche und Rebuild.

# 5. Datenbankdesign

## 5.1 Umfang und fachliche Gliederung

Das finale Schema besteht aus 39 Tabellen. Um die Komplexität
beherrschbar zu halten, wurde das Modell in fachliche Bereiche
gegliedert.

| **Fachbereich**       | **Beispiele**                                                                     |
|-----------------------|-----------------------------------------------------------------------------------|
| Stammdaten            | Saison, Verband, Alterskategorie, Klassierungsstufe, Club, Spielort               |
| Spieler / Elo         | Spieler, SpielerSaison, SpielerVerein, SpielerBewertung, SpielerElo, EloProtokoll |
| Benutzer / Funktionen | Benutzer, Funktion, Vereinsfunktionaer, FunktionaerFunktion                       |
| Liga                  | Spielsystem, Ligawettbewerb, Ligaphase, Mannschaft, MannschaftSpieler             |
| Begegnungen           | Begegnung, Begegnungsaufstellung, Begegnungsbemerkung, BegegnungAenderung         |
| Turniere              | Turnier, TurnierKategorie, Einzelanmeldung, Doppelanmeldung, Turniermannschaft    |
| Resultate             | Einzelspiel, Doppelspiel, Satz                                                    |

## 5.2 Trennung von Stamm- und Bewegungsdaten

Dauerhafte Spieler-Stammdaten werden in Spieler gespeichert.
Saisonabhängige Informationen befinden sich dagegen in SpielerSaison und
SpielerVerein. Dadurch muss ein Spieler bei jeder Saison nicht
vollständig dupliziert werden. Gleichzeitig können Lizenzstatus,
Alterskategorie und Vereinszugehörigkeit über mehrere Saisons
nachvollzogen werden.

## 5.3 Historisierung von Elo und Klassierung

Die Datenbank unterscheidet offizielle halbjährliche Bewertungsstände
von monatlichen Elo-Ständen. SpielerBewertung speichert Werte einer
Bewertungsperiode, während SpielerElo die monatliche Historie enthält.
EloProtokoll dokumentiert zusätzlich die Berechnungsgrundlage einzelner
Elo-relevanter Einzelspiele.

## 5.4 Liga und Turnier als gemeinsame Resultatdomäne

Einzel- und Doppelspiele können entweder zu einer Ligabegegnung oder zu
einer Turnierkategorie gehören. Die Tabellen Einzelspiel und Doppelspiel
werden dadurch für beide Fachbereiche wiederverwendet. CHECK-Constraints
stellen sicher, dass jeweils genau eine Herkunft gesetzt ist.

## 5.5 ER-Modell

Das vollständige ER-Modell ist im Repository in docs/ER-Diagramm.md
dokumentiert. Aufgrund der 39 Tabellen wird es in mehrere fachlich
gegliederte Teilmodelle aufgeteilt. Dadurch bleiben Beziehungen und
Primär-/Fremdschlüssel lesbar.

# 6. Implementierung

## 6.1 Tabellen und Constraints

Die Tabellen werden jeweils in eigenen SQL-Dateien erzeugt. Die
Integrität wird auf mehreren Ebenen geschützt. Primärschlüssel
identifizieren Datensätze, Fremdschlüssel sichern Referenzen,
UNIQUE-Regeln verhindern Dubletten und CHECK-Constraints begrenzen
erlaubte Werte und Zustandskombinationen.

| **Mechanismus**          | **Beispiel**                                                                      |
|--------------------------|-----------------------------------------------------------------------------------|
| PRIMARY KEY              | LizenzNr identifiziert einen Spieler eindeutig.                                   |
| FOREIGN KEY              | Mannschaft.VereinsNr verweist auf Club.VereinsNr.                                 |
| UNIQUE                   | Benutzername darf nur einmal vorkommen.                                           |
| CHECK                    | Heim- und Gastmannschaft müssen verschieden sein.                                 |
| Gefilterter UNIQUE-Index | Pro Saison höchstens ein aktueller Datensatz bzw. pro Team höchstens ein Captain. |
| DEFAULT                  | Aktiv- und Statusfelder erhalten definierte Anfangswerte.                         |

## 6.2 Besondere Integritätslösungen

Für Regeln, die sich mit normalen UNIQUE-Constraints nur unzureichend
ausdrücken lassen, werden gefilterte eindeutige Indizes verwendet.
Beispiele sind maximal eine aktuelle Saison, maximal ein aktiver
Hauptspielort pro Club und maximal ein Captain pro Turniermannschaft.

Bei Doppelanmeldungen spielt die Reihenfolge der beiden Spieler fachlich
keine Rolle. Deshalb berechnet die Tabelle persistierte Spalten für die
kleinere und grössere Lizenznummer. Ein eindeutiger Index über Kategorie
und dieses normalisierte Paar verhindert sowohl (A,B) als auch (B,A) als
doppelte Anmeldung.

## 6.3 Seed-Daten

| **Seed-Tabelle**  | **Datensätze** |
|-------------------|----------------|
| Verband           | 10             |
| Alterskategorie   | 9              |
| Klassierungsstufe | 22             |
| Spielsystem       | 1              |
| Ball              | 3              |

Die Seed-Daten stellen sicher, dass grundlegende Referenzwerte nach
einem Neuaufbau sofort vorhanden sind. Ihre erwarteten Anzahlen werden
im Rebuild-Test kontrolliert.

## 6.4 Views

- vw_SpielerAktuell

- vw_MannschaftenLiga

- vw_BegegnungenUebersicht

- vw_Turnieranmeldungen

- vw_Spielresultate

Die Views fassen häufig benötigte Informationen zusammen und reduzieren
wiederkehrende Join-Logik für Auswertungen.

## 6.5 Stored Procedures

- sp_SpielerAnmelden

- sp_MannschaftSpielerHinzufuegen

- sp_BegegnungErfassen

- sp_BegegnungResultatErfassen

- sp_TurnierEinzelAnmelden

- sp_EloAktualisieren

Die Procedures kapseln zentrale Geschäftsabläufe, führen fachliche
Vorprüfungen durch und verwenden bei mehrstufigen Änderungen
Transaktionen und Fehlerbehandlung.

# 7. Geschäftslogik und zentrale Abläufe

## 7.1 Spieler anmelden

sp_SpielerAnmelden prüft die benötigten Referenzen und verhindert eine
doppelte saisonbezogene Anmeldung. Der Ablauf verbindet den Spieler mit
Saison, Alterskategorie und Verein.

## 7.2 Mannschaftsspieler hinzufügen

sp_MannschaftSpielerHinzufuegen kapselt die Zuordnung eines Spielers zu
einer Mannschaft. Die Tabellenlogik unterscheidet Stamm- und
Ersatzspieler. Stammspieler benötigen eine Position von 1 bis 3;
Ersatzspieler besitzen keine Stammposition.

## 7.3 Begegnung erfassen und abschliessen

sp_BegegnungErfassen legt eine Begegnung mit gültiger Ligaphase, Heim-
und Gastmannschaft sowie Spielort an. sp_BegegnungResultatErfassen
aktualisiert die Resultatwerte und setzt den Status bei erfolgreicher
Verarbeitung auf ABGESCHLOSSEN. Genehmigte oder annullierte Begegnungen
werden vor unzulässigen Änderungen geschützt.

## 7.4 Turnier-Einzelanmeldung

sp_TurnierEinzelAnmelden prüft unter anderem Spielerstatus,
Wettkampfform, Turnier- und Kategoriestatus, Meldeschluss und bereits
vorhandene Anmeldungen. Dadurch wird der Anmeldeprozess nicht nur durch
einzelne Tabellenconstraints, sondern zusätzlich durch ablaufbezogene
Geschäftslogik abgesichert.

## 7.5 Elo-Verarbeitung

sp_EloAktualisieren verarbeitet einen Elo-relevanten Einzelmatch. Die
Procedure erstellt einen Protokolleintrag und aktualisiert
beziehungsweise erzeugt den monatlichen Elo-Stand. Doppelte Verarbeitung
desselben Spielers für dasselbe Einzelspiel wird verhindert.

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<thead>
<tr class="header">
<th><p><strong>Elo-Relevanz</strong></p>
<p>REGULAER und AUFGABE sind Elo-relevant. FORFAIT, NICHTANGETRETEN und
ANNULLIERT verändern den Elo-Wert nicht. Doppelspiele sind nicht
Elo-relevant.</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

# 8. Qualitätssicherung und Tests

## 8.1 Teststrategie

Die Qualitätssicherung kombiniert Strukturtests, Integritätstests,
Funktionstests und einen vollständigen Rebuild. Für die Stored
Procedures wurden gültige sowie bewusst ungültige Eingaben getestet.

## 8.2 Positiv- und Negativtests

Ein Positivtest gilt als bestanden, wenn ein fachlich gültiger Vorgang
erfolgreich gespeichert wird. Ein Negativtest gilt als bestanden, wenn
ein fachlich ungültiger Vorgang kontrolliert abgewiesen wird und keine
inkonsistenten Daten zurückbleiben. Bei Negativtests ist eine erwartete
Fehlermeldung damit ein erfolgreiches Testergebnis.

| **Procedure**                   | **Positiv** | **Negativ** |
|---------------------------------|-------------|-------------|
| sp_SpielerAnmelden              | Bestanden   | Bestanden   |
| sp_MannschaftSpielerHinzufuegen | Bestanden   | Bestanden   |
| sp_BegegnungErfassen            | Bestanden   | Bestanden   |
| sp_BegegnungResultatErfassen    | Bestanden   | Bestanden   |
| sp_TurnierEinzelAnmelden        | Bestanden   | Bestanden   |
| sp_EloAktualisieren             | Bestanden   | Bestanden   |

## 8.3 Transaktionssicherheit

Mehrstufige Änderungen werden innerhalb von Transaktionen ausgeführt.
Tritt während eines Ablaufs ein Fehler auf, werden die Änderungen
zurückgerollt. Dadurch wird verhindert, dass nur ein Teil eines fachlich
zusammengehörenden Vorgangs gespeichert wird.

## 8.4 Views und Seed-Daten

Nach dem Rebuild werden alle fünf Views mit Testabfragen ausgeführt.
Zusätzlich kontrolliert das Skript die erwarteten Seed-Anzahlen. Damit
wird nicht nur das Vorhandensein der Objekte, sondern auch ihre
grundlegende Ausführbarkeit geprüft.

## 8.5 Ergebnis

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<thead>
<tr class="header">
<th><p><strong>Rebuild-Ergebnis</strong></p>
<p>39 Tabellen, 5 Views, 6 Stored Procedures und die erwarteten
Seed-Daten wurden erfolgreich aufgebaut und geprüft.</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

# 9. Reproduzierbarkeit und Deployment

## 9.1 Vollständiger Rebuild

sql/scripts/99_RebuildTest.sql ist der zentrale technische Nachweis der
Reproduzierbarkeit. Das Skript löscht eine vorhandene Testdatenbank,
erstellt sie neu und bindet die einzelnen SQL-Dateien in der
erforderlichen Reihenfolge ein.

1.  Testdatenbank neu erstellen.

2.  39 Tabellen in abhängiger Reihenfolge erstellen.

3.  Seed-Daten laden.

4.  5 Views erstellen.

5.  6 Stored Procedures erstellen.

6.  Objektzahlen und Seeds kontrollieren.

7.  Views testweise ausführen.

8.  Bei Abweichungen mit THROW abbrechen.

## 9.2 SQLCMD-Modus

Das Rebuild-Skript verwendet :r, um weitere SQL-Dateien einzubinden.
Deshalb wird es in SSMS im SQLCMD-Modus ausgeführt. Die Include-Pfade
sind auf die verwendete lokale Repository-Struktur abgestimmt.

## 9.3 Abhängigkeitsreihenfolge

Ein wichtiger Punkt beim Rebuild ist die Reihenfolge der
Fremdschlüsselabhängigkeiten. EloProtokoll verweist beispielsweise auf
Einzelspiel und wird deshalb erst nach der Erstellung der benötigten
Spieltabellen angelegt. Diese Reihenfolge wurde im Rebuild-Skript
bewusst berücksichtigt.

# 10. Herausforderungen und technische Entscheidungen

## 10.1 Fremdschlüssel und Erstellungsreihenfolge

Beim modularen Aufbau führte die reine Dateinummerierung zunächst nicht
in allen Fällen zu einer gültigen Erstellungsreihenfolge. Besonders
sichtbar wurde dies bei EloProtokoll und Einzelspiel. Die Lösung war,
den Rebuild an den tatsächlichen Abhängigkeiten auszurichten statt starr
nur nach Dateinummern auszuführen.

## 10.2 SQLCMD und Include-Pfade

Der vollständige Rebuild verwendet SQLCMD-Includes. Fehlerhafte oder
nicht auflösbare Pfade führten zu Meldungen am :r-Befehl. Die Lösung
bestand darin, den SQLCMD-Modus bewusst zu verwenden und die Pfade
eindeutig auf die lokale Repository-Struktur abzustimmen.

## 10.3 Fachregeln: Constraint oder Procedure?

Nicht jede Geschäftsregel eignet sich für einen CHECK-Constraint.
Regeln, die mehrere Tabellen, aktuelle Zustände oder Ablaufbedingungen
betreffen, wurden in Stored Procedures verlagert. Tabellenconstraints
schützen dagegen einfache und dauerhaft gültige Datenregeln. Diese
Trennung verbessert Wartbarkeit und Verständlichkeit.

## 10.4 Lesbarkeit eines grossen Datenmodells

Ein einziges ER-Diagramm mit 39 Tabellen und allen Attributen wäre kaum
lesbar. Deshalb wurde das ER-Modell fachlich in Teilmodelle zerlegt. Die
Gesamtdokumentation verbindet diese Teilansichten mit dem detaillierten
Datenmodell und der Constraint-Dokumentation.

# 11. Vertiefung und Lerngewinn

Die Arbeit geht über das reine Anlegen von Tabellen hinaus. Mehrere
Themen wurden praktisch vertieft und im Zusammenhang eingesetzt.

| **Vertiefung**                  | **Konkrete Anwendung im Projekt**                                 |
|---------------------------------|-------------------------------------------------------------------|
| Referentielle Integrität        | umfangreiches Netz aus Fremdschlüsseln über 39 Tabellen           |
| CHECK-Constraints               | Statuswerte, Wertebereiche und spaltenübergreifende Regeln        |
| Gefilterte UNIQUE-Indizes       | aktuelle Saison, Hauptspielort, Hauptverein, Captain, Satznummern |
| Berechnete persistierte Spalten | Normalisierung von Doppel-Paarungen                               |
| Views                           | wiederverwendbare fachliche Auswertungen                          |
| Stored Procedures               | gekapselte Geschäftsprozesse und Validierung                      |
| Transaktionen                   | atomare mehrstufige Änderungen                                    |
| TRY/CATCH und THROW             | kontrollierte Fehlerbehandlung                                    |
| SQLCMD                          | modularer vollständiger Rebuild                                   |
| Vagrant / Linux SQL Server      | reproduzierbare Serverumgebung                                    |

Besonders wertvoll war die Erfahrung, dass Datenbankdesign nicht nur aus
Tabellen und Beziehungen besteht. In einem grösseren Schema müssen
Datenintegrität, Historisierung, Geschäftslogik, Deployment und
Testbarkeit gemeinsam betrachtet werden.

# 12. Reflexion

## 12.1 Was gut funktioniert hat

- Die fachliche Zerlegung in klar abgegrenzte Tabellen verhindert
  grosse, schwer wartbare Universalstrukturen.

- Die konsequente Trennung saisonabhängiger und langfristiger Daten
  erleichtert Historisierung.

- Constraints und Stored Procedures ergänzen sich und bilden mehrere
  Schutzebenen.

- Der Rebuild-Test liefert einen starken Nachweis, dass das Repository
  tatsächlich vollständig ist.

- Git und GitHub ermöglichen nachvollziehbare Zwischenstände und sichere
  Versionierung.

## 12.2 Verbesserungspotenzial

- Weitere automatisierte Integrationstests könnten die bisher manuell
  ausgeführten Procedure-Tests dauerhaft reproduzierbar machen.

- Eine eigene Demo-Datenbasis könnte die Views und Geschäftsprozesse für
  Präsentationen noch anschaulicher machen.

- Berechtigungen könnten mit Datenbankrollen beziehungsweise einem
  vollständigen Anwendungskonzept weiter ausgebaut werden.

- Komplexe Turnierlogik wie Auslosungen und vollständige
  Mannschaftswettbewerbe könnte in einer späteren Ausbaustufe ergänzt
  werden.

- Die SQLCMD-Pfade könnten künftig stärker parametriert werden, damit
  der Rebuild unabhängig vom lokalen Repository-Pfad läuft.

## 12.3 Persönlicher Lerngewinn

Der grösste Lerngewinn liegt im Zusammenspiel der einzelnen Techniken.
Erst durch die Kombination aus Modellierung, Constraints, Stored
Procedures, Transaktionen, Fehlerbehandlung, Tests und reproduzierbarer
Infrastruktur entstand aus einzelnen SQL-Befehlen ein zusammenhängendes
Datenbankprojekt.

# 13. Fazit

Die Modulararbeit erreicht das Ziel einer umfangreichen und
reproduzierbaren relationalen Datenbank für zentrale Bereiche von Swiss
Table Tennis. Das Datenmodell deckt sowohl langfristige Stammdaten als
auch saisonabhängige, historische und transaktionale Informationen ab.

Mit 39 Tabellen, 5 Views, 6 Stored Procedures, Seed-Daten, umfangreichen
Constraints und einem vollständigen Rebuild besitzt das Projekt einen
klar nachweisbaren technischen Umfang. Positiv- und Negativtests sowie
transaktionale Geschäftslogik erhöhen die Robustheit.

Für die Weiterentwicklung bieten sich vor allem automatisierte
Integrationstests, Demo-Daten und zusätzliche Anwendungsschichten an.
Der aktuelle Stand bildet jedoch einen vollständigen, dokumentierten und
reproduzierbaren Datenbankkern.

# Anhang A: Objektübersicht

## A.1 Tabellen

| **Tabelle 1**         | **Tabelle 2**       | **Tabelle 3**            |
|-----------------------|---------------------|--------------------------|
| Saison                | Verband             | Alterskategorie          |
| Klassierungsstufe     | Club                | Spielort                 |
| Spieler               | SpielerSaison       | SpielerVerein            |
| Bewertungsperiode     | Klassierungsgrenze  | SpielerBewertung         |
| EloMonatslauf         | SpielerElo          | EloProtokoll             |
| Funktion              | Vereinsfunktionaer  | FunktionaerFunktion      |
| Benutzer              | Ball                | Spielsystem              |
| Ligawettbewerb        | Ligaphase           | Mannschaft               |
| MannschaftSpieler     | BenutzerMannschaft  | Begegnung                |
| Begegnungsaufstellung | Begegnungsbemerkung | BegegnungAenderung       |
| Turnier               | TurnierKategorie    | Einzelanmeldung          |
| Doppelanmeldung       | Turniermannschaft   | TurniermannschaftSpieler |
| Einzelspiel           | Doppelspiel         | Satz                     |

## A.2 Views und Stored Procedures

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Views</strong></th>
<th><strong>Stored Procedures</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>• vw_SpielerAktuell</p>
<p>• vw_MannschaftenLiga</p>
<p>• vw_BegegnungenUebersicht</p>
<p>• vw_Turnieranmeldungen</p>
<p>• vw_Spielresultate</p></td>
<td><p>• sp_SpielerAnmelden</p>
<p>• sp_MannschaftSpielerHinzufuegen</p>
<p>• sp_BegegnungErfassen</p>
<p>• sp_BegegnungResultatErfassen</p>
<p>• sp_TurnierEinzelAnmelden</p>
<p>• sp_EloAktualisieren</p></td>
</tr>
</tbody>
</table>

# Anhang B: Testmatrix

| **Nr.** | **Bereich** | **Test**                            | **Erwartung**         | **Status** |
|---------|-------------|-------------------------------------|-----------------------|------------|
| 1       | Rebuild     | Datenbank vollständig neu erstellen | Aufbau ohne Fehler    | Bestanden  |
| 2       | Struktur    | Tabellen zählen                     | 39 Tabellen           | Bestanden  |
| 3       | Struktur    | Views zählen                        | 5 Views               | Bestanden  |
| 4       | Struktur    | Stored Procedures zählen            | 6 Procedures          | Bestanden  |
| 5       | Seed        | Verbände zählen                     | 10 Datensätze         | Bestanden  |
| 6       | Seed        | Alterskategorien zählen             | 9 Datensätze          | Bestanden  |
| 7       | Seed        | Klassierungsstufen zählen           | 22 Datensätze         | Bestanden  |
| 8       | Seed        | Spielsysteme zählen                 | 1 Datensatz           | Bestanden  |
| 9       | Seed        | Bälle zählen                        | 3 Datensätze          | Bestanden  |
| 10      | Views       | Alle 5 Views ausführen              | Abfragen ausführbar   | Bestanden  |
| 11      | Procedure   | Spieler gültig anmelden             | Anmeldung erfolgreich | Bestanden  |

## B.1 Testmatrix - Fortsetzung

| **Nr.** | **Bereich** | **Test**                              | **Erwartung**             | **Status** |
|---------|-------------|---------------------------------------|---------------------------|------------|
| 12      | Procedure   | Doppelte/ungültige Spieleranmeldung   | Vorgang abgewiesen        | Bestanden  |
| 13      | Procedure   | Mannschaftsspieler hinzufügen         | Zuordnung erfolgreich     | Bestanden  |
| 14      | Procedure   | Ungültige Mannschaftszuordnung        | Vorgang abgewiesen        | Bestanden  |
| 15      | Procedure   | Begegnung gültig erfassen             | Begegnung erstellt        | Bestanden  |
| 16      | Procedure   | Ungültige Begegnung                   | Vorgang abgewiesen        | Bestanden  |
| 17      | Procedure   | Gültiges Resultat erfassen            | Resultat gespeichert      | Bestanden  |
| 18      | Procedure   | Ungültiges Resultat                   | Vorgang abgewiesen        | Bestanden  |
| 19      | Procedure   | Gültige Einzelanmeldung               | Anmeldung gespeichert     | Bestanden  |
| 20      | Procedure   | Ungültige/doppelte Einzelanmeldung    | Vorgang abgewiesen        | Bestanden  |
| 21      | Procedure   | Gültige Elo-Aktualisierung            | Elo/Protokoll gespeichert | Bestanden  |
| 22      | Procedure   | Ungültige/doppelte Elo-Aktualisierung | Vorgang abgewiesen        | Bestanden  |

# Anhang C: Bezug zu den Bewertungskriterien

Die technische Umsetzung und Dokumentation unterstützt die in der
Aufgabenstellung genannten Bewertungsbereiche insbesondere wie folgt:

| **Bewertungsbereich**    | **Nachweis im Projekt**                                                                                                                    |
|--------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|
| Komplexität / Umfang     | 39 Tabellen, mehrere Fachdomänen, historisierte Elo-/Bewertungsdaten, Liga und Turnier in einem konsistenten Modell.                       |
| Vertiefung / neuer Stoff | Views, Stored Procedures, Transaktionen, TRY/CATCH, THROW, gefilterte UNIQUE-Indizes, SQLCMD-Rebuild und Vagrant-Infrastruktur.            |
| Produkt                  | Funktionsfähige SQL-Server-Datenbank mit erfolgreichem vollständigem Rebuild und geprüften Geschäftsabläufen.                              |
| Dokumentation            | Fachkonzept, Datenmodell, Constraints, Geschäftsregeln, ER-Diagramm, Infrastruktur- und Testdokumentation sowie diese Abgabedokumentation. |
| Präsentation             | Vorbereiteter Demonstrationspfad über Spieleranmeldung, Mannschaft, Begegnung, Resultat, Elo und Rebuild.                                  |
