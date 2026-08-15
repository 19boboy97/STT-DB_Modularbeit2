# Constraints

Dieses Dokument beschreibt die technischen Datenbankregeln der STT-Datenbank.

Verwendete Constraint-Arten:

- `PRIMARY KEY`
- `FOREIGN KEY`
- `UNIQUE`
- `CHECK`

## 1. Saison

### PRIMARY KEY

- `SaisonID`

### UNIQUE

- `Bezeichnung`

### CHECK

- `Enddatum > Startdatum`

### Besonderheit

Es darf höchstens eine Saison mit `IstAktuell = 1` geben.

Dies wird später über einen gefilterten UNIQUE-Index umgesetzt.

## 2. Verband

### PRIMARY KEY

- `VerbandID`

### FOREIGN KEY

- `UebergeordneterVerbandID` → `Verband.VerbandID`

### UNIQUE

- `Kurzname`

### CHECK

- `Verbandstyp IN ('NATIONAL', 'REGIONAL')`
- Bei `NATIONAL` muss `UebergeordneterVerbandID` NULL sein.
- Bei `REGIONAL` muss `UebergeordneterVerbandID` gesetzt sein.

## 2. Verband

### PRIMARY KEY

- `VerbandID`

### FOREIGN KEY

- `UebergeordneterVerbandID` → `Verband.VerbandID`

### UNIQUE

- `Kurzname`

### CHECK

- `Verbandstyp IN ('NATIONAL', 'REGIONAL')`
- Bei `NATIONAL` muss `UebergeordneterVerbandID` NULL sein.
- Bei `REGIONAL` muss `UebergeordneterVerbandID` gesetzt sein.

## 3. Club

### PRIMARY KEY

- `VereinsNr`

### FOREIGN KEY

- `RegionalverbandID` → `Verband.VerbandID`

### CHECK

- `Gruendungsjahr` muss NULL oder sinnvoll positiv sein.
- `Landcode` besteht aus zwei Zeichen.

### Hinweis

`Clubname` und `Kurzname` müssen nicht zwingend UNIQUE sein.

## 4. Spielort

### PRIMARY KEY

- `SpielortID`

### FOREIGN KEY

- `VereinsNr` → `Club.VereinsNr`

### UNIQUE

Sinnvoll:

- Kombination aus `VereinsNr` und `Bezeichnung`

### CHECK

- `IstHauptspielort IN (0,1)`
- `Aktiv IN (0,1)`

### Besonderheit

Pro Club sollte höchstens ein aktiver Hauptspielort existieren.

Dies wird später über einen gefilterten UNIQUE-Index umgesetzt.

## 5. Spieler

### PRIMARY KEY

- `LizenzNr`

### CHECK

- `Geschlecht IN ('M', 'W')`
- `Aktiv IN (0,1)`

## 6. SpielerSaison

### PRIMARY KEY

Zusammengesetzter Primärschlüssel:

- `LizenzNr`
- `SaisonID`

### FOREIGN KEY

- `LizenzNr` → `Spieler.LizenzNr`
- `SaisonID` → `Saison.SaisonID`
- `Alterskategorie` → `Alterskategorie.Bezeichnung`

### CHECK

- `LizenzAktiv IN (0,1)`

## 7. SpielerVerein

### PRIMARY KEY

- `SpielerVereinID`

### FOREIGN KEY

- `LizenzNr` → `Spieler.LizenzNr`
- `SaisonID` → `Saison.SaisonID`
- `VereinsNr` → `Club.VereinsNr`

### UNIQUE

- Kombination aus `LizenzNr`, `SaisonID`, `VereinsNr`, `Zuordnungsart`, `Wettbewerbsbereich`

### CHECK

- `Zuordnungsart IN ('HAUPTVEREIN', 'MEHRFACHLIZENZ')`
- `Wettbewerbsbereich IN ('ALLE', 'HERREN', 'DAMEN', 'NACHWUCHS', 'SENIOREN')`

