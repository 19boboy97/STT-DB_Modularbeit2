# Fachkonzept

## 1. Ausgangslage

Swiss Table Tennis verwaltet eine grosse Menge miteinander verknüpfter Daten. Dazu gehören unter anderem Spieler, Clubs, Verbände, Lizenzen, Klassierungen, Elo-Werte, Mannschaften, Ligawettbewerbe, Begegnungen und Turniere.

Ziel dieser Modulararbeit ist die Konzeption und Implementierung einer relationalen Datenbank, mit der zentrale Bereiche eines solchen Tischtennis-Verwaltungssystems strukturiert abgebildet werden können.

Die Datenbank orientiert sich an realistischen Abläufen und Regeln des Schweizer Tischtennissports. Dabei handelt es sich um ein Demonstrationsprojekt und nicht um eine vollständige Nachbildung eines produktiven Systems von Swiss Table Tennis.

## 2. Projektziel

Das Hauptziel ist die Entwicklung einer relationalen Datenbank mit Microsoft SQL Server.

Die Datenbank soll insbesondere folgende Bereiche abbilden:

- Swiss Table Tennis und die Regionalverbände
- Clubs und Spielorte
- Spieler und saisonabhängige Vereinszugehörigkeiten
- Alterskategorien
- Elo-Werte und Klassierungen
- Benutzer und Zuständigkeiten
- Ligawettbewerbe und Ligaphasen
- Mannschaften und Mannschaftskader
- Mannschaftsbegegnungen
- Einzel-, Doppel- und Satzresultate
- Turniere und Turnierkategorien
- Einzel-, Doppel- und Mannschaftsanmeldungen

Neben der reinen Speicherung der Daten sollen wichtige Regeln bereits auf Datenbankebene abgesichert werden.

## 3. Fachliche Schwerpunkte

### 3.1 Spieler und Vereine

Ein Spieler wird dauerhaft über seine Lizenznummer identifiziert.

Saisonabhängige Informationen werden getrennt von den langfristigen Spieler-Stammdaten gespeichert. Dadurch können beispielsweise Lizenzstatus, Alterskategorie und Vereinszugehörigkeit einer bestimmten Saison zugeordnet werden.

Neben einem Hauptverein kann auch eine Mehrfachlizenz berücksichtigt werden.

### 3.2 Elo und Klassierung

Die Datenbank unterscheidet zwischen offiziellen Bewertungsständen und monatlichen Elo-Ständen.

Klassierungsstufen reichen von D1 bis A22. Jeder Spieler besitzt eine Herrenklassierung. Frauen können zusätzlich eine Damenklassierung besitzen.

Elo-relevante Einzelspiele können protokolliert und einem monatlichen Elo-Lauf zugeordnet werden.

### 3.3 Ligabetrieb

Ligawettbewerbe gehören zu einer Saison und werden von Swiss Table Tennis oder einem Regionalverband durchgeführt.

Innerhalb eines Ligawettbewerbs können verschiedene Ligaphasen beziehungsweise Gruppen existieren.

Clubs melden Mannschaften für diese Ligaphasen. Den Mannschaften werden Spieler und ein verwendeter Ball zugeordnet.

### 3.4 Mannschaftsbegegnungen

Eine Begegnung findet zwischen einer Heim- und einer Gastmannschaft statt.

Das im Projekt verwendete Standardspielsystem besteht aus:

- drei Spielern pro Mannschaft
- neun Einzeln
- einem Doppel
- maximal zehn Spielen

Für eine Begegnung können Aufstellung, Einzelspiele, Doppelspiel, Satzresultate und das Gesamtergebnis gespeichert werden.

Auch Sonderfälle wie Forfait, Nichtantreten, Aufgabe oder Annullierung werden berücksichtigt.

### 3.5 Turniere

Ein Turnier kann mehrere Kategorien besitzen.

Kategorien können unter anderem nach folgenden Kriterien eingeschränkt werden:

- Alter
- Geschlecht
- Klassierung
- Elo
- Kombination mehrerer Kriterien

Unterstützt werden Einzel-, Doppel- und Mannschaftskategorien.

Turniermannschaften sind bewusst nicht fest an einen Club gebunden, damit Spieler verschiedener Clubs gemeinsam antreten können.

## 4. Datenintegrität

Ein wichtiger Schwerpunkt des Projekts ist die Sicherstellung der Datenqualität direkt in der Datenbank.

Dafür werden unter anderem eingesetzt:

- Primärschlüssel
- Fremdschlüssel
- UNIQUE-Constraints und UNIQUE-Indizes
- CHECK-Constraints
- Stored Procedures
- Transaktionen
- Fehlerbehandlung

Dadurch sollen ungültige oder widersprüchliche Daten möglichst früh verhindert werden.

## 5. Auswertung und Geschäftslogik

Für häufig benötigte Auswertungen werden Views eingesetzt.

Stored Procedures kapseln ausgewählte Geschäftsabläufe, beispielsweise:

- Anmeldung eines Spielers für eine Saison
- Hinzufügen eines Spielers zu einer Mannschaft
- Erfassen einer Begegnung
- Erfassen eines Begegnungsresultats
- Anmeldung zu einer Einzel-Turnierkategorie
- Aktualisierung beziehungsweise Protokollierung von Elo-Daten

## 6. Technische Umgebung

Die Entwicklung erfolgt auf einem Windows-Client.

Die Datenbank läuft innerhalb einer Linux-VM, die mit Vagrant und VirtualBox verwaltet wird.

Verwendete Technologien und Werkzeuge:

- Windows 11
- Visual Studio Code
- Git und GitHub
- Vagrant
- VirtualBox
- Ubuntu Linux
- Microsoft SQL Server 2022
- SQL Server Management Studio

SQL Server läuft innerhalb der Linux-VM. Die Administration und Ausführung der SQL-Skripte erfolgt von Windows aus mit SQL Server Management Studio.

## 7. Abgrenzung

Die Arbeit konzentriert sich auf das relationale Datenmodell und die Datenbanklogik.

Nicht Bestandteil des Projekts ist die Entwicklung einer vollständigen Web- oder Desktop-Anwendung.

Ebenfalls werden einzelne Spezialfälle eines produktiven Verbandssystems bewusst vereinfacht. Dazu gehören beispielsweise komplexe Auf- und Abstiegsverfahren, vollständige Turnierauslosungen oder sämtliche möglichen Spielsysteme.

Ziel ist nicht die vollständige Reproduktion eines bestehenden Swiss-Table-Tennis-Systems, sondern eine technisch und fachlich nachvollziehbare Datenbankimplementierung der wichtigsten Bereiche.