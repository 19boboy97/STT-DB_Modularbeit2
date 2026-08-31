# Infrastruktur

## 1. Überblick

Die Datenbankumgebung der Modulararbeit wird reproduzierbar mit Vagrant
und VirtualBox bereitgestellt. Als Hostsystem wird Windows 11 verwendet.
Die eigentliche Microsoft-SQL-Server-Instanz läuft innerhalb einer
Ubuntu-22.04-VM.

Die Administration und Ausführung der SQL-Skripte erfolgt vom
Windows-Host aus mit SQL Server Management Studio (SSMS).

## 2. Verwendete Technologien

-   Windows 11 als Hostsystem
-   Vagrant zur Verwaltung der virtuellen Maschine
-   Oracle VirtualBox als Virtualisierungsplattform
-   Ubuntu 22.04 als Gastbetriebssystem
-   Microsoft SQL Server 2022 unter Linux
-   SQL Server Management Studio (SSMS)
-   Git und GitHub zur Versionsverwaltung

## 3. Projektstruktur

Die Infrastrukturdateien befinden sich im Verzeichnis:

``` text
infrastructure/
```

Die Vagrant-Konfiguration definiert die virtuelle Maschine und stellt
die für SQL Server benötigte Umgebung bereit.

Die SQL-Dateien selbst befinden sich getrennt davon unter:

``` text
sql/
```

Dadurch bleiben Infrastruktur und Datenbankimplementierung klar
voneinander getrennt.

## 4. Voraussetzungen

Auf dem Windows-Host müssen folgende Programme installiert sein:

1.  Vagrant
2.  VirtualBox
3.  SQL Server Management Studio
4.  Git

Die Befehle in dieser Dokumentation werden in PowerShell ausgeführt.

## 5. Virtuelle Maschine starten

Zuerst in das Infrastrukturverzeichnis wechseln:

``` powershell
cd C:\GithubRepo\STT-DB_Modularbeit2\infrastructure
```

Danach die VM starten:

``` powershell
vagrant up
```

Beim ersten Start kann die Bereitstellung länger dauern, da die
virtuelle Maschine eingerichtet und benötigte Komponenten installiert
beziehungsweise konfiguriert werden.

In der verwendeten Umgebung kann Vagrant beim ersten Start gelegentlich
einen Timeout beim Warten auf SSH melden, obwohl die virtuelle Maschine
bereits läuft. In diesem Fall sollte zuerst der tatsächliche Status
geprüft werden. Ein erneuter `vagrant up` kann die Verbindung
anschließend erfolgreich herstellen.

## 6. Status prüfen

Der Zustand der VM kann jederzeit geprüft werden:

``` powershell
vagrant status
```

Bei einer laufenden Maschine wird sinngemäß angezeigt:

``` text
default running (virtualbox)
```

## 7. Verbindung zur Linux-VM

Für administrative Arbeiten kann eine SSH-Verbindung über Vagrant
geöffnet werden:

``` powershell
vagrant ssh
```

Die SSH-Sitzung kann mit folgendem Befehl verlassen werden:

``` bash
exit
```

## 8. SQL Server

Innerhalb der Ubuntu-VM läuft Microsoft SQL Server 2022 für Linux.

Für den Zugriff vom Windows-Host wird SQL Server über TCP-Port `1433`
bereitgestellt.

Die Datenbank wird damit nicht direkt auf dem Windows-Host betrieben.
Windows dient als Entwicklungs- und Administrationsumgebung, während SQL
Server innerhalb der reproduzierbaren Linux-VM ausgeführt wird.

## 9. Verbindung mit SSMS

Die Verbindung von SQL Server Management Studio erfolgt über:

``` text
Server: 127.0.0.1,1433
```

Die Authentifizierung erfolgt mit dem für die SQL-Server-Instanz
konfigurierten SQL-Server-Benutzer.

Nach erfolgreicher Verbindung können die Datenbankskripte aus dem
Repository direkt über SSMS ausgeführt werden.

## 10. Datenbankskripte

Die SQL-Implementierung ist im Verzeichnis `sql` strukturiert.

Wichtige Bereiche sind:

``` text
sql/
├── tables/
├── seed/
├── views/
├── procedures/
└── scripts/
```

### Tabellen

Unter `sql/tables` befinden sich die `CREATE TABLE`-Skripte der 39
Tabellen.

### Seed-Daten

Unter `sql/seed` befinden sich die grundlegenden Referenzdaten, unter
anderem:

-   Verbände
-   Alterskategorien
-   Klassierungsstufen
-   Spielsysteme
-   Bälle

### Views

Die Datenbank enthält fünf Views für häufig benötigte Auswertungen.

### Stored Procedures

Die Datenbank enthält sechs Stored Procedures für zentrale
Geschäftsabläufe.

### Rebuild-Test

Unter `sql/scripts` befindet sich mit `99_RebuildTest.sql` ein
vollständiger Neuaufbau- und Kontrollablauf.

## 11. Vollständiger Rebuild-Test