### Besonderheit

Pro Spieler und Saison darf nur ein Hauptverein existieren.

Dies wird später über einen gefilterten UNIQUE-Index umgesetzt.

## 8. Alterskategorie

### PRIMARY KEY

- `Bezeichnung`

### CHECK

- `MinAlter >= 0`
- `MaxAlter IS NULL OR MaxAlter >= MinAlter`

## 9. Klassierungsstufe

### PRIMARY KEY

- `Stufenwert`

### UNIQUE

- `Bezeichnung`

### CHECK

- `Stufenwert BETWEEN 1 AND 22`

## 10. Klassierungsgrenze

### PRIMARY KEY

- `KlassierungsgrenzeID`

### FOREIGN KEY

- `BewertungsperiodeID` → `Bewertungsperiode.BewertungsperiodeID`
- `Stufenwert` → `Klassierungsstufe.Stufenwert`

### UNIQUE

- Kombination aus `BewertungsperiodeID`, `Stufenwert`, `Klassierungsart`

### CHECK

- `Klassierungsart IN ('HERREN', 'DAMEN')`
- `MinElo IS NULL OR MaxElo IS NULL OR MinElo <= MaxElo`
- `MittelElo IS NULL OR MinElo IS NULL OR MittelElo >= MinElo`
- `MittelElo IS NULL OR MaxElo IS NULL OR MittelElo <= MaxElo`

### Besonderheit

Die Elo-Bereiche einer Klassierungsart dürfen sich innerhalb derselben Bewertungsperiode nicht überschneiden.

Diese Regel wird später entweder über eine Stored Procedure oder durch kontrollierte Stammdatenpflege abgesichert.

## 11. Bewertungsperiode

### PRIMARY KEY

- `BewertungsperiodeID`

### FOREIGN KEY

- `SaisonID` → `Saison.SaisonID`

### UNIQUE

- Kombination aus `SaisonID` und `Bezeichnung`

### CHECK

- `Bezeichnung IN ('SAISONBEGINN', 'SAISONMITTE')`
- `GueltigBis >= GueltigAb`
- `Stichtag BETWEEN GueltigAb AND GueltigBis`

### Besonderheit

Pro Saison sollen genau zwei Bewertungsperioden existieren:

- `SAISONBEGINN`
- `SAISONMITTE`

## 12. SpielerBewertung

### PRIMARY KEY

- `SpielerBewertungID`

### FOREIGN KEY

- `LizenzNr` → `Spieler.LizenzNr`
- `BewertungsperiodeID` → `Bewertungsperiode.BewertungsperiodeID`
- `HerrenStufenwert` → `Klassierungsstufe.Stufenwert`
- `DamenStufenwert` → `Klassierungsstufe.Stufenwert`
- `Alterskategorie` → `Alterskategorie.Bezeichnung`

### UNIQUE

- Kombination aus `LizenzNr` und `BewertungsperiodeID`

### CHECK

- `Elo >= 0`

## 13. SpielerElo

### PRIMARY KEY

- `SpielerEloID`

### FOREIGN KEY

- `LizenzNr` → `Spieler.LizenzNr`
- `EloMonatslaufID` → `EloMonatslauf.EloMonatslaufID`
- `HerrenStufenwert` → `Klassierungsstufe.Stufenwert`
- `DamenStufenwert` → `Klassierungsstufe.Stufenwert`

### UNIQUE

- Kombination aus `LizenzNr` und `EloMonatslaufID`

### CHECK

- `Elo >= 0`
- `HerrenRang IS NULL OR HerrenRang > 0`
- `Gesamtrang IS NULL OR Gesamtrang > 0`
- `GueltigBis IS NULL OR GueltigBis >= GueltigAb`

## 14. EloMonatslauf

### PRIMARY KEY

- `EloMonatslaufID`

### UNIQUE

- `Berechnungsdatum`

### CHECK

- `PeriodeBis >= PeriodeVon`
- `Status IN ('GEPLANT', 'LAUFEND', 'ABGESCHLOSSEN', 'FEHLER')`
- `AbgeschlossenAm IS NULL OR GestartetAm IS NULL OR AbgeschlossenAm >= GestartetAm`

## 15. EloProtokoll

### PRIMARY KEY

- `EloProtokollID`

### FOREIGN KEY

- `EinzelspielID` → `Einzelspiel.EinzelspielID`
- `LizenzNr` → `Spieler.LizenzNr`
- `GegnerLizenzNr` → `Spieler.LizenzNr`
- `EloMonatslaufID` → `EloMonatslauf.EloMonatslaufID`

### UNIQUE

- Kombination aus `EinzelspielID` und `LizenzNr`

### CHECK

- `LizenzNr <> GegnerLizenzNr`
- `StichtagsElo >= 0`
- `GegnerStichtagsElo >= 0`
- `Gewinnwahrscheinlichkeit BETWEEN 0 AND 1`
- `VorschauElo >= 0`

## 16. Funktion

### PRIMARY KEY

- `FunktionID`

### UNIQUE

- `Bezeichnung`

### CHECK

- `Aktiv IN (0,1)`

## 17. Vereinsfunktionaer

### PRIMARY KEY

- `FunktionaerID`

### FOREIGN KEY

- `VereinsNr` → `Club.VereinsNr`

### CHECK

- `Aktiv IN (0,1)`

## 18. FunktionaerFunktion

### PRIMARY KEY

Zusammengesetzter Primärschlüssel:

- `FunktionaerID`
- `FunktionID`
- `GueltigAb`

### FOREIGN KEY

- `FunktionaerID` → `Vereinsfunktionaer.FunktionaerID`
- `FunktionID` → `Funktion.FunktionID`

### CHECK

- `GueltigBis IS NULL OR GueltigBis >= GueltigAb`

## 19. Benutzer

### PRIMARY KEY

- `BenutzerID`

### FOREIGN KEY

- `LizenzNr` → `Spieler.LizenzNr`
- `VereinsNr` → `Club.VereinsNr`
- `VerbandID` → `Verband.VerbandID`

### UNIQUE

- `Benutzername`

### CHECK

- `Rolle IN ('CAPTAIN', 'VEREIN', 'KLASSENLEITER', 'ADMIN')`
- `Aktiv IN (0,1)`

### Besonderheit

Je nach Rolle gelten zusätzliche fachliche Regeln:

- `CAPTAIN` sollte eine `LizenzNr` besitzen.
- `VEREIN` sollte eine `VereinsNr` besitzen.
- `KLASSENLEITER` kann eine `VerbandID` besitzen.
- `ADMIN` benötigt keine dieser Zuordnungen.

Diese rollenabhängigen Regeln werden später über Stored Procedures oder zusätzliche CHECK-Constraints abgesichert.

## 19. Benutzer

### PRIMARY KEY

- `BenutzerID`

### FOREIGN KEY

- `LizenzNr` → `Spieler.LizenzNr`
- `VereinsNr` → `Club.VereinsNr`
- `VerbandID` → `Verband.VerbandID`

### UNIQUE

- `Benutzername`

### CHECK

- `Rolle IN ('CAPTAIN', 'VEREIN', 'KLASSENLEITER', 'ADMIN')`
- `Aktiv IN (0,1)`

### Besonderheit

Je nach Rolle gelten zusätzliche fachliche Regeln:

- `CAPTAIN` sollte eine `LizenzNr` besitzen.
- `VEREIN` sollte eine `VereinsNr` besitzen.
- `KLASSENLEITER` kann eine `VerbandID` besitzen.
- `ADMIN` benötigt keine dieser Zuordnungen.

Diese rollenabhängigen Regeln werden später über Stored Procedures oder zusätzliche CHECK-Constraints abgesichert.

## 20. BenutzerMannschaft

### PRIMARY KEY

Zusammengesetzter Primärschlüssel:

- `BenutzerID`
- `MannschaftID`

### FOREIGN KEY

- `BenutzerID` → `Benutzer.BenutzerID`
- `MannschaftID` → `Mannschaft.MannschaftID`

### Besonderheit

Der zugeordnete Benutzer sollte die Rolle `CAPTAIN` besitzen.

Diese Regel wird später über eine Stored Procedure geprüft.

## 21. Ball

### PRIMARY KEY

- `BallID`

### UNIQUE

- Kombination aus `Marke`, `Modell`, `Farbe`

### CHECK

- `Aktiv IN (0,1)`

## 22. Spielsystem

### PRIMARY KEY

- `SpielsystemID`

### UNIQUE

- `Bezeichnung`

### CHECK

- `AnzahlSpieler > 0`
- `AnzahlEinzel >= 0`
- `AnzahlDoppel >= 0`
- `MaxAnzahlSpiele > 0`
- `MaxAnzahlSpiele = AnzahlEinzel + AnzahlDoppel`
- `Aktiv IN (0,1)`

## 23. Ligawettbewerb

### PRIMARY KEY

- `LigawettbewerbID`

### FOREIGN KEY

- `SaisonID` → `Saison.SaisonID`
- `VerbandID` → `Verband.VerbandID`
- `Alterskategorie` → `Alterskategorie.Bezeichnung`
- `SpielsystemID` → `Spielsystem.SpielsystemID`

### UNIQUE

Sinnvoll:

- Kombination aus `SaisonID`, `VerbandID`, `Bezeichnung`, `Geschlechtskategorie`, `Alterskategorie`

### CHECK

- `Geschlechtskategorie IN ('HERREN', 'DAMEN')`
- `Aktiv IN (0,1)`

### Besonderheit

- `Alterskategorie = NULL` bedeutet keine spezielle Altersbeschränkung.
- Altersberechtigungen wie U13, O40 oder Aktive werden später über Fachlogik geprüft.

## 24. Ligaphase

### PRIMARY KEY

- `LigaphaseID`

### FOREIGN KEY

- `LigawettbewerbID` → `Ligawettbewerb.LigawettbewerbID`
- `KlassenleiterBenutzerID` → `Benutzer.BenutzerID`

### UNIQUE

Sinnvoll:

- Kombination aus `LigawettbewerbID`, `Bezeichnung`

### CHECK

- `Phasentyp IN ('HAUPTRUNDE', 'VORRUNDE', 'FINALRUNDE')`
- `Aktiv IN (0,1)`

### Besonderheit

Ein `KlassenleiterBenutzerID` sollte auf einen Benutzer mit Rolle `KLASSENLEITER` oder `ADMIN` zeigen.

Diese Regel wird später über eine Stored Procedure geprüft.

## 25. Mannschaft

### PRIMARY KEY

- `MannschaftID`

### FOREIGN KEY

- `VereinsNr` → `Club.VereinsNr`
- `LigaphaseID` → `Ligaphase.LigaphaseID`
- `KapitaenLizenz` → `Spieler.LizenzNr`
- `BallID` → `Ball.BallID`

### UNIQUE

- Kombination aus `LigaphaseID`, `VereinsNr`, `MannschaftNummer`

### CHECK

- `MannschaftNummer > 0`
- `Aktiv IN (0,1)`

### Besonderheit

- Der Captain muss eine gültige Lizenz besitzen.
- Der Captain sollte für diese Mannschaft spielberechtigt sein.
- Diese fachliche Prüfung wird später über eine Stored Procedure umgesetzt.

## 26. MannschaftSpieler

### PRIMARY KEY

- `MannschaftSpielerID`

### FOREIGN KEY

- `MannschaftID` → `Mannschaft.MannschaftID`
- `LizenzNr` → `Spieler.LizenzNr`

### UNIQUE

- Kombination aus `MannschaftID`, `LizenzNr`

### CHECK

- `Meldungsart IN ('STAMMSPIELER', 'ERSATZSPIELER')`
- `StammPosition IS NULL OR StammPosition BETWEEN 1 AND 3`
- `Spielberechtigt IN (0,1)`

### Besonderheit

- `STAMMSPIELER` sollte eine Stammposition 1 bis 3 besitzen.
- `ERSATZSPIELER` sollte normalerweise `StammPosition = NULL` haben.
- Ein Ersatzspieler wird nach dem dritten Einsatz Stammspieler.
- Die Einsatzanzahl wird aus den tatsächlichen Begegnungen berechnet.

## 27. Begegnung

### PRIMARY KEY

- `BegegnungID`

### FOREIGN KEY

- `LigaphaseID` → `Ligaphase.LigaphaseID`
- `HeimMannschaftID` → `Mannschaft.MannschaftID`
- `GastMannschaftID` → `Mannschaft.MannschaftID`
- `SpielortID` → `Spielort.SpielortID`
- `GenehmigtVon` → `Benutzer.BenutzerID`

### CHECK

- `HeimMannschaftID <> GastMannschaftID`
- `Runde IS NULL OR Runde > 0`
- `Endzeit IS NULL OR Endzeit >= Startzeit`
- `SiegeHeim IS NULL OR SiegeHeim BETWEEN 0 AND 10`
- `SiegeGast IS NULL OR SiegeGast BETWEEN 0 AND 10`
- `MannschaftspunkteHeim IS NULL OR MannschaftspunkteHeim BETWEEN 0 AND 4`
- `MannschaftspunkteGast IS NULL OR MannschaftspunkteGast BETWEEN 0 AND 4`
- `SaetzeHeim IS NULL OR SaetzeHeim >= 0`
- `SaetzeGast IS NULL OR SaetzeGast >= 0`
- `BaelleHeim IS NULL OR BaelleHeim >= 0`
- `BaelleGast IS NULL OR BaelleGast >= 0`
- `ZuschauerAnzahl IS NULL OR ZuschauerAnzahl >= 0`
- `MatchblattGenehmigt IN (0,1)`
- `Status IN ('GEPLANT', 'LAUFEND', 'ABGESCHLOSSEN', 'GENEHMIGT', 'ANNULLIERT')`

### Besonderheiten

- Beide Mannschaften müssen zur gleichen Ligaphase gehören.
- Die Mannschaftspunktelogik wird über eine Funktion oder Stored Procedure berechnet.
- Bei Status `GENEHMIGT` sollten `MatchblattGenehmigt = 1`, `GenehmigtAm` und `GenehmigtVon` gesetzt sein.
- Captain und Verein dürfen genehmigte Begegnungen nicht mehr ändern.

## 28. Begegnungsaufstellung

### PRIMARY KEY

- `BegegnungsaufstellungID`

### FOREIGN KEY

- `BegegnungID` → `Begegnung.BegegnungID`
- `MannschaftID` → `Mannschaft.MannschaftID`
- `LizenzNr` → `Spieler.LizenzNr`

### UNIQUE

- Kombination aus `BegegnungID`, `Position`
- Kombination aus `BegegnungID`, `LizenzNr`

### CHECK

- `Seite IN ('HEIM', 'GAST')`
- `Position IN ('A', 'B', 'C', 'X', 'Y', 'Z')`
- Bei `Seite = 'HEIM'` muss `Position IN ('A','B','C')` sein.
- Bei `Seite = 'GAST'` muss `Position IN ('X','Y','Z')` sein.

### Besonderheit

- Wenn eine Position nicht besetzt ist, wird kein Aufstellungsdatensatz angelegt.
- Die daraus entstehenden Einzelspiele werden als Forfait mit `NULL`-Lizenz gespeichert.

## 29. Begegnungsbemerkung

### PRIMARY KEY

- `BegegnungsbemerkungID`

### FOREIGN KEY

- `BegegnungID` → `Begegnung.BegegnungID`
- `BenutzerID` → `Benutzer.BenutzerID`

### CHECK

- `Bemerkungsart IN ('VEREIN', 'KLASSENLEITER', 'ADMIN')`

## 30. BegegnungAenderung

### PRIMARY KEY

- `BegegnungAenderungID`

### FOREIGN KEY

- `BegegnungID` → `Begegnung.BegegnungID`
- `BenutzerID` → `Benutzer.BenutzerID`

### CHECK

- `LEN(LTRIM(RTRIM(Grund))) > 0`

### Besonderheit

- Ein Eintrag wird nur bei Änderungen einer genehmigten Begegnung erzeugt.
- Nur Benutzer mit Rolle `KLASSENLEITER` oder `ADMIN` dürfen solche Änderungen durchführen.

## 31. Turnier

### PRIMARY KEY

- `TurnierID`

### FOREIGN KEY

- `SaisonID` → `Saison.SaisonID`
- `BewertungsperiodeID` → `Bewertungsperiode.BewertungsperiodeID`
- `VeranstalterNr` → `Club.VereinsNr`
- `SpielortID` → `Spielort.SpielortID`

### CHECK

- `Enddatum IS NULL OR Enddatum >= Startdatum`
- `Meldeschluss <= Startdatum`
- `Status IN ('GEPLANT', 'OFFEN', 'AUSGELOST', 'LAUFEND', 'BEENDET', 'ABGESAGT')`

### Besonderheiten

- Die Bewertungsperiode muss zur Saison des Turniers gehören.
- Der Spielort sollte zum veranstaltenden Club gehören.
- Diese fachlichen Regeln werden später über Stored Procedures geprüft.

## 32. TurnierKategorie

### PRIMARY KEY

- `TurnierKategorieID`

### FOREIGN KEY

- `TurnierID` → `Turnier.TurnierID`
- `Alterskategorie` → `Alterskategorie.Bezeichnung`
- `MinStufenwert` → `Klassierungsstufe.Stufenwert`
- `MaxStufenwert` → `Klassierungsstufe.Stufenwert`

### UNIQUE

Sinnvoll:

- Kombination aus `TurnierID` und `Bezeichnung`

### CHECK

- `Kategorieart IN ('ALTER', 'KLASSIERUNG', 'ELO', 'OFFEN', 'KOMBINIERT')`
- `Wettkampfform IN ('EINZEL', 'DOPPEL', 'MANNSCHAFT')`
- `Geschlechtskategorie IN ('HERREN', 'DAMEN', 'MIXED', 'OFFEN')`
- `VerwendeteKlassierungsart IS NULL OR VerwendeteKlassierungsart IN ('HERREN', 'DAMEN')`
- `Altersregel IN ('ALLE', 'BIS_MAXALTER', 'AB_MINALTER', 'EXAKT')`
- `BevorzugePassendeKategorie IN (0,1)`
- `AlleSpielerMuessenKlassierungErfuellen IN (0,1)`
- `AlleSpielerMuessenEloErfuellen IN (0,1)`
- `MinStufenwert IS NULL OR MaxStufenwert IS NULL OR MinStufenwert <= MaxStufenwert`
- `MinEloWert IS NULL OR TopEloWert IS NULL OR MinEloWert <= TopEloWert`
- `MinKlassierungSumme IS NULL OR MaxKlassierungSumme IS NULL OR MinKlassierungSumme <= MaxKlassierungSumme`
- `MinEloSumme IS NULL OR MaxEloSumme IS NULL OR MinEloSumme <= MaxEloSumme`
- `SpielerProTeam IS NULL OR SpielerProTeam > 0`
- `Gewinnsaetze IN (3,4)`
- `Status IN ('GEPLANT', 'OFFEN', 'AUSGELOST', 'LAUFEND', 'BEENDET', 'ABGESAGT')`

### Besonderheiten

- Nicht jede Kategorie verwendet alle Kriterien.
- Bei `EINZEL` sollte `SpielerProTeam = NULL` sein.
- Bei `MANNSCHAFT` muss `SpielerProTeam` gesetzt sein.
- Alters-, Elo- und Klassierungsregeln werden über Stored Procedures geprüft.

## 33. Einzelanmeldung

### PRIMARY KEY

- `EinzelanmeldungID`

### FOREIGN KEY

- `TurnierKategorieID` → `TurnierKategorie.TurnierKategorieID`
- `LizenzNr` → `Spieler.LizenzNr`

### UNIQUE

- Kombination aus `TurnierKategorieID` und `LizenzNr`

### CHECK

- `Status IN ('ANGEMELDET', 'BESTAETIGT', 'ABGELEHNT', 'ZURUECKGEZOGEN')`

### Besonderheit

- Die zugehörige Turnierkategorie muss `Wettkampfform = 'EINZEL'` besitzen.
- Die fachliche Zulassung wird über `SpielerBewertung` geprüft.

## 34. Doppelanmeldung

### PRIMARY KEY

- `DoppelanmeldungID`

### FOREIGN KEY

- `TurnierKategorieID` → `TurnierKategorie.TurnierKategorieID`
- `Spieler1Lizenz` → `Spieler.LizenzNr`
- `Spieler2Lizenz` → `Spieler.LizenzNr`

### CHECK

- `Spieler1Lizenz <> Spieler2Lizenz`
- `Status IN ('ANGEMELDET', 'BESTAETIGT', 'ABGELEHNT', 'ZURUECKGEZOGEN')`

### Besonderheiten

- Die Kategorie muss `Wettkampfform = 'DOPPEL'` besitzen.
- Eine Paarung darf innerhalb derselben Kategorie nicht doppelt vorkommen.
- Die Reihenfolge der beiden Spieler darf dabei keine Rolle spielen.
- Diese Dublettenprüfung wird später über eine Stored Procedure oder einen normierten Pair-Key umgesetzt.

## 35. Turniermannschaft

### PRIMARY KEY

- `TurniermannschaftID`

### FOREIGN KEY

- `TurnierKategorieID` → `TurnierKategorie.TurnierKategorieID`

### UNIQUE

Sinnvoll:

- Kombination aus `TurnierKategorieID` und `Name`

### CHECK

- `Status IN ('ANGEMELDET', 'BESTAETIGT', 'ABGELEHNT', 'ZURUECKGEZOGEN')`

### Besonderheit

- Die Kategorie muss `Wettkampfform = 'MANNSCHAFT'` besitzen.

## 36. TurniermannschaftSpieler

### PRIMARY KEY

Zusammengesetzter Primärschlüssel:

- `TurniermannschaftID`
- `LizenzNr`

### FOREIGN KEY

- `TurniermannschaftID` → `Turniermannschaft.TurniermannschaftID`
- `LizenzNr` → `Spieler.LizenzNr`

### CHECK

- `Position IS NULL OR Position > 0`
- `IstCaptain IN (0,1)`

### Besonderheiten

- Ein Spieler darf innerhalb derselben Turniermannschaft nur einmal vorkommen.
- Pro Turniermannschaft sollte höchstens ein Captain existieren.
- Die maximale Spieleranzahl richtet sich nach `TurnierKategorie.SpielerProTeam`.

## 37. Einzelspiel

### PRIMARY KEY

- `EinzelspielID`

### FOREIGN KEY

- `BegegnungID` → `Begegnung.BegegnungID`
- `TurnierKategorieID` → `TurnierKategorie.TurnierKategorieID`
- `Spieler1Lizenz` → `Spieler.LizenzNr`
- `Spieler2Lizenz` → `Spieler.LizenzNr`
- `GewinnerLizenz` → `Spieler.LizenzNr`

### CHECK

- Genau eine Herkunft muss gesetzt sein:
  - `BegegnungID IS NOT NULL AND TurnierKategorieID IS NULL`
  - oder `BegegnungID IS NULL AND TurnierKategorieID IS NOT NULL`
- `Spieler1Lizenz IS NULL OR Spieler2Lizenz IS NULL OR Spieler1Lizenz <> Spieler2Lizenz`
- `SaetzeSpieler1 >= 0`
- `SaetzeSpieler2 >= 0`
- `PunkteSpieler1 IN (0,1)`
- `PunkteSpieler2 IN (0,1)`
- `Spielgrund IN ('REGULAER', 'AUFGABE', 'FORFAIT', 'NICHTANGETRETEN', 'ANNULLIERT')`
- `Status IN ('GEPLANT', 'LAUFEND', 'ABGESCHLOSSEN', 'ANNULLIERT')`

### Besonderheiten

- Bei `REGULAER` müssen beide Spieler gesetzt sein.
- Bei `FORFAIT` darf eine Spieler-Lizenz NULL sein.
- Bei `AUFGABE` bleiben beide Spieler gesetzt.
- `GewinnerLizenz` muss einem der beteiligten Spieler entsprechen.
- Nur `REGULAER` und `AUFGABE` sind Elo-relevant.

## 38. Doppelspiel

### PRIMARY KEY

- `DoppelspielID`

### FOREIGN KEY

- `BegegnungID` → `Begegnung.BegegnungID`
- `TurnierKategorieID` → `TurnierKategorie.TurnierKategorieID`
- `Seite1Spieler1Lizenz` → `Spieler.LizenzNr`
- `Seite1Spieler2Lizenz` → `Spieler.LizenzNr`
- `Seite2Spieler1Lizenz` → `Spieler.LizenzNr`
- `Seite2Spieler2Lizenz` → `Spieler.LizenzNr`

### CHECK

- Genau eine Herkunft muss gesetzt sein.
- `Gewinnerseite IS NULL OR Gewinnerseite IN (1,2)`
- `SaetzeSeite1 >= 0`
- `SaetzeSeite2 >= 0`
- `PunkteSeite1 IN (0,1)`
- `PunkteSeite2 IN (0,1)`
- `Spielgrund IN ('REGULAER', 'AUFGABE', 'FORFAIT', 'NICHTANGETRETEN', 'ANNULLIERT')`
- `Status IN ('GEPLANT', 'LAUFEND', 'ABGESCHLOSSEN', 'ANNULLIERT')`

### Besonderheiten

- Bei `REGULAER` müssen alle vier Spieler gesetzt sein.
- Bei `REGULAER` müssen alle vier Spieler verschieden sein.
- Bei `FORFAIT` dürfen Spieler-Lizenzen NULL sein.
- Doppelspiele sind nie Elo-relevant.

## 39. Satz

### PRIMARY KEY

- `SatzID`

### FOREIGN KEY

- `EinzelspielID` → `Einzelspiel.EinzelspielID`
- `DoppelspielID` → `Doppelspiel.DoppelspielID`

### CHECK

- Genau eine Herkunft muss gesetzt sein:
  - Einzelspiel
  - oder Doppelspiel
- `SatzNummer BETWEEN 1 AND 7`
- `PunkteSeite1 >= 0`
- `PunkteSeite2 >= 0`
- `PunkteSeite1 <> PunkteSeite2`

### UNIQUE

Da SQL Server mit zwei nullable Fremdschlüsseln arbeitet, brauchen wir später zwei gefilterte UNIQUE-Indizes:

- `(EinzelspielID, SatzNummer)` für Einzelspiele
- `(DoppelspielID, SatzNummer)` für Doppelspiele

### Besonderheiten

- Bei Ligaspielen gibt es maximal fünf Sätze.
- Bei Turnieren mit vier Gewinnsätzen sind maximal sieben Sätze erlaubt.
- Bei Forfait werden keine künstlichen Satzdatensätze angelegt.