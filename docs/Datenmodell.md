# Datenmodell

## 1. Ziel

Dieses Dokument beschreibt das Datenmodell der STT-Datenbank.

Die Datenbank bildet folgende Bereiche ab:

- Saison
- Verbände
- Clubs und Spielorte
- Spieler und Vereinszuordnungen
- Alterskategorien
- Elo und Klassierungen
- Benutzer und Berechtigungen
- Ligawettbewerbe
- Mannschaften
- Begegnungen
- Einzel-, Doppel- und Satzresultate
- Turniere und Anmeldungen

## 2. Allgemeine Konventionen

- Technische IDs verwenden in der Regel `INT IDENTITY` oder `BIGINT IDENTITY`.
- Lizenznummern sind fachliche Schlüssel und bleiben lebenslang eindeutig.
- Vereinsnummern sind fachliche Schlüssel und bleiben eindeutig.
- Texte mit Umlauten verwenden `NVARCHAR`.
- Datumswerte verwenden `DATE`.
- Datum und Uhrzeit verwenden `DATETIME2(0)`.
- Ja/Nein-Werte verwenden `BIT`.
- Fremdschlüssel werden mit `FK` gekennzeichnet.
- Primärschlüssel werden mit `PK` gekennzeichnet.
- Optionale Felder dürfen `NULL` enthalten.

## 3. Tabellenübersicht

1. Saison
2. Verband
3. Club
4. Spielort
5. Spieler
6. SpielerSaison
7. SpielerVerein
8. Alterskategorie
9. Klassierungsstufe
10. Klassierungsgrenze
11. Bewertungsperiode
12. SpielerBewertung
13. SpielerElo
14. EloMonatslauf
15. EloProtokoll
16. Funktion
17. Vereinsfunktionaer
18. FunktionaerFunktion
19. Benutzer
20. BenutzerMannschaft
21. Ball
22. Spielsystem
23. Ligawettbewerb
24. Ligaphase
25. Mannschaft
26. MannschaftSpieler
27. Begegnung
28. Begegnungsaufstellung
29. Begegnungsbemerkung
30. BegegnungAenderung
31. Turnier
32. TurnierKategorie
33. Einzelanmeldung
34. Doppelanmeldung
35. Turniermannschaft
36. TurniermannschaftSpieler
37. Einzelspiel
38. Doppelspiel
39. Satz

## 4. Saison

### Zweck

Speichert eine Spielzeit von Swiss Table Tennis.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| SaisonID | INT IDENTITY | Nein | PK | 1 |
| Bezeichnung | VARCHAR(9) | Nein | UNIQUE | 2026/27 |
| Startdatum | DATE | Nein | | 2026-07-01 |
| Enddatum | DATE | Nein | | 2027-06-30 |
| IstAktuell | BIT | Nein | | 1 |

### Regeln

- `Bezeichnung` muss eindeutig sein.
- `Enddatum` muss nach `Startdatum` liegen.
- Es soll höchstens eine Saison mit `IstAktuell = 1` geben.

## 5. Verband

### Zweck

Speichert Swiss Table Tennis und die Regionalverbände.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| VerbandID | INT IDENTITY | Nein | PK | 1 |
| Kurzname | VARCHAR(10) | Nein | UNIQUE | MTTV |
| Name | NVARCHAR(150) | Nein | | Mittelländischer Tischtennisverband |
| Verbandstyp | VARCHAR(10) | Nein | | REGIONAL |
| UebergeordneterVerbandID | INT | Ja | FK → Verband | 1 |
| Gruendungsdatum | DATE | Ja | | 1957-04-27 |
| Webseite | NVARCHAR(255) | Ja | | https://... |
| Aktiv | BIT | Nein | | 1 |

### Regeln

- `Verbandstyp` ist `NATIONAL` oder `REGIONAL`.
- Swiss Table Tennis besitzt keinen übergeordneten Verband.
- Regionalverbände verweisen auf Swiss Table Tennis.

## 6. Club

### Zweck

Speichert die Stammdaten eines Tischtennisclubs.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| VereinsNr | INT | Nein | PK | 50048 |
| RegionalverbandID | INT | Nein | FK → Verband | 6 |
| Clubname | NVARCHAR(150) | Nein | | TTC Heimberg |
| Kurzname | NVARCHAR(80) | Nein | | Heimberg |
| Gruendungsjahr | SMALLINT | Ja | | 1974 |
| Strasse | NVARCHAR(100) | Ja | | Bernstrasse |
| Hausnummer | NVARCHAR(10) | Ja | | 221 |
| PLZ | CHAR(4) | Ja | | 3627 |
| Ort | NVARCHAR(100) | Ja | | Heimberg |
| Kanton | CHAR(2) | Ja | | BE |
| Landcode | CHAR(2) | Nein | | CH |
| KontaktEmail | NVARCHAR(255) | Ja | | info@ttc-heimberg.ch |
| Webseite | NVARCHAR(255) | Ja | | https://www.ttc-heimberg.ch |
| Aktiv | BIT | Nein | | 1 |

### Regeln

- `VereinsNr` ist eindeutig und bleibt dauerhaft gleich.
- `Clubname` ist der offizielle Vereinsname.
- `Kurzname` wird unter anderem für Mannschaftsnamen verwendet.
- Ein Club gehört zu genau einem Regionalverband.

## 7. Spielort

### Zweck

Speichert die Spiellokale eines Clubs.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| SpielortID | INT IDENTITY | Nein | PK | 1 |
| VereinsNr | INT | Nein | FK → Club | 50048 |
| Bezeichnung | NVARCHAR(100) | Nein | | Spiellokal 1 |
| Gebaeude | NVARCHAR(150) | Ja | | Turnhalle Obere Au |
| Strasse | NVARCHAR(100) | Nein | | Niesenstrasse |
| Hausnummer | NVARCHAR(10) | Nein | | 38 |
| PLZ | CHAR(4) | Nein | | 3627 |
| Ort | NVARCHAR(100) | Nein | | Heimberg |
| Landcode | CHAR(2) | Nein | | CH |
| IstHauptspielort | BIT | Nein | | 1 |
| Aktiv | BIT | Nein | | 1 |

### Regeln

- Ein Club kann mehrere Spielorte besitzen.
- Die Routenplaner-URL wird nicht gespeichert.
- Die Webseite erzeugt die Karten-URL dynamisch aus den Adressfeldern.

## 8. Spieler

### Zweck

Speichert die langfristigen Stammdaten eines Spielers.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| LizenzNr | INT | Nein | PK | 512038 |
| Vorname | NVARCHAR(80) | Nein | | Christian |
| Nachname | NVARCHAR(80) | Nein | | Abbühl |
| Geburtsdatum | DATE | Nein | | 1998-05-10 |
| Geschlecht | CHAR(1) | Nein | | M |
| Aktiv | BIT | Nein | | 1 |

### Regeln

- `LizenzNr` ist lebenslang eindeutig und bleibt auch bei Karrierepausen gleich.
- Es wird nur der aktuelle Name gespeichert.
- `Geschlecht` ist `M` oder `W`.
- Vereinszugehörigkeiten werden nicht direkt in dieser Tabelle gespeichert.

## 9. SpielerSaison

### Zweck

Speichert Eigenschaften eines Spielers, die für eine ganze Saison gelten.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| LizenzNr | INT | Nein | PK, FK → Spieler | 512038 |
| SaisonID | INT | Nein | PK, FK → Saison | 1 |
| Alterskategorie | VARCHAR(10) | Nein | FK → Alterskategorie | Aktive |
| LizenzAktiv | BIT | Nein | | 1 |

### Regeln

- Der Primärschlüssel besteht aus `LizenzNr` und `SaisonID`.
- Pro Spieler und Saison existiert genau ein Datensatz.
- Die Alterskategorie bleibt während der gesamten Saison gleich.
- `LizenzAktiv = 1` bedeutet, dass der Spieler in dieser Saison eine aktive Lizenz besitzt.

## 10. SpielerVerein

### Zweck

Speichert die aktuelle Vereinszuordnung eines Spielers innerhalb einer Saison.

Die Tabelle bildet Hauptverein und Mehrfachlizenz ab.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| SpielerVereinID | BIGINT IDENTITY | Nein | PK | 1 |
| LizenzNr | INT | Nein | FK → Spieler | 512038 |
| SaisonID | INT | Nein | FK → Saison | 1 |
| VereinsNr | INT | Nein | FK → Club | 50048 |
| Zuordnungsart | VARCHAR(20) | Nein | | HAUPTVEREIN |
| Wettbewerbsbereich | VARCHAR(20) | Nein | | ALLE |