Der Rebuild-Test dient dazu nachzuweisen, dass die Datenbank aus den
versionierten SQL-Skripten vollständig neu aufgebaut werden kann.

Das Skript:

``` text
sql/scripts/99_RebuildTest.sql
```

wird in SSMS im SQLCMD-Modus ausgeführt.

Der Test erstellt eine separate Testdatenbank und bindet die benötigten
SQL-Dateien in der korrekten Reihenfolge ein.

Geprüft werden insbesondere:

-   39 Tabellen
-   5 Views
-   6 Stored Procedures
-   erwartete Seed-Daten
-   erfolgreiche Ausführung aller Views

Bei erfolgreichem Durchlauf endet der Test mit:

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

Damit ist nachgewiesen, dass die Datenbank nicht von einem manuell
aufgebauten lokalen Zustand abhängig ist, sondern aus dem Repository
reproduziert werden kann.

## 12. Besonderheit bei der Erstellungsreihenfolge

Die Reihenfolge der Tabellenskripte richtet sich nach den
Fremdschlüsselabhängigkeiten.

Eine Besonderheit ist `EloProtokoll`. Diese Tabelle besitzt unter
anderem einen Fremdschlüssel auf `Einzelspiel`. Deshalb wird sie beim
vollständigen Rebuild erst erstellt, nachdem die dafür benötigten
Tabellen vorhanden sind.

Der Rebuild-Test berücksichtigt diese Abhängigkeit ausdrücklich.

## 13. SQLCMD-Modus

`99_RebuildTest.sql` verwendet SQLCMD-Anweisungen wie `:r`, um weitere
SQL-Dateien einzubinden.

Deshalb muss vor der Ausführung in SSMS der SQLCMD-Modus aktiviert sein.

Die im Rebuild-Skript verwendeten Include-Pfade sind auf die lokale
Windows-Projektstruktur abgestimmt, da relative `:r`-Pfade in der
verwendeten Umgebung nicht zuverlässig funktioniert haben.

Bei einem Wechsel des Repository-Pfads müssen diese Pfade gegebenenfalls
angepasst werden.

## 14. Virtuelle Maschine herunterfahren

Nach der Arbeit wird die VM kontrolliert heruntergefahren:

``` powershell
cd C:\GithubRepo\STT-DB_Modularbeit2\infrastructure
vagrant halt
```

Anschließend kann der Status geprüft werden:

``` powershell
vagrant status
```

Erwarteter Zustand:

``` text
default poweroff (virtualbox)
```

`vagrant halt` fährt die VM herunter, ohne sie zu löschen. Dadurch
bleibt die eingerichtete Umgebung für den nächsten Start erhalten.

## 15. VM erneut starten

Für die nächste Arbeitssitzung genügt:

``` powershell
cd C:\GithubRepo\STT-DB_Modularbeit2\infrastructure
vagrant up
```

Anschließend kann SSMS wieder über

``` text
127.0.0.1,1433
```

auf SQL Server zugreifen.

## 16. Fehlerbehebung

### Vagrant meldet SSH-Timeout

Falls `vagrant up` beim Warten auf SSH einen Timeout meldet:

``` powershell
vagrant status
```

ausführen und prüfen, ob die VM bereits läuft.

Danach kann erneut versucht werden:

``` powershell
vagrant up
```

oder:

``` powershell
vagrant ssh
```

### SSMS kann keine Verbindung herstellen

Folgende Punkte prüfen:

-   Läuft die VM laut `vagrant status`?
-   Läuft SQL Server innerhalb der VM?
-   Wird `127.0.0.1,1433` als Server verwendet?
-   Ist die SQL-Server-Authentifizierung korrekt?
-   Ist die Portweiterleitung beziehungsweise Netzwerkkonfiguration der
    Vagrant-VM aktiv?

### Rebuild-Skript findet Dateien nicht

Da `99_RebuildTest.sql` SQLCMD-Includes verwendet, müssen die dort
hinterlegten Pfade mit dem tatsächlichen Speicherort des Repositorys
übereinstimmen.

## 17. Reproduzierbarkeit

Ein wesentliches Ziel der Infrastruktur ist die Reproduzierbarkeit.

Die Datenbank soll nicht nur auf einer bereits eingerichteten
Entwicklerinstallation funktionieren. Stattdessen werden folgende
Bestandteile versioniert:

-   Vagrant-Konfiguration
-   SQL-Tabellenskripte
-   Seed-Skripte
-   Views
-   Stored Procedures
-   Rebuild-Test

Dadurch kann die technische Umgebung nachvollzogen und die Datenbank aus
den Projektdateien erneut aufgebaut und geprüft werden.

## 18. Zusammenfassung

Die Infrastruktur trennt Entwicklungsrechner und Datenbankserver klar
voneinander:

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
SSMS auf Windows
```

Die Kombination aus Vagrant, Linux, SQL Server, Git und dem
automatisierten Rebuild-Test stellt sicher, dass die Datenbankumgebung
nachvollziehbar, reproduzierbar und kontrolliert getestet werden kann.