### Mögliche Werte `Zuordnungsart`

- `HAUPTVEREIN`
- `MEHRFACHLIZENZ`

### Mögliche Werte `Wettbewerbsbereich`

- `ALLE`
- `HERREN`
- `DAMEN`
- `NACHWUCHS`
- `SENIOREN`

### Regeln

- Ein Spieler besitzt normalerweise genau einen Hauptverein.
- Eine Mehrfachlizenz verwendet dieselbe Lizenznummer.
- Eine Mehrfachlizenz kann zum Beispiel nur für Damen oder Nachwuchs gelten.
- Vereinswechsel werden nicht historisiert. Es interessiert nur die aktuelle Zuordnung.

## 11. Alterskategorie

### Zweck

Speichert die Alterskategorien eines Spielers.

Die Kategorie beschreibt das Alter eines Spielers. Sie ist nicht automatisch identisch mit der Teilnahmeberechtigung eines Wettbewerbs.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| Bezeichnung | VARCHAR(10) | Nein | PK | U19 |
| MinAlter | TINYINT | Nein | | 15 |
| MaxAlter | TINYINT | Ja | | 18 |

### Beispieldaten

| Bezeichnung | MinAlter | MaxAlter |
|---|---:|---:|
| U11 | 0 | 10 |
| U13 | 11 | 12 |
| U15 | 13 | 14 |
| U19 | 15 | 18 |
| Aktive | 19 | 39 |
| O40 | 40 | 49 |
| O50 | 50 | 69 |
| O70 | 70 | 79 |
| O80 | 80 | NULL |

### Regeln

- `Aktive` beschreibt Spieler im Alter von 19 bis 39 Jahren.
- In Wettbewerben der Aktiven dürfen Spieler aller Alterskategorien teilnehmen.
- Jüngere Nachwuchsspieler dürfen in einer höheren Nachwuchskategorie teilnehmen.
- Beispiel: U11 darf U13 spielen.
- Wenn eine passende jüngere Nachwuchskategorie vorhanden ist, wird diese bevorzugt.
- Ältere Seniorenspieler dürfen in einer jüngeren Seniorenkategorie teilnehmen.
- Beispiel: Ein O50-Spieler darf in O40 spielen.

## 12. Klassierungsstufe

### Zweck

Speichert die möglichen Klassierungsstufen von D1 bis A22.

Die Zahl ist gleichzeitig der fachliche Stufenwert und wird direkt als Primärschlüssel verwendet.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| Stufenwert | TINYINT | Nein | PK | 9 |
| Bezeichnung | VARCHAR(3) | Nein | UNIQUE | C9 |

### Beispieldaten

| Stufenwert | Bezeichnung |
|---:|---|
| 1 | D1 |
| 5 | D5 |
| 6 | C6 |
| 9 | C9 |
| 10 | C10 |
| 11 | B11 |
| 15 | B15 |
| 16 | A16 |
| 22 | A22 |

### Regeln

- `Stufenwert` liegt zwischen 1 und 22.
- `Bezeichnung` muss eindeutig sein.
- D entspricht den Stufen 1 bis 5.
- C entspricht den Stufen 6 bis 10.
- B entspricht den Stufen 11 bis 15.
- A entspricht den Stufen 16 bis 22.
- Eine separate Sortierung oder Klassierungs-ID ist nicht notwendig.

## 13. Klassierungsgrenze

### Zweck

Ordnet einem Elo-Bereich eine Klassierungsstufe zu.

Die Klassierungsgrenzen können sich zwischen Saisonbeginn und Saisonmitte ändern und werden deshalb einer Bewertungsperiode zugeordnet.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| KlassierungsgrenzeID | INT IDENTITY | Nein | PK | 1 |
| BewertungsperiodeID | INT | Nein | FK → Bewertungsperiode | 2 |
| Stufenwert | TINYINT | Nein | FK → Klassierungsstufe | 9 |
| Klassierungsart | VARCHAR(10) | Nein | | HERREN |
| MinElo | DECIMAL(10,3) | Ja | | 1100.000 |
| MittelElo | DECIMAL(10,3) | Ja | | 1125.000 |
| MaxElo | DECIMAL(10,3) | Ja | | 1149.999 |

### Mögliche Werte `Klassierungsart`

- `HERREN`
- `DAMEN`

### Regeln

- Jeder Spieler besitzt eine Herrenklassierung.
- Frauen besitzen zusätzlich eine Damenklassierung.
- Beide Klassierungen basieren auf demselben Elo-Wert.
- Die Elo-Bereiche einer Klassierungsart dürfen sich innerhalb derselben Bewertungsperiode nicht überschneiden.
- `MinElo` kann bei der tiefsten Stufe `NULL` sein.
- `MaxElo` kann bei der höchsten Stufe `NULL` sein.

## 14. Bewertungsperiode

### Zweck

Speichert die beiden offiziellen Bewertungsstände einer Saison.

Diese Werte werden insbesondere für Turnierzulassungen und Klassierungsgrenzen verwendet.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| BewertungsperiodeID | INT IDENTITY | Nein | PK | 2 |
| SaisonID | INT | Nein | FK → Saison | 1 |
| Bezeichnung | VARCHAR(20) | Nein | | SAISONMITTE |
| Stichtag | DATE | Nein | | 2026-01-01 |
| GueltigAb | DATE | Nein | | 2026-01-01 |
| GueltigBis | DATE | Nein | | 2026-06-30 |

### Mögliche Werte `Bezeichnung`

- `SAISONBEGINN`
- `SAISONMITTE`

### Beispiel

| Bezeichnung | Stichtag | GueltigAb | GueltigBis |
|---|---|---|---|
| SAISONBEGINN | 2025-07-01 | 2025-07-01 | 2025-12-31 |
| SAISONMITTE | 2026-01-01 | 2026-01-01 | 2026-06-30 |

### Regeln

- Pro Saison existieren zwei Bewertungsperioden.
- Turnierkriterien verwenden den für das Turnier gültigen Bewertungsstand.
- Elo- und Klassierungswerte werden nicht zum Zeitpunkt der Anmeldung eingefroren, sondern über die Bewertungsperiode bestimmt.

## 15. SpielerBewertung

### Zweck

Speichert die offiziellen halbjährlichen Bewertungswerte eines Spielers.

Diese Werte werden vor allem für Turnierzulassungen verwendet.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| SpielerBewertungID | BIGINT IDENTITY | Nein | PK | 1 |
| LizenzNr | INT | Nein | FK → Spieler | 512038 |
| BewertungsperiodeID | INT | Nein | FK → Bewertungsperiode | 2 |
| Elo | DECIMAL(10,3) | Nein | | 1110.000 |
| HerrenStufenwert | TINYINT | Nein | FK → Klassierungsstufe | 9 |
| DamenStufenwert | TINYINT | Ja | FK → Klassierungsstufe | 13 |
| Alterskategorie | VARCHAR(10) | Nein | FK → Alterskategorie | Aktive |
| ErstelltAm | DATETIME2(0) | Nein | | 2026-01-01 00:00:00 |

### Regeln

- Pro Spieler und Bewertungsperiode existiert genau ein Datensatz.
- Jeder Spieler besitzt einen `HerrenStufenwert`.
- Bei Männern ist `DamenStufenwert = NULL`.
- Frauen besitzen zusätzlich einen Damenklassierungswert.
- Die Alterskategorie wird aus `SpielerSaison` übernommen.
- Die Daten bleiben für die jeweilige Bewertungsperiode unverändert.

## 16. SpielerElo

### Zweck

Speichert die offiziellen monatlichen Elo-Stände eines Spielers.

Damit kann der Elo-Verlauf eines Spielers über mehrere Monate und Jahre nachvollzogen werden.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| SpielerEloID | BIGINT IDENTITY | Nein | PK | 1001 |
| LizenzNr | INT | Nein | FK → Spieler | 512038 |
| EloMonatslaufID | BIGINT | Nein | FK → EloMonatslauf | 15 |
| Elo | DECIMAL(10,3) | Nein | | 1116.000 |
| EloDeltaZumVormonat | DECIMAL(10,3) | Ja | | -29.000 |
| HerrenStufenwert | TINYINT | Nein | FK → Klassierungsstufe | 9 |
| DamenStufenwert | TINYINT | Ja | FK → Klassierungsstufe | NULL |
| HerrenRang | INT | Ja | | 764 |
| Gesamtrang | INT | Ja | | 815 |
| GueltigAb | DATE | Nein | | 2025-12-10 |
| GueltigBis | DATE | Ja | | 2026-01-09 |

### Regeln

- Pro Spieler und Monatslauf existiert genau ein offizieller Elo-Stand.
- Der Elo-Wert gilt bis zum nächsten Berechnungsstichtag.
- Innerhalb eines Berechnungsmonats wird für alle Spiele immer mit dem Elo-Wert des letzten offiziellen Stichtags gerechnet.
- `EloDeltaZumVormonat` zeigt die Veränderung gegenüber dem vorherigen offiziellen Monatsstand.
- Die Rangwerte beziehen sich auf den offiziellen Monatsstand.

## 17. EloMonatslauf

### Zweck

Speichert die monatlichen offiziellen Elo-Berechnungsläufe.

Alle Elo-relevanten Einzelspiele seit dem letzten Berechnungsstichtag werden einem Monatslauf zugeordnet.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| EloMonatslaufID | BIGINT IDENTITY | Nein | PK | 15 |
| Berechnungsdatum | DATE | Nein | UNIQUE | 2025-12-10 |
| PeriodeVon | DATE | Nein | | 2025-11-10 |
| PeriodeBis | DATE | Nein | | 2025-12-09 |
| Status | VARCHAR(20) | Nein | | ABGESCHLOSSEN |
| GestartetAm | DATETIME2(0) | Ja | | 2025-12-10 00:05:00 |
| AbgeschlossenAm | DATETIME2(0) | Ja | | 2025-12-10 00:10:00 |
| Bemerkung | NVARCHAR(500) | Ja | | Monatslauf Dezember |

### Mögliche Werte `Status`

- `GEPLANT`
- `LAUFEND`
- `ABGESCHLOSSEN`
- `FEHLER`

### Regeln

- Der offizielle Berechnungsstichtag liegt jeweils am 10. des Monats.
- Alle Spiele innerhalb der Periode verwenden den Elo-Wert des letzten offiziellen Stichtags.
- Nach Abschluss des Monatslaufs entsteht für jeden betroffenen Spieler ein neuer Datensatz in `SpielerElo`.

## 18. EloProtokoll

### Zweck

Speichert die Elo-Auswirkung eines einzelnen Elo-relevanten Einzelspiels.

Pro Einzelspiel entstehen zwei Datensätze:
- ein Datensatz für Spieler 1
- ein Datensatz für Spieler 2

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| EloProtokollID | BIGINT IDENTITY | Nein | PK | 1 |
| EinzelspielID | BIGINT | Nein | FK → Einzelspiel | 10001 |
| LizenzNr | INT | Nein | FK → Spieler | 512038 |
| GegnerLizenzNr | INT | Nein | FK → Spieler | 510101 |
| Berechnungsstichtag | DATE | Nein | | 2025-11-10 |
| StichtagsElo | DECIMAL(10,3) | Nein | | 1145.000 |
| GegnerStichtagsElo | DECIMAL(10,3) | Nein | | 1281.000 |
| Gewinnwahrscheinlichkeit | DECIMAL(8,6) | Nein | | 0.172800 |
| EloDelta | DECIMAL(10,3) | Nein | | -8.000 |
| VorschauElo | DECIMAL(10,3) | Nein | | 1137.000 |
| EloMonatslaufID | BIGINT | Ja | FK → EloMonatslauf | 16 |
| Berechnungsdatum | DATETIME2(0) | Nein | | 2025-11-26 22:00:00 |

### Regeln

- Elo-relevant sind nur `REGULAER` und `AUFGABE`.
- `FORFAIT`, `NICHTANGETRETEN` und `ANNULLIERT` erzeugen kein Elo-Protokoll.
- Innerhalb eines Monats wird immer mit dem offiziellen Elo des letzten Berechnungsstichtags gerechnet.
- Der Elo-Wert eines früheren Spiels im gleichen Monat wird nicht als Ausgangswert für das nächste Spiel verwendet.
- `VorschauElo` zeigt den kumulierten Zwischenstand nach diesem Spiel.

### Siegwahrscheinlichkeit

Die Siegwahrscheinlichkeit wird berechnet mit:

`1 / (1 + 10 ^ ((GegnerElo - EigeneElo) / 200))`

Beispiel:

- Eigener Elo: 1145
- Gegner Elo: 1281
- Siegwahrscheinlichkeit: ca. 0.173

Die Niederlagewahrscheinlichkeit ergibt sich als:

`1 - Siegwahrscheinlichkeit`

## 19. Funktion

### Zweck

Speichert mögliche Funktionen innerhalb eines Clubs.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| FunktionID | INT IDENTITY | Nein | PK | 1 |
| Bezeichnung | NVARCHAR(100) | Nein | UNIQUE | Präsident |
| Aktiv | BIT | Nein | | 1 |

### Beispieldaten

- Präsident
- Finanzchef
- Sekretär
- Technischer Verantwortlicher
- Nachwuchsverantwortlicher

### Regeln

- Die Bezeichnung einer Funktion muss eindeutig sein.
- Nur aktive Funktionen sollen für neue Zuordnungen verwendet werden.

## 20. Vereinsfunktionaer

### Zweck

Speichert Kontaktpersonen eines Clubs.

Ein Vereinsfunktionär muss kein lizenzierter Spieler sein.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| FunktionaerID | INT IDENTITY | Nein | PK | 1 |
| VereinsNr | INT | Nein | FK → Club | 50048 |
| Vorname | NVARCHAR(80) | Nein | | Fabio |
| Nachname | NVARCHAR(80) | Nein | | Leus |
| Email | NVARCHAR(255) | Ja | | fabio.leus@example.ch |
| TelefonPrivat | NVARCHAR(30) | Ja | | 033 437 06 38 |
| TelefonMobil | NVARCHAR(30) | Ja | | 077 422 11 60 |
| Strasse | NVARCHAR(100) | Ja | | Aarestrasse |
| Hausnummer | NVARCHAR(10) | Ja | | 13 |
| PLZ | CHAR(4) | Ja | | 3627 |
| Ort | NVARCHAR(100) | Ja | | Heimberg |
| Aktiv | BIT | Nein | | 1 |

### Regeln

- Ein Funktionär gehört zu genau einem Club.
- Ein Funktionär kann mehrere Funktionen besitzen.
- Die eigentliche Funktionszuordnung erfolgt über `FunktionaerFunktion`.

## 21. FunktionaerFunktion

### Zweck

Verknüpft Vereinsfunktionäre mit ihren Funktionen.

Ein Funktionär kann mehrere Funktionen gleichzeitig besitzen.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| FunktionaerID | INT | Nein | PK, FK → Vereinsfunktionaer | 1 |
| FunktionID | INT | Nein | PK, FK → Funktion | 1 |
| GueltigAb | DATE | Nein | PK | 2025-07-01 |
| GueltigBis | DATE | Ja | | NULL |

### Regeln

- Der Primärschlüssel besteht aus `FunktionaerID`, `FunktionID` und `GueltigAb`.
- Eine Person kann mehrere Funktionen gleichzeitig besitzen.
- `GueltigBis = NULL` bedeutet, dass die Zuordnung aktuell gültig ist.

## 22. Benutzer

### Zweck

Speichert Benutzerkonten für die Verwaltung der STT-Datenbank.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| BenutzerID | INT IDENTITY | Nein | PK | 1 |
| Benutzername | NVARCHAR(100) | Nein | UNIQUE | heimberg.admin |
| Anzeigename | NVARCHAR(150) | Nein | | TTC Heimberg |
| LizenzNr | INT | Ja | FK → Spieler | 512038 |
| Rolle | VARCHAR(20) | Nein | | VEREIN |
| VereinsNr | INT | Ja | FK → Club | 50048 |
| VerbandID | INT | Ja | FK → Verband | 6 |
| Aktiv | BIT | Nein | | 1 |

### Mögliche Werte `Rolle`

- `CAPTAIN`
- `VEREIN`
- `KLASSENLEITER`
- `ADMIN`

### Rechte

#### CAPTAIN

- darf Resultate und Matchblätter der zugewiesenen Mannschaft pflegen
- darf nicht automatisch andere Mannschaften des Clubs bearbeiten

#### VEREIN

- darf Daten des eigenen Vereins pflegen
- darf Spielorte verwalten
- darf Vereinsfunktionäre verwalten
- darf Mannschaften und Mannschaftskader verwalten
- darf Resultate aller eigenen Mannschaften pflegen

#### KLASSENLEITER

- darf die ihm zugeordneten Ligaphasen verwalten
- darf Matchblätter genehmigen
- darf genehmigte Matchblätter korrigieren
- kann für einen Regionalverband oder eine Nationalliga zuständig sein

#### ADMIN

- besitzt vollständigen Zugriff

### Regeln

- `LizenzNr` ist insbesondere bei einem Captain sinnvoll.
- `VereinsNr` wird bei Vereinsbenutzern verwendet.
- `VerbandID` kann bei Klassenleitern verwendet werden.
- Nicht jede Rolle benötigt alle optionalen Fremdschlüssel.

## 23. BenutzerMannschaft

### Zweck

Ordnet einen Benutzer mit der Rolle `CAPTAIN` einer oder mehreren Mannschaften zu.

Damit kann eingeschränkt werden, welche Mannschaftsergebnisse ein Captain pflegen darf.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| BenutzerID | INT | Nein | PK, FK → Benutzer | 1 |
| MannschaftID | INT | Nein | PK, FK → Mannschaft | 25 |

### Regeln

- Der Primärschlüssel besteht aus `BenutzerID` und `MannschaftID`.
- Der Benutzer sollte die Rolle `CAPTAIN` besitzen.
- Ein Captain kann nur die zugeordneten Mannschaften bearbeiten.
- Ein Benutzer kann bei Bedarf mehreren Mannschaften zugeordnet werden.

## 24. Ball

### Zweck

Speichert die verschiedenen zugelassenen bzw. verwendeten Tischtennisbälle.

Ballmarke, Modell und Farbe werden separat gespeichert, da verschiedene Kombinationen existieren.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| BallID | INT IDENTITY | Nein | PK | 1 |
| Marke | NVARCHAR(100) | Nein | | Nittaku |
| Modell | NVARCHAR(100) | Nein | | Premium 40+ |
| Farbe | VARCHAR(20) | Nein | | WEISS |
| Aktiv | BIT | Nein | | 1 |

### Beispieldaten

| Marke | Modell | Farbe |
|---|---|---|
| Nittaku | Premium 40+ | WEISS |
| DHS | D40+ 3-Star | WEISS |
| Tibhar | SYNTT NG 40+ | WEISS |

### Regeln

- Die Kombination aus `Marke`, `Modell` und `Farbe` muss eindeutig sein.
- Ein Ball kann von mehreren Clubs bzw. Wettbewerben verwendet werden.
- `Aktiv = 0` kann für nicht mehr verwendete Modelle eingesetzt werden.

## 25. Spielsystem

### Zweck

Definiert das Spielsystem einer Mannschaftsbegegnung.

Für das normale Schweizer Mannschaftssystem werden in der Regel neun Einzel und ein Doppel gespielt.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| SpielsystemID | INT IDENTITY | Nein | PK | 1 |
| Bezeichnung | NVARCHAR(100) | Nein | UNIQUE | 3er-Mannschaft |
| AnzahlSpieler | TINYINT | Nein | | 3 |
| AnzahlEinzel | TINYINT | Nein | | 9 |
| AnzahlDoppel | TINYINT | Nein | | 1 |
| MaxAnzahlSpiele | TINYINT | Nein | | 10 |
| Aktiv | BIT | Nein | | 1 |

### Beispiel

| Bezeichnung | AnzahlSpieler | AnzahlEinzel | AnzahlDoppel | MaxAnzahlSpiele |
|---|---:|---:|---:|---:|
| 3er-Mannschaft | 3 | 9 | 1 | 10 |

### Regeln

- Das normale System besteht aus drei Spielern pro Mannschaft.
- Es werden neun Einzel und ein Doppel gespielt.
- Tritt eine Mannschaft nur mit zwei Spielern an, bleiben die Spiele der fehlenden Position als Forfait bestehen.
- Dadurch gehen drei Einzel forfait verloren.
- Das Doppel darf trotzdem von den beiden anwesenden Spielern gespielt werden.
- Seltene alternative Spielsysteme werden für dieses Demonstrationsprojekt nicht detailliert modelliert.

## 26. Ligawettbewerb

### Zweck

Definiert einen Ligawettbewerb innerhalb einer Saison.

Ein Ligawettbewerb beschreibt beispielsweise die Nationalliga A, Nationalliga B oder eine Liga eines Regionalverbands.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| LigawettbewerbID | INT IDENTITY | Nein | PK | 1 |
| SaisonID | INT | Nein | FK → Saison | 1 |
| VerbandID | INT | Nein | FK → Verband | 1 |
| Bezeichnung | NVARCHAR(100) | Nein | | Nationalliga A |
| Geschlechtskategorie | VARCHAR(10) | Nein | | HERREN |
| Alterskategorie | VARCHAR(10) | Ja | FK → Alterskategorie | NULL |
| SpielsystemID | INT | Nein | FK → Spielsystem | 1 |
| Aktiv | BIT | Nein | | 1 |

### Mögliche Werte `Geschlechtskategorie`

- `HERREN`
- `DAMEN`

### Beispiele

| Verband | Bezeichnung | Geschlechtskategorie | Alterskategorie |
|---|---|---|---|
| STT | Nationalliga A | HERREN | NULL |
| STT | Nationalliga B | HERREN | NULL |
| MTTV | 1. Liga | HERREN | NULL |
| MTTV | O40 | HERREN | O40 |

### Regeln

- Ein Ligawettbewerb gehört zu genau einer Saison.
- Ein Ligawettbewerb wird von genau einem Verband durchgeführt.
- Nationalligen werden durch Swiss Table Tennis (STT) durchgeführt.
- Regionale Ligen werden durch den jeweiligen Regionalverband durchgeführt.
- `Alterskategorie = NULL` bedeutet, dass keine spezielle Alterskategorie vorgeschrieben ist.
- Eine Liga der Aktiven benötigt keine Altersbeschränkung, da dort auch Nachwuchs- und Seniorenspieler teilnehmen dürfen.
- Bei einer O40-Liga können auch O50-, O70- oder O80-Spieler teilnehmen.
- Bei Nachwuchsligen kann ein jüngerer Spieler in einer höheren Nachwuchskategorie eingesetzt werden.

## 27. Ligaphase

### Zweck

Speichert Gruppen bzw. Phasen eines Ligawettbewerbs.

Für dieses Projekt wird die Tabelle hauptsächlich verwendet, um verschiedene Gruppen innerhalb derselben Liga abzubilden.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| LigaphaseID | INT IDENTITY | Nein | PK | 1 |
| LigawettbewerbID | INT | Nein | FK → Ligawettbewerb | 3 |
| Bezeichnung | NVARCHAR(100) | Nein | | Gruppe 2 |
| Phasentyp | VARCHAR(20) | Nein | | HAUPTRUNDE |
| Gruppenbezeichnung | NVARCHAR(50) | Ja | | Gruppe 2 |
| KlassenleiterBenutzerID | INT | Ja | FK → Benutzer | 12 |
| Aktiv | BIT | Nein | | 1 |

### Mögliche Werte `Phasentyp`

- `HAUPTRUNDE`
- `VORRUNDE`
- `FINALRUNDE`

### Regeln

- Eine Ligaphase gehört zu genau einem Ligawettbewerb.
- Ein Ligawettbewerb kann mehrere Gruppen besitzen.
- Ein Klassenleiter kann einer oder mehreren Ligaphasen zugeordnet sein.
- Komplexe Auf- und Abstiegslogik wird in diesem Demonstrationsprojekt nicht vollständig modelliert.

## 28. Mannschaft

### Zweck

Speichert eine Ligamannschaft eines Clubs.

Der sichtbare Mannschaftsname wird aus dem Club-Kurznamen und der Mannschaftsnummer gebildet.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| MannschaftID | INT IDENTITY | Nein | PK | 1 |
| VereinsNr | INT | Nein | FK → Club | 50048 |
| LigaphaseID | INT | Nein | FK → Ligaphase | 1 |
| MannschaftNummer | TINYINT | Nein | | 2 |
| KapitaenLizenz | INT | Nein | FK → Spieler | 512038 |
| BallID | INT | Ja | FK → Ball | 1 |
| Aktiv | BIT | Nein | | 1 |

### Anzeige des Mannschaftsnamens

Beispiel bei `Club.Kurzname = Heimberg`:

| MannschaftNummer | Anzeigename |
|---:|---|
| 1 | Heimberg |
| 2 | Heimberg II |
| 3 | Heimberg III |
| 4 | Heimberg IV |

### Regeln

- Der Captain muss immer eine gültige Lizenznummer besitzen.
- Die Alters- oder Geschlechtskategorie ist Teil des Ligawettbewerbs und nicht Teil des Mannschaftsnamens.
- Eine Mannschaft in einer O40-Liga heißt beispielsweise `Heimberg II` und nicht `Senioren O40 II`.
- Der Ball wird über `BallID` referenziert.

## 29. MannschaftSpieler

### Zweck

Speichert die Zuordnung eines Spielers zu einer Ligamannschaft.

Die Tabelle bildet Stammspieler, Ersatzspieler und die spätere Statusänderung innerhalb der Saison ab.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| MannschaftSpielerID | BIGINT IDENTITY | Nein | PK | 1 |
| MannschaftID | INT | Nein | FK → Mannschaft | 1 |
| LizenzNr | INT | Nein | FK → Spieler | 512038 |
| Meldungsart | VARCHAR(20) | Nein | | STAMMSPIELER |
| StammPosition | TINYINT | Ja | | 3 |
| Spielberechtigt | BIT | Nein | | 1 |
| Bemerkung | NVARCHAR(500) | Ja | | NULL |

### Mögliche Werte `Meldungsart`

- `STAMMSPIELER`
- `ERSATZSPIELER`

### Darstellung

Ein vor Saisonbeginn gemeldeter Stammspieler erhält eine Kombination aus Mannschaftsnummer und Stammposition.

Beispiele:

- Mannschaft 1, Position 1 → `1.1`
- Mannschaft 1, Position 2 → `1.2`
- Mannschaft 1, Position 3 → `1.3`
- Mannschaft 2, Position 1 → `2.1`
- Mannschaft 2, Position 2 → `2.2`
- Mannschaft 2, Position 3 → `2.3`

Weitere sichtbare Statuswerte:

- `E` = eingesetzter Ersatzspieler
- `S` = nach Saisonbeginn Stammspieler geworden
- `V` = für diese Mannschaft nicht mehr spielberechtigt

### Regeln

- Es existieren nur die Stammpositionen 1, 2 und 3.
- Es gibt kein `2.4`, `2.5` usw.
- Weitere Spieler werden als Ersatzspieler geführt.
- Sobald ein Ersatzspieler eingesetzt wurde, kann er mit `E` dargestellt werden.
- Nach dem dritten Einsatz wird der Ersatzspieler zum Stammspieler und mit `S` dargestellt.
- `V` bedeutet, dass der Spieler für diese Mannschaft nicht mehr spielberechtigt ist, weil er inzwischen Stammspieler einer anderen Mannschaft geworden ist.
- Eintritts- und Austrittsdatum werden nicht gespeichert.
- Einsatz- und Ergebnisstatistiken werden aus den tatsächlich gespeicherten Spielen berechnet und nicht redundant in dieser Tabelle gespeichert.

## 30. Begegnung

### Zweck

Speichert eine vollständige Mannschaftsbegegnung innerhalb einer Ligaphase.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| BegegnungID | BIGINT IDENTITY | Nein | PK | 9001 |
| LigaphaseID | INT | Nein | FK → Ligaphase | 1 |
| HeimMannschaftID | INT | Nein | FK → Mannschaft | 10 |
| GastMannschaftID | INT | Nein | FK → Mannschaft | 11 |
| SpielortID | INT | Nein | FK → Spielort | 3 |
| Runde | TINYINT | Ja | | 9 |
| Datum | DATE | Nein | | 2026-03-27 |
| Startzeit | TIME(0) | Nein | | 19:45 |
| Endzeit | TIME(0) | Ja | | 21:40 |
| SiegeHeim | TINYINT | Ja | | 3 |
| SiegeGast | TINYINT | Ja | | 7 |
| MannschaftspunkteHeim | TINYINT | Ja | | 1 |
| MannschaftspunkteGast | TINYINT | Ja | | 3 |
| SaetzeHeim | SMALLINT | Ja | | 12 |
| SaetzeGast | SMALLINT | Ja | | 24 |
| BaelleHeim | SMALLINT | Ja | | 298 |
| BaelleGast | SMALLINT | Ja | | 360 |
| ZuschauerAnzahl | SMALLINT | Ja | | 2 |
| SchiedsrichterName | NVARCHAR(150) | Ja | | Max Muster |
| MatchblattGenehmigt | BIT | Nein | | 1 |
| GenehmigtAm | DATETIME2(0) | Ja | | 2026-03-28 10:15:00 |
| GenehmigtVon | INT | Ja | FK → Benutzer | 12 |
| Status | VARCHAR(20) | Nein | | GENEHMIGT |

### Mögliche Werte `Status`

- `GEPLANT`
- `LAUFEND`
- `ABGESCHLOSSEN`
- `GENEHMIGT`
- `ANNULLIERT`

### Mannschaftspunkte

Die Mannschaftspunkte werden gespeichert.

| Gewonnene Spiele | Mannschaftspunkte |
|---:|---:|
| 8 bis 10 | 4 |
| 6 bis 7 | 3 |
| 5 | 2 |
| 3 bis 4 | 1 |
| 0 bis 2 | 0 |

Beispiele:

- 8:2 → 4:0 Punkte
- 7:3 → 3:1 Punkte
- 5:5 → 2:2 Punkte
- 4:6 → 1:3 Punkte
- 2:8 → 0:4 Punkte

### Regeln

- Heim- und Gastmannschaft müssen verschieden sein.
- Beide Mannschaften müssen zur gleichen Ligaphase gehören.
- Eine normale Begegnung besteht aus neun Einzeln und einem Doppel.
- `SiegeHeim`, `SiegeGast`, Satzverhältnis und Ballverhältnis werden beim Abschluss aus den Spielen berechnet.
- Mannschaftspunkte werden berechnet und dauerhaft gespeichert.
- Nach Status `GENEHMIGT` dürfen Captain und Verein die Begegnung nicht mehr ändern.
- Klassenleiter und Admin dürfen genehmigte Begegnungen korrigieren.
- Änderungen nach der Genehmigung werden protokolliert.
- Ein Schiedsrichter ist nur dort relevant, wo die Wettbewerbsregeln einen verlangen.

## 31. Begegnungsaufstellung

### Zweck

Speichert die Spieleraufstellung für eine konkrete Mannschaftsbegegnung.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| BegegnungsaufstellungID | BIGINT IDENTITY | Nein | PK | 1 |
| BegegnungID | BIGINT | Nein | FK → Begegnung | 9001 |
| MannschaftID | INT | Nein | FK → Mannschaft | 11 |
| LizenzNr | INT | Nein | FK → Spieler | 512038 |
| Seite | VARCHAR(4) | Nein | | GAST |
| Position | CHAR(1) | Nein | | Z |

### Mögliche Werte `Seite`

- `HEIM`
- `GAST`

### Mögliche Werte `Position`

Heimmannschaft:

- `A`
- `B`
- `C`

Gastmannschaft:

- `X`
- `Y`
- `Z`

### Regeln

- Heimspieler verwenden nur A, B und C.
- Gastspieler verwenden nur X, Y und Z.
- Eine Position darf pro Begegnung nur einmal belegt sein.
- Ein Spieler darf innerhalb derselben Begegnungsaufstellung nicht doppelt eingetragen sein.
- Die Positionen gelten nur für diese eine Begegnung.
- Ein Doppelspieler muss nicht zwingend einer der drei Einzelspieler sein.
- Ein vierter spielberechtigter Spieler darf nur für das Doppel eingesetzt werden.

### Sonderfall: nur zwei Spieler

Wenn eine Mannschaft nur mit zwei statt drei Spielern antritt:

- eine Position bleibt unbesetzt
- die drei Einzel der fehlenden Position werden forfait verloren
- das Doppel darf trotzdem mit den zwei anwesenden Spielern gespielt werden

Beispiel Gastmannschaft:

- X = Spieler 1
- Y = Spieler 2
- Z = nicht besetzt

Die Einzel gegen Z werden als Forfaitspiele gespeichert.


## 32. Begegnungsbemerkung

### Zweck

Speichert Bemerkungen zu einer Begegnung getrennt nach Benutzer und Verantwortungsbereich.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| BegegnungsbemerkungID | BIGINT IDENTITY | Nein | PK | 1 |
| BegegnungID | BIGINT | Nein | FK → Begegnung | 9001 |
| BenutzerID | INT | Nein | FK → Benutzer | 12 |
| Bemerkungsart | VARCHAR(20) | Nein | | KLASSENLEITER |
| Text | NVARCHAR(MAX) | Nein | | Matchblatt geprüft |
| ErstelltAm | DATETIME2(0) | Nein | | 2026-03-28 10:14:00 |

### Mögliche Werte `Bemerkungsart`

- `VEREIN`
- `KLASSENLEITER`
- `ADMIN`

### Regeln

- Zu einer Begegnung können mehrere Bemerkungen gespeichert werden.
- Verein, Klassenleiter und Admin können getrennte Bemerkungen erfassen.
- Die Bemerkungen ersetzen kein Änderungsprotokoll.
- Nachträgliche Änderungen einer genehmigten Begegnung werden separat in `BegegnungAenderung` dokumentiert.

## 33. BegegnungAenderung

### Zweck

Dokumentiert nachträgliche Änderungen an einer bereits genehmigten Begegnung.

Es wird nicht jede alte Feldversion gespeichert, sondern nachvollziehbar gemacht, wer wann und warum eine genehmigte Begegnung geändert hat.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| BegegnungAenderungID | BIGINT IDENTITY | Nein | PK | 1 |
| BegegnungID | BIGINT | Nein | FK → Begegnung | 9001 |
| BenutzerID | INT | Nein | FK → Benutzer | 12 |
| Aenderungsdatum | DATETIME2(0) | Nein | | 2026-03-29 14:20:00 |
| Grund | NVARCHAR(500) | Nein | | Falsches Satzresultat korrigiert |

### Regeln

- Ein Eintrag wird nur bei Änderungen an einer bereits genehmigten Begegnung erzeugt.
- Nur Klassenleiter oder Admin dürfen eine genehmigte Begegnung ändern.
- `Grund` ist Pflicht.

## 34. Turnier

### Zweck

Speichert die allgemeinen Stammdaten eines Turniers.

Ein Turnier kann mehrere Kategorien enthalten.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| TurnierID | INT IDENTITY | Nein | PK | 1 |
| SaisonID | INT | Nein | FK → Saison | 1 |
| BewertungsperiodeID | INT | Nein | FK → Bewertungsperiode | 2 |
| Turniername | NVARCHAR(150) | Nein | | Heimberg Open 2026 |
| VeranstalterNr | INT | Nein | FK → Club | 50048 |
| SpielortID | INT | Nein | FK → Spielort | 1 |
| Startdatum | DATE | Nein | | 2026-05-12 |
| Enddatum | DATE | Ja | | 2026-05-12 |
| Meldeschluss | DATETIME2(0) | Nein | | 2026-05-01 23:59:00 |
| HallenSchiedsrichterName | NVARCHAR(150) | Ja | | Max Muster |
| Status | VARCHAR(20) | Nein | | OFFEN |

### Mögliche Werte `Status`

- `GEPLANT`
- `OFFEN`
- `AUSGELOST`
- `LAUFEND`
- `BEENDET`
- `ABGESAGT`

### Bedeutung der Statuswerte

- `GEPLANT`: Turnier ist erfasst, Anmeldung noch nicht offen
- `OFFEN`: Anmeldung ist geöffnet
- `AUSGELOST`: Anmeldung geschlossen, Auslosung bzw. Einteilung erfolgt
- `LAUFEND`: Turnier findet aktuell statt
- `BEENDET`: Turnier abgeschlossen
- `ABGESAGT`: Turnier findet nicht statt

### Regeln

- Ein Turnier gehört zu genau einer Saison.
- Für alle Kategorien eines Turniers gilt dieselbe Bewertungsperiode.
- Die Bewertungsperiode orientiert sich am Turnierdatum.
- Ein Turnier kann mehrere Kategorien besitzen.
- Spielerfotos, Clublogos, Hallentische und Tischnummern werden nicht gepflegt.
- Bei Turnieren reicht es für dieses Projekt, einen Hallenschiedsrichter als optionale Information zu speichern.

## 35. TurnierKategorie

### Zweck

Speichert eine einzelne Konkurrenz bzw. Kategorie eines Turniers.

Eine Kategorie kann über Alter, Klassierung, Elo oder eine Kombination mehrerer Kriterien eingeschränkt werden.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| TurnierKategorieID | INT IDENTITY | Nein | PK | 101 |
| TurnierID | INT | Nein | FK → Turnier | 1 |
| Bezeichnung | NVARCHAR(150) | Nein | | Herren B Einzel |
| Kategorieart | VARCHAR(20) | Nein | | KLASSIERUNG |
| Wettkampfform | VARCHAR(15) | Nein | | EINZEL |
| Geschlechtskategorie | VARCHAR(10) | Nein | | HERREN |
| VerwendeteKlassierungsart | VARCHAR(10) | Ja | | HERREN |
| Alterskategorie | VARCHAR(10) | Ja | FK → Alterskategorie | U19 |
| Altersregel | VARCHAR(20) | Nein | | BIS_MAXALTER |
| BevorzugePassendeKategorie | BIT | Nein | | 1 |
| MinStufenwert | TINYINT | Ja | FK → Klassierungsstufe | 11 |
| MaxStufenwert | TINYINT | Ja | FK → Klassierungsstufe | 15 |
| AlleSpielerMuessenKlassierungErfuellen | BIT | Nein | | 1 |
| MinEloWert | DECIMAL(10,3) | Ja | | 800.000 |
| TopEloWert | DECIMAL(10,3) | Ja | | 1200.000 |
| AlleSpielerMuessenEloErfuellen | BIT | Nein | | 1 |
| SpielerProTeam | TINYINT | Ja | | 2 |
| MinKlassierungSumme | SMALLINT | Ja | | 15 |
| MaxKlassierungSumme | SMALLINT | Ja | | 20 |
| MinEloSumme | DECIMAL(10,3) | Ja | | NULL |
| MaxEloSumme | DECIMAL(10,3) | Ja | | 2400.000 |
| Gewinnsaetze | TINYINT | Nein | | 3 |
| Status | VARCHAR(20) | Nein | | OFFEN |

### Mögliche Werte `Kategorieart`

- `ALTER`
- `KLASSIERUNG`
- `ELO`
- `OFFEN`
- `KOMBINIERT`

### Mögliche Werte `Wettkampfform`

- `EINZEL`
- `DOPPEL`
- `MANNSCHAFT`

### Mögliche Werte `Geschlechtskategorie`

- `HERREN`
- `DAMEN`
- `MIXED`
- `OFFEN`

### Mögliche Werte `VerwendeteKlassierungsart`

- `HERREN`
- `DAMEN`
- `NULL`

### Mögliche Werte `Altersregel`

- `ALLE`
- `BIS_MAXALTER`
- `AB_MINALTER`
- `EXAKT`

### Alterslogik

#### Aktive

`Alterskategorie = Aktive` bzw. keine spezielle Altersbegrenzung bedeutet:

- alle Alterskategorien dürfen teilnehmen
- U-Spieler dürfen teilnehmen
- Aktive dürfen teilnehmen
- O-Spieler dürfen teilnehmen

#### Nachwuchs

Beispiel U13:

- U11 darf U13 spielen
- U13 darf U13 spielen
- ältere Kategorien nicht

Wenn eine passende U11-Kategorie vorhanden ist, wird diese für einen U11-Spieler bevorzugt, aber die Teilnahme in U13 ist grundsätzlich möglich.

#### Senioren

Beispiel O40:

- O40 darf teilnehmen
- O50 darf teilnehmen
- O70 darf teilnehmen
- O80 darf teilnehmen

Ältere Senioren dürfen also in einer jüngeren Seniorenkategorie spielen.

### Klassierungslogik

- Jeder Spieler besitzt eine Herrenklassierung.
- Frauen besitzen zusätzlich eine Damenklassierung.
- Bei Damenkategorien wird die Damenklassierung verwendet.
- Bei Herren-, Mixed- und offenen Kategorien wird die Herrenklassierung verwendet.

### Beispiele

#### Herren B Einzel

- `Kategorieart = KLASSIERUNG`
- `Wettkampfform = EINZEL`
- `Geschlechtskategorie = HERREN`
- `VerwendeteKlassierungsart = HERREN`
- `MinStufenwert = 11`
- `MaxStufenwert = 15`

#### Top 1200 Einzel

- `Kategorieart = ELO`
- `Wettkampfform = EINZEL`
- `TopEloWert = 1200`

#### U19 Einzel

- `Kategorieart = ALTER`
- `Wettkampfform = EINZEL`
- `Alterskategorie = U19`
- `Altersregel = BIS_MAXALTER`

#### Doppel C

- `Kategorieart = KLASSIERUNG`
- `Wettkampfform = DOPPEL`
- `MaxStufenwert = 10`
- `AlleSpielerMuessenKlassierungErfuellen = 1`

#### Doppel Top 2400

- `Kategorieart = ELO`
- `Wettkampfform = DOPPEL`
- `MaxEloSumme = 2400`

#### Zweiermannschaft Summe 20

- `Kategorieart = KLASSIERUNG`
- `Wettkampfform = MANNSCHAFT`
- `SpielerProTeam = 2`
- `MaxKlassierungSumme = 20`

### Regeln

- Nur gesetzte Kriterien werden geprüft.
- Bei Doppel- und Mannschaftskategorien können Kriterien pro Spieler oder als Summe gelten.
- Bei Alterskategorien kann jeder einzelne Spieler geprüft werden.
- Bei Kategorien mit Elo-Grenze wird der Wert aus `SpielerBewertung` verwendet.
- Bei Turnieren mit vier Gewinnsätzen kann `Gewinnsaetze = 4` gesetzt werden.

## 36. Einzelanmeldung

### Zweck

Speichert die Anmeldung eines einzelnen Spielers zu einer Turnierkategorie.

Die Zulassung wird anhand der zum Turnier gehörenden Bewertungsperiode geprüft.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| EinzelanmeldungID | BIGINT IDENTITY | Nein | PK | 1 |
| TurnierKategorieID | INT | Nein | FK → TurnierKategorie | 101 |
| LizenzNr | INT | Nein | FK → Spieler | 512038 |
| Anmeldedatum | DATETIME2(0) | Nein | | 2026-02-15 18:30:00 |
| Status | VARCHAR(20) | Nein | | BESTAETIGT |
| Ablehnungsgrund | NVARCHAR(500) | Ja | | NULL |

### Mögliche Werte `Status`

- `ANGEMELDET`
- `BESTAETIGT`
- `ABGELEHNT`
- `ZURUECKGEZOGEN`

### Regeln

- Die Kategorie muss `Wettkampfform = EINZEL` besitzen.
- Ein Spieler darf nicht mehrfach in derselben Turnierkategorie angemeldet werden.
- Elo, Klassierung und Alterskategorie werden nicht zum Anmeldezeitpunkt gespeichert.
- Die Prüfung verwendet `SpielerBewertung` der Bewertungsperiode des Turniers.
- Bei einer Ablehnung kann der Grund gespeichert werden.

## 37. Doppelanmeldung

### Zweck

Speichert die Anmeldung eines Doppelpaars zu einer Turnierkategorie.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| DoppelanmeldungID | BIGINT IDENTITY | Nein | PK | 1 |
| TurnierKategorieID | INT | Nein | FK → TurnierKategorie | 201 |
| Spieler1Lizenz | INT | Nein | FK → Spieler | 512038 |
| Spieler2Lizenz | INT | Nein | FK → Spieler | 510103 |
| Anmeldedatum | DATETIME2(0) | Nein | | 2026-02-15 19:00:00 |
| Status | VARCHAR(20) | Nein | | BESTAETIGT |
| Ablehnungsgrund | NVARCHAR(500) | Ja | | NULL |

### Regeln

- Die Kategorie muss `Wettkampfform = DOPPEL` besitzen.
- Spieler 1 und Spieler 2 müssen verschieden sein.
- Eine Paarung darf nicht doppelt in derselben Kategorie angemeldet werden.
- Bei Mixed muss die Geschlechterkombination den Regeln entsprechen.
- Je nach Kategorie können folgende Kriterien geprüft werden:
  - beide U19
  - beide maximal C
  - maximale Elo-Summe
  - maximale Klassierungssumme
- Elo, Klassierung und Alterskategorie werden aus `SpielerBewertung` gelesen.

## 38. Turniermannschaft

### Zweck

Speichert eine speziell für ein Turnier gebildete Mannschaft.

Spieler aus unterschiedlichen Clubs dürfen gemeinsam in derselben Turniermannschaft spielen.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| TurniermannschaftID | BIGINT IDENTITY | Nein | PK | 1 |
| TurnierKategorieID | INT | Nein | FK → TurnierKategorie | 301 |
| Name | NVARCHAR(100) | Nein | | Team Mittelland |
| Anmeldedatum | DATETIME2(0) | Nein | | 2026-02-20 16:00:00 |
| Status | VARCHAR(20) | Nein | | BESTAETIGT |
| Ablehnungsgrund | NVARCHAR(500) | Ja | | NULL |

### Mögliche Werte `Status`

- `ANGEMELDET`
- `BESTAETIGT`
- `ABGELEHNT`
- `ZURUECKGEZOGEN`

### Regeln

- Die Kategorie muss `Wettkampfform = MANNSCHAFT` besitzen.
- Eine Turniermannschaft gehört nicht zwingend zu einem Club.
- Spieler verschiedener Clubs dürfen gemeinsam antreten.
- Deshalb besitzt die Tabelle bewusst keine `VereinsNr`.
- Die Anzahl der Spieler richtet sich nach `TurnierKategorie.SpielerProTeam`.
- Die Zulassung wird mit den Werten aus `SpielerBewertung` geprüft.

## 39. TurniermannschaftSpieler

### Zweck

Ordnet Spieler einer Turniermannschaft zu.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| TurniermannschaftID | BIGINT | Nein | PK, FK → Turniermannschaft | 1 |
| LizenzNr | INT | Nein | PK, FK → Spieler | 512038 |
| Position | TINYINT | Ja | | 1 |
| IstCaptain | BIT | Nein | | 1 |

### Regeln

- Der Primärschlüssel besteht aus `TurniermannschaftID` und `LizenzNr`.
- Ein Spieler darf innerhalb derselben Turniermannschaft nur einmal vorkommen.
- Spieler aus verschiedenen Clubs dürfen gemeinsam antreten.
- Die Anzahl Spieler muss den Vorgaben der Turnierkategorie entsprechen.
- Elo, Klassierung und Alterskategorie werden nicht redundant gespeichert.
- Die Prüfwerte stammen aus `SpielerBewertung`.
- Je nach Kategorie können Einzelkriterien oder Summenkriterien geprüft werden.

## 40. Einzelspiel

### Zweck

Speichert ein einzelnes Spiel aus einer Ligabegegnung oder einer Turnierkategorie.

Ein Einzel kann regulär gespielt, durch Aufgabe beendet oder forfait gewertet werden.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| EinzelspielID | BIGINT IDENTITY | Nein | PK | 10001 |
| BegegnungID | BIGINT | Ja | FK → Begegnung | 9001 |
| TurnierKategorieID | INT | Ja | FK → TurnierKategorie | NULL |
| Spielnummer | TINYINT | Ja | | 1 |
| Spielcode | VARCHAR(10) | Ja | | A-X |
| Spieler1Lizenz | INT | Ja | FK → Spieler | 512038 |
| Spieler2Lizenz | INT | Ja | FK → Spieler | 510101 |
| GewinnerLizenz | INT | Ja | FK → Spieler | 512038 |
| Spieldatum | DATETIME2(0) | Nein | | 2026-03-27 19:45:00 |
| SaetzeSpieler1 | TINYINT | Nein | | 3 |
| SaetzeSpieler2 | TINYINT | Nein | | 1 |
| PunkteSpieler1 | TINYINT | Nein | | 1 |
| PunkteSpieler2 | TINYINT | Nein | | 0 |
| Spielgrund | VARCHAR(20) | Nein | | REGULAER |
| Status | VARCHAR(20) | Nein | | ABGESCHLOSSEN |

### Mögliche Werte `Spielgrund`

- `REGULAER`
- `AUFGABE`
- `FORFAIT`
- `NICHTANGETRETEN`
- `ANNULLIERT`

### Mögliche Werte `Status`

- `GEPLANT`
- `LAUFEND`
- `ABGESCHLOSSEN`
- `ANNULLIERT`

### Herkunft

Ein Einzel gehört entweder zu:

- einer Ligabegegnung über `BegegnungID`
- oder einer Turnierkategorie über `TurnierKategorieID`

Genau eine der beiden Zuordnungen muss gesetzt sein.

### Spielnummern in einer normalen Ligabegegnung

| Spielnummer | Spielcode |
|---:|---|
| 1 | A-X |
| 2 | B-Y |
| 3 | C-Z |
| 4 | B-X |
| 5 | A-Z |
| 6 | C-Y |
| 8 | B-Z |
| 9 | C-X |
| 10 | A-Y |

Spielnummer 7 ist das Doppel.

### Elo-Regeln

- `REGULAER` ist Elo-relevant.
- `AUFGABE` ist Elo-relevant.
- `FORFAIT` ist nicht Elo-relevant.
- `NICHTANGETRETEN` ist nicht Elo-relevant.
- `ANNULLIERT` ist nicht Elo-relevant.

### Forfait

Wenn eine Position nicht besetzt ist, darf die entsprechende Spieler-Lizenz `NULL` sein.

Beispiel:

- Spieler1Lizenz = 512038
- Spieler2Lizenz = NULL
- GewinnerLizenz = 512038
- SaetzeSpieler1 = 3
- SaetzeSpieler2 = 0
- PunkteSpieler1 = 1
- PunkteSpieler2 = 0
- Spielgrund = FORFAIT

Wenn beide Spieler bekannt sind, aber einer forfait gibt, werden beide Lizenznummern gespeichert.

Auch dann entsteht keine Elo-Veränderung.

### Aufgabe

Bei Aufgabe nach Spielbeginn:

- beide Spieler bleiben gespeichert
- nur tatsächlich gespielte Sätze werden in `Satz` gespeichert
- das Spiel bleibt Elo-relevant

### Regeln

- Spieler 1 und Spieler 2 dürfen bei regulären Spielen nicht identisch sein.
- `GewinnerLizenz` muss bei einem gewerteten Spiel einem der bekannten Spieler entsprechen.
- Bei regulären Spielen müssen beide Spieler gesetzt sein.
- Das Satzverhältnis wird über `SaetzeSpieler1` und `SaetzeSpieler2` gespeichert.
- Die einzelnen Satzresultate werden separat in `Satz` gespeichert.

## 41. Doppelspiel

### Zweck

Speichert ein Doppelspiel aus einer Ligabegegnung oder einer Turnierkategorie.

Die vier Spieler werden direkt im Doppelspiel gespeichert. Eine separate Stammdatentabelle für Doppelpaarungen wird nicht verwendet.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| DoppelspielID | BIGINT IDENTITY | Nein | PK | 20001 |
| BegegnungID | BIGINT | Ja | FK → Begegnung | 9001 |
| TurnierKategorieID | INT | Ja | FK → TurnierKategorie | NULL |
| Spielnummer | TINYINT | Ja | | 7 |
| Spielcode | VARCHAR(10) | Ja | | DOPPEL |
| Seite1Spieler1Lizenz | INT | Ja | FK → Spieler | 512038 |
| Seite1Spieler2Lizenz | INT | Ja | FK → Spieler | 510101 |
| Seite2Spieler1Lizenz | INT | Ja | FK → Spieler | 520001 |
| Seite2Spieler2Lizenz | INT | Ja | FK → Spieler | 520002 |
| Gewinnerseite | TINYINT | Ja | | 1 |
| Spieldatum | DATETIME2(0) | Nein | | 2026-03-27 20:30:00 |
| SaetzeSeite1 | TINYINT | Nein | | 3 |
| SaetzeSeite2 | TINYINT | Nein | | 2 |
| PunkteSeite1 | TINYINT | Nein | | 1 |
| PunkteSeite2 | TINYINT | Nein | | 0 |
| Spielgrund | VARCHAR(20) | Nein | | REGULAER |
| Status | VARCHAR(20) | Nein | | ABGESCHLOSSEN |

### Mögliche Werte `Gewinnerseite`

- `1`
- `2`
- `NULL`

### Mögliche Werte `Spielgrund`

- `REGULAER`
- `AUFGABE`
- `FORFAIT`
- `NICHTANGETRETEN`
- `ANNULLIERT`

### Herkunft

Ein Doppelspiel gehört entweder zu:

- einer Ligabegegnung
- oder einer Turnierkategorie

Genau eine Herkunft muss gesetzt sein.

### Ligabegegnung

In einer normalen Begegnung gilt:

- Spielnummer = 7
- Spielcode = DOPPEL

### Forfait

Bei einem Forfait dürfen Spieler-Lizenzen `NULL` sein.

Beispiel:

- Seite1Spieler1Lizenz = 512038
- Seite1Spieler2Lizenz = 510101
- Seite2Spieler1Lizenz = NULL
- Seite2Spieler2Lizenz = NULL
- Gewinnerseite = 1
- SaetzeSeite1 = 3
- SaetzeSeite2 = 0
- PunkteSeite1 = 1
- PunkteSeite2 = 0
- Spielgrund = FORFAIT

Wenn die forfaitgebenden Spieler bekannt sind, dürfen deren Lizenznummern trotzdem gespeichert werden.

### Regeln

- Bei einem regulären Doppel müssen alle vier Spieler gesetzt sein.
- Alle vier Spieler müssen bei einem regulären Doppel verschieden sein.
- Ein vierter Spieler darf ausschließlich für das Doppel eingesetzt werden, sofern er spielberechtigt ist.
- Das Satzverhältnis wird über `SaetzeSeite1` und `SaetzeSeite2` gespeichert.
- Die einzelnen Satzresultate werden in `Satz` gespeichert.
- Doppelspiele verändern den Elo-Wert nicht.
- Punkte pro Seite werden gespeichert, damit das Matchblatt vollständig abgebildet werden kann.

## 42. Satz

### Zweck

Speichert die tatsächlich gespielten Punkte eines einzelnen Satzes.

Die Tabelle wird sowohl für Einzel- als auch für Doppelspiele verwendet.

### Felder

| Feld | Datentyp | Null | Schlüssel | Beispiel |
|---|---|---|---|---|
| SatzID | BIGINT IDENTITY | Nein | PK | 1 |
| EinzelspielID | BIGINT | Ja | FK → Einzelspiel | 10001 |
| DoppelspielID | BIGINT | Ja | FK → Doppelspiel | NULL |
| SatzNummer | TINYINT | Nein | | 1 |
| PunkteSeite1 | TINYINT | Nein | | 11 |
| PunkteSeite2 | TINYINT | Nein | | 8 |

### Beispiel Einzelspiel

| SatzNummer | PunkteSeite1 | PunkteSeite2 |
|---:|---:|---:|
| 1 | 11 | 8 |
| 2 | 9 | 11 |
| 3 | 11 | 6 |
| 4 | 11 | 7 |

Daraus ergibt sich:

- Satzverhältnis = 3:1
- Punkteverhältnis = 42:32

### Beispiel Doppelspiel

| SatzNummer | PunkteSeite1 | PunkteSeite2 |
|---:|---:|---:|
| 1 | 9 | 11 |
| 2 | 8 | 11 |
| 3 | 11 | 6 |
| 4 | 12 | 10 |
| 5 | 9 | 11 |

Daraus ergibt sich:

- Satzverhältnis = 2:3
- Punkteverhältnis = 49:49

### Regeln

- Genau einer der beiden Fremdschlüssel `EinzelspielID` oder `DoppelspielID` muss gesetzt sein.
- Ein Satz gehört entweder zu einem Einzel oder zu einem Doppel.
- `SatzNummer` muss innerhalb eines Spiels eindeutig sein.
- Bei normalen Spielen mit drei Gewinnsätzen gibt es maximal fünf Sätze.
- Bei Turnieren mit vier Gewinnsätzen sind maximal sieben Sätze möglich.
- Die zulässige Anzahl Gewinnsätze wird über `TurnierKategorie.Gewinnsaetze` bestimmt.
- Bei Ligaspielen gelten drei Gewinnsätze.
- Bei Forfait werden keine künstlichen Satzpunkte gespeichert.
- Ein Forfait kann trotzdem ein gewertetes Satzverhältnis von 3:0 im Einzel- oder Doppelspiel besitzen.
- Bei Aufgabe werden nur die tatsächlich gespielten Sätze gespeichert.