# Constraints

## 1. Zweck

Dieses Dokument beschreibt die im finalen SQL-Schema tatsächlich implementierten Integritätsregeln der STT-Datenbank.

Berücksichtigt werden:

- `PRIMARY KEY`
- `FOREIGN KEY`
- `UNIQUE`
- `CHECK`
- gefilterte `UNIQUE INDEX`-Regeln
- relevante `DEFAULT`-Constraints

Die technische Referenz sind die finalen `CREATE TABLE`-Skripte im Ordner `sql/tables`.

---

## 2. Saison

### PRIMARY KEY

- `SaisonID`

### UNIQUE

- `Bezeichnung`

### CHECK

- `Enddatum > Startdatum`

### DEFAULT

- `IstAktuell = 0`

### Gefilterter UNIQUE-Index

- `UX_Saison_IstAktuell`
- Spalte: `IstAktuell`
- Filter: `IstAktuell = 1`

Dadurch kann höchstens eine Saison gleichzeitig als aktuell markiert sein.

---

## 3. Verband

### PRIMARY KEY

- `VerbandID`

### FOREIGN KEY

- `UebergeordneterVerbandID` → `Verband.VerbandID`

### UNIQUE

- `Kurzname`

### CHECK

- `Verbandstyp IN ('NATIONAL', 'REGIONAL')`
- `NATIONAL` verlangt `UebergeordneterVerbandID IS NULL`
- `REGIONAL` verlangt `UebergeordneterVerbandID IS NOT NULL`

### DEFAULT

- `Aktiv = 1`

---

## 4. Alterskategorie

### PRIMARY KEY

- `Bezeichnung`

### CHECK

- `MinAlter >= 0`
- `MaxAlter IS NULL OR MaxAlter >= MinAlter`

---

## 5. Klassierungsstufe

### PRIMARY KEY

- `Stufenwert`

### UNIQUE

- `Bezeichnung`

### CHECK

- `Stufenwert BETWEEN 1 AND 22`

---

## 6. Club

### PRIMARY KEY

- `VereinsNr`

### FOREIGN KEY

- `RegionalverbandID` → `Verband.VerbandID`

### CHECK

- `Gruendungsjahr IS NULL OR Gruendungsjahr > 0`
- `LEN(Landcode) = 2`

### DEFAULT

- `Landcode = 'CH'`
- `Aktiv = 1`

---

## 7. Spielort

### PRIMARY KEY

- `SpielortID`

### FOREIGN KEY

- `VereinsNr` → `Club.VereinsNr`

### UNIQUE

- Kombination aus `VereinsNr` und `Bezeichnung`

### DEFAULT

- `Landcode = 'CH'`
- `IstHauptspielort = 0`
- `Aktiv = 1`

### Gefilterter UNIQUE-Index

- `UX_Spielort_AktiverHauptspielort`
- Schlüssel: `VereinsNr`
- Filter: `IstHauptspielort = 1 AND Aktiv = 1`

Dadurch kann ein Club höchstens einen aktiven Hauptspielort besitzen.

---

## 8. Spieler

### PRIMARY KEY

- `LizenzNr`

### CHECK

- `Geschlecht IN ('M', 'W')`

### DEFAULT

- `Aktiv = 1`

---

## 9. SpielerSaison

### PRIMARY KEY

Zusammengesetzt aus:

- `LizenzNr`
- `SaisonID`

### FOREIGN KEY

- `LizenzNr` → `Spieler.LizenzNr`
- `SaisonID` → `Saison.SaisonID`
- `Alterskategorie` → `Alterskategorie.Bezeichnung`

### DEFAULT

- `LizenzAktiv = 1`

---

## 10. SpielerVerein

### PRIMARY KEY

- `SpielerVereinID`

### FOREIGN KEY

- `LizenzNr` → `Spieler.LizenzNr`
- `SaisonID` → `Saison.SaisonID`
- `VereinsNr` → `Club.VereinsNr`

### UNIQUE

Kombination aus:

- `LizenzNr`
- `SaisonID`
- `VereinsNr`
- `Zuordnungsart`
- `Wettbewerbsbereich`

### CHECK

- `Zuordnungsart IN ('HAUPTVEREIN', 'MEHRFACHLIZENZ')`
- `Wettbewerbsbereich IN ('ALLE', 'HERREN', 'DAMEN', 'NACHWUCHS', 'SENIOREN')`

### Gefilterter UNIQUE-Index

- `UX_SpielerVerein_Hauptverein`
- Schlüssel: `LizenzNr`, `SaisonID`
- Filter: `Zuordnungsart = 'HAUPTVEREIN'`

Damit kann ein Spieler innerhalb einer Saison höchstens einen Hauptverein besitzen.

---

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

---

## 12. Klassierungsgrenze

### PRIMARY KEY

- `KlassierungsgrenzeID`

### FOREIGN KEY

- `BewertungsperiodeID` → `Bewertungsperiode.BewertungsperiodeID`
- `Stufenwert` → `Klassierungsstufe.Stufenwert`

### UNIQUE

Kombination aus:

- `BewertungsperiodeID`
- `Stufenwert`
- `Klassierungsart`

### CHECK

- `Klassierungsart IN ('HERREN', 'DAMEN')`
- `MinElo IS NULL OR MaxElo IS NULL OR MinElo <= MaxElo`
- `MittelElo IS NULL OR MinElo IS NULL OR MittelElo >= MinElo`
- `MittelElo IS NULL OR MaxElo IS NULL OR MittelElo <= MaxElo`

Hinweis: Eine vollständige Prüfung auf sich überschneidende Elo-Bereiche zwischen verschiedenen Datensätzen wird durch diese Tabellen-Constraints nicht erzwungen.

---

## 13. SpielerBewertung

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

### DEFAULT

- `ErstelltAm = SYSDATETIME()`

---

## 14. EloMonatslauf

### PRIMARY KEY

- `EloMonatslaufID`

### UNIQUE

- `Berechnungsdatum`

### CHECK

- `PeriodeBis >= PeriodeVon`
- `Status IN ('GEPLANT', 'LAUFEND', 'ABGESCHLOSSEN', 'FEHLER')`
- `AbgeschlossenAm IS NULL OR GestartetAm IS NULL OR AbgeschlossenAm >= GestartetAm`

---

## 15. SpielerElo

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

---

## 16. EloProtokoll

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

### DEFAULT

- `ErstelltAm = SYSDATETIME()`

---

## 17. Funktion

### PRIMARY KEY

- `FunktionID`

### UNIQUE

- `Bezeichnung`

### DEFAULT

- `Aktiv = 1`

---

## 18. Vereinsfunktionaer

### PRIMARY KEY

- `FunktionaerID`

### FOREIGN KEY

- `VereinsNr` → `Club.VereinsNr`

### DEFAULT

- `Aktiv = 1`

---

## 19. FunktionaerFunktion

### PRIMARY KEY

Zusammengesetzt aus:

- `FunktionaerID`
- `FunktionID`
- `GueltigAb`

### FOREIGN KEY

- `FunktionaerID` → `Vereinsfunktionaer.FunktionaerID`
- `FunktionID` → `Funktion.FunktionID`

### CHECK

- `GueltigBis IS NULL OR GueltigBis >= GueltigAb`

---

## 20. Benutzer

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

### DEFAULT

- `Aktiv = 1`

Hinweis: Rollenabhängige Anforderungen wie „CAPTAIN benötigt eine Lizenznummer“ werden nicht vollständig durch einen CHECK-Constraint erzwungen.

---

## 21. Ball

### PRIMARY KEY

- `BallID`

### UNIQUE

Kombination aus:

- `Marke`
- `Modell`
- `Farbe`

### DEFAULT

- `Aktiv = 1`

---

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

### DEFAULT

- `Aktiv = 1`

---

## 23. Ligawettbewerb

### PRIMARY KEY

- `LigawettbewerbID`

### FOREIGN KEY

- `SaisonID` → `Saison.SaisonID`
- `VerbandID` → `Verband.VerbandID`
- `Alterskategorie` → `Alterskategorie.Bezeichnung`
- `SpielsystemID` → `Spielsystem.SpielsystemID`

### UNIQUE

Kombination aus:

- `SaisonID`
- `VerbandID`
- `Bezeichnung`
- `Geschlechtskategorie`
- `Alterskategorie`

### CHECK

- `Geschlechtskategorie IN ('HERREN', 'DAMEN')`

### DEFAULT

- `Aktiv = 1`

Hinweis: Da `Alterskategorie` nullable ist, ist die SQL-Server-NULL-Semantik bei der Eindeutigkeitsregel zu berücksichtigen.

---

## 24. Ligaphase

### PRIMARY KEY

- `LigaphaseID`

### FOREIGN KEY

- `LigawettbewerbID` → `Ligawettbewerb.LigawettbewerbID`
- `KlassenleiterBenutzerID` → `Benutzer.BenutzerID`

### UNIQUE

- Kombination aus `LigawettbewerbID` und `Bezeichnung`

### CHECK

- `Phasentyp IN ('HAUPTRUNDE', 'VORRUNDE', 'FINALRUNDE')`

### DEFAULT

- `Aktiv = 1`

---

## 25. Mannschaft

### PRIMARY KEY

- `MannschaftID`

### FOREIGN KEY

- `VereinsNr` → `Club.VereinsNr`
- `LigaphaseID` → `Ligaphase.LigaphaseID`
- `KapitaenLizenz` → `Spieler.LizenzNr`
- `BallID` → `Ball.BallID`

### UNIQUE

Kombination aus:

- `LigaphaseID`
- `VereinsNr`
- `MannschaftNummer`

### CHECK

- `MannschaftNummer > 0`

### DEFAULT

- `Aktiv = 1`

---

## 26. MannschaftSpieler

### PRIMARY KEY

- `MannschaftSpielerID`

### FOREIGN KEY

- `MannschaftID` → `Mannschaft.MannschaftID`
- `LizenzNr` → `Spieler.LizenzNr`

### UNIQUE

- Kombination aus `MannschaftID` und `LizenzNr`

### CHECK

- `Meldungsart IN ('STAMMSPIELER', 'ERSATZSPIELER')`
- `StammPosition IS NULL OR StammPosition BETWEEN 1 AND 3`
- `STAMMSPIELER` verlangt `StammPosition BETWEEN 1 AND 3`
- `ERSATZSPIELER` verlangt `StammPosition IS NULL`

### DEFAULT

- `Spielberechtigt = 1`

---

## 27. BenutzerMannschaft

### PRIMARY KEY

Zusammengesetzt aus:

- `BenutzerID`
- `MannschaftID`

### FOREIGN KEY

- `BenutzerID` → `Benutzer.BenutzerID`
- `MannschaftID` → `Mannschaft.MannschaftID`

Die Tabelle selbst erzwingt nicht, dass der Benutzer tatsächlich die Rolle `CAPTAIN` besitzt.

---

## 28. Begegnung

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
- `Status IN ('GEPLANT', 'LAUFEND', 'ABGESCHLOSSEN', 'GENEHMIGT', 'ANNULLIERT')`

### Genehmigungsregel

Wenn `Status = 'GENEHMIGT'`, müssen gleichzeitig gelten:

- `MatchblattGenehmigt = 1`
- `GenehmigtAm IS NOT NULL`
- `GenehmigtVon IS NOT NULL`

Wenn der Status nicht `GENEHMIGT` ist, darf `MatchblattGenehmigt = 0` sein oder bereits auf `1` stehen, sofern Genehmigungszeitpunkt und Benutzer vorhanden sind.

### DEFAULT

- `MatchblattGenehmigt = 0`

---

## 29. Begegnungsaufstellung

### PRIMARY KEY

- `BegegnungsaufstellungID`

### FOREIGN KEY

- `BegegnungID` → `Begegnung.BegegnungID`
- `MannschaftID` → `Mannschaft.MannschaftID`
- `LizenzNr` → `Spieler.LizenzNr`

### UNIQUE

- Kombination aus `BegegnungID` und `Position`
- Kombination aus `BegegnungID` und `LizenzNr`

### CHECK

- `Seite IN ('HEIM', 'GAST')`
- `Position IN ('A', 'B', 'C', 'X', 'Y', 'Z')`
- `HEIM` erlaubt nur `A`, `B`, `C`
- `GAST` erlaubt nur `X`, `Y`, `Z`

---

## 30. Begegnungsbemerkung

### PRIMARY KEY

- `BegegnungsbemerkungID`

### FOREIGN KEY

- `BegegnungID` → `Begegnung.BegegnungID`
- `BenutzerID` → `Benutzer.BenutzerID`

### CHECK

- `Bemerkungsart IN ('VEREIN', 'KLASSENLEITER', 'ADMIN')`

### DEFAULT

- `ErstelltAm = SYSDATETIME()`

---

## 31. BegegnungAenderung

### PRIMARY KEY

- `BegegnungAenderungID`

### FOREIGN KEY

- `BegegnungID` → `Begegnung.BegegnungID`
- `BenutzerID` → `Benutzer.BenutzerID`

### CHECK

- `LEN(LTRIM(RTRIM(Grund))) > 0`

### DEFAULT

- `Aenderungsdatum = SYSDATETIME()`

---

## 32. Turnier

### PRIMARY KEY

- `TurnierID`

### FOREIGN KEY

- `SaisonID` → `Saison.SaisonID`
- `BewertungsperiodeID` → `Bewertungsperiode.BewertungsperiodeID`
- `VeranstalterNr` → `Club.VereinsNr`
- `SpielortID` → `Spielort.SpielortID`

### CHECK

- `Enddatum IS NULL OR Enddatum >= Startdatum`
- `Meldeschluss <= CAST(Startdatum AS DATETIME2(0))`
- `Status IN ('GEPLANT', 'OFFEN', 'AUSGELOST', 'LAUFEND', 'BEENDET', 'ABGESAGT')`

Die Tabelle selbst erzwingt nicht, dass Bewertungsperiode und Saison fachlich zusammenpassen oder dass der Spielort zum Veranstalter gehört.

---

## 33. TurnierKategorie

### PRIMARY KEY

- `TurnierKategorieID`

### FOREIGN KEY

- `TurnierID` → `Turnier.TurnierID`
- `Alterskategorie` → `Alterskategorie.Bezeichnung`
- `MinStufenwert` → `Klassierungsstufe.Stufenwert`
- `MaxStufenwert` → `Klassierungsstufe.Stufenwert`

### UNIQUE

- Kombination aus `TurnierID` und `Bezeichnung`

### CHECK

- `Kategorieart IN ('ALTER', 'KLASSIERUNG', 'ELO', 'OFFEN', 'KOMBINIERT')`
- `Wettkampfform IN ('EINZEL', 'DOPPEL', 'MANNSCHAFT')`
- `Geschlechtskategorie IN ('HERREN', 'DAMEN', 'MIXED', 'OFFEN')`
- `VerwendeteKlassierungsart IS NULL OR VerwendeteKlassierungsart IN ('HERREN', 'DAMEN')`
- `Altersregel IN ('ALLE', 'BIS_MAXALTER', 'AB_MINALTER', 'EXAKT')`
- `MinStufenwert IS NULL OR MaxStufenwert IS NULL OR MinStufenwert <= MaxStufenwert`
- `MinEloWert IS NULL OR TopEloWert IS NULL OR MinEloWert <= TopEloWert`
- `MinKlassierungSumme IS NULL OR MaxKlassierungSumme IS NULL OR MinKlassierungSumme <= MaxKlassierungSumme`
- `MinEloSumme IS NULL OR MaxEloSumme IS NULL OR MinEloSumme <= MaxEloSumme`
- `SpielerProTeam IS NULL OR SpielerProTeam > 0`
- `Gewinnsaetze IN (3,4)`
- `Status IN ('GEPLANT', 'OFFEN', 'AUSGELOST', 'LAUFEND', 'BEENDET', 'ABGESAGT')`

### DEFAULT

- `BevorzugePassendeKategorie = 1`
- `AlleSpielerMuessenKlassierungErfuellen = 1`
- `AlleSpielerMuessenEloErfuellen = 1`

Hinweis: Nicht alle fachlichen Kombinationen der Kategorieparameter werden durch CHECK-Constraints erzwungen. Beispielsweise wird nicht allein durch die Tabelle verlangt, dass bei einer Mannschaftskategorie `SpielerProTeam` gesetzt ist.

---

## 34. Einzelanmeldung

### PRIMARY KEY

- `EinzelanmeldungID`

### FOREIGN KEY

- `TurnierKategorieID` → `TurnierKategorie.TurnierKategorieID`
- `LizenzNr` → `Spieler.LizenzNr`

### UNIQUE

- Kombination aus `TurnierKategorieID` und `LizenzNr`

### CHECK

- `Status IN ('ANGEMELDET', 'BESTAETIGT', 'ABGELEHNT', 'ZURUECKGEZOGEN')`

### DEFAULT

- `Anmeldedatum = SYSDATETIME()`
- `Status = 'ANGEMELDET'`

Die Tabellen-Constraints prüfen nicht, ob die referenzierte Kategorie tatsächlich `Wettkampfform = 'EINZEL'` besitzt. Diese Fachlogik wird zusätzlich über die Anwendungs- beziehungsweise Stored-Procedure-Logik abgesichert.

---

## 35. Doppelanmeldung

### PRIMARY KEY

- `DoppelanmeldungID`

### FOREIGN KEY

- `TurnierKategorieID` → `TurnierKategorie.TurnierKategorieID`
- `Spieler1LizenzNr` → `Spieler.LizenzNr`
- `Spieler2LizenzNr` → `Spieler.LizenzNr`

### Berechnete persistierte Spalten

- `SpielerMinLizenz`
- `SpielerMaxLizenz`

Die beiden Spalten normalisieren die Reihenfolge der Lizenznummern.

### CHECK

- `Spieler1LizenzNr <> Spieler2LizenzNr`
- `Status IN ('ANGEMELDET', 'BESTAETIGT', 'ABGELEHNT', 'ZURUECKGEZOGEN')`

### DEFAULT

- `Anmeldedatum = SYSDATETIME()`
- `Status = 'ANGEMELDET'`

### UNIQUE-Index

- `UX_Doppelanmeldung_Paar`
- Schlüssel:
  - `TurnierKategorieID`
  - `SpielerMinLizenz`
  - `SpielerMaxLizenz`

Damit werden auch vertauschte Doppelpaare als identisch behandelt. Beispielsweise gelten `(512038, 512039)` und `(512039, 512038)` als dieselbe Paarung.

---

## 36. Turniermannschaft

### PRIMARY KEY

- `TurniermannschaftID`

### FOREIGN KEY

- `TurnierKategorieID` → `TurnierKategorie.TurnierKategorieID`

### UNIQUE

- Kombination aus `TurnierKategorieID` und `Name`

### CHECK

- `Status IN ('ANGEMELDET', 'BESTAETIGT', 'ABGELEHNT', 'ZURUECKGEZOGEN')`

### DEFAULT

- `Anmeldedatum = SYSDATETIME()`
- `Status = 'ANGEMELDET'`

---

## 37. TurniermannschaftSpieler

### PRIMARY KEY

Zusammengesetzt aus:

- `TurniermannschaftID`
- `LizenzNr`

### FOREIGN KEY

- `TurniermannschaftID` → `Turniermannschaft.TurniermannschaftID`
- `LizenzNr` → `Spieler.LizenzNr`

### CHECK

- `Position IS NULL OR Position > 0`

### DEFAULT

- `IstCaptain = 0`

### Gefilterter UNIQUE-Index für Positionen

- `UX_TurniermannschaftSpieler_Position`
- Schlüssel:
  - `TurniermannschaftID`
  - `Position`
- Filter: `Position IS NOT NULL`

Eine vergebene Position kann innerhalb einer Turniermannschaft nur einmal vorkommen.

### Gefilterter UNIQUE-Index für Captain

- `UX_TurniermannschaftSpieler_Captain`
- Schlüssel: `TurniermannschaftID`
- Filter: `IstCaptain = 1`

Dadurch kann pro Turniermannschaft höchstens ein Captain existieren.

---

## 38. Einzelspiel

### PRIMARY KEY

- `EinzelspielID`

### FOREIGN KEY

- `BegegnungID` → `Begegnung.BegegnungID`
- `TurnierKategorieID` → `TurnierKategorie.TurnierKategorieID`
- `Spieler1Lizenz` → `Spieler.LizenzNr`
- `Spieler2Lizenz` → `Spieler.LizenzNr`
- `GewinnerLizenz` → `Spieler.LizenzNr`

### CHECK

#### Herkunft

Genau eine der beiden Herkünfte muss gesetzt sein:

- `BegegnungID IS NOT NULL AND TurnierKategorieID IS NULL`
- oder `BegegnungID IS NULL AND TurnierKategorieID IS NOT NULL`

#### Spieler

- Spieler 1 und Spieler 2 dürfen nicht identisch sein, sofern beide gesetzt sind.
- Bei `Spielgrund = 'REGULAER'` müssen beide Spieler gesetzt sein.
- `GewinnerLizenz` muss NULL sein oder Spieler 1 beziehungsweise Spieler 2 entsprechen.

#### Resultat

- `SaetzeSpieler1 BETWEEN 0 AND 4`
- `SaetzeSpieler2 BETWEEN 0 AND 4`
- `PunkteSpieler1 IN (0,1)`
- `PunkteSpieler2 IN (0,1)`

#### Spielgrund

- `REGULAER`
- `AUFGABE`
- `FORFAIT`
- `NICHTANGETRETEN`
- `ANNULLIERT`

#### Status

- `GEPLANT`
- `LAUFEND`
- `ABGESCHLOSSEN`
- `ANNULLIERT`

### DEFAULT

- `Spieldatum = SYSDATETIME()`
- `SaetzeSpieler1 = 0`
- `SaetzeSpieler2 = 0`
- `PunkteSpieler1 = 0`
- `PunkteSpieler2 = 0`

---

## 39. Doppelspiel

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

#### Herkunft

Genau eine der beiden Herkünfte muss gesetzt sein:

- Ligabegegnung
- oder Turnierkategorie

#### Gewinner

- `Gewinnerseite IS NULL OR Gewinnerseite IN (1,2)`

#### Resultat

- `SaetzeSeite1 BETWEEN 0 AND 4`
- `SaetzeSeite2 BETWEEN 0 AND 4`
- `PunkteSeite1 IN (0,1)`
- `PunkteSeite2 IN (0,1)`

#### Spielgrund

- `REGULAER`
- `AUFGABE`
- `FORFAIT`
- `NICHTANGETRETEN`
- `ANNULLIERT`

#### Status

- `GEPLANT`
- `LAUFEND`
- `ABGESCHLOSSEN`
- `ANNULLIERT`

#### Reguläre Doppel

Bei `Spielgrund = 'REGULAER'`:

- müssen alle vier Spieler gesetzt sein;
- müssen alle vier Spieler voneinander verschieden sein.

### DEFAULT

- `Spieldatum = SYSDATETIME()`
- `SaetzeSeite1 = 0`
- `SaetzeSeite2 = 0`
- `PunkteSeite1 = 0`
- `PunkteSeite2 = 0`

---

## 40. Satz

### PRIMARY KEY

- `SatzID`

### FOREIGN KEY

- `EinzelspielID` → `Einzelspiel.EinzelspielID`
- `DoppelspielID` → `Doppelspiel.DoppelspielID`

### CHECK

#### Herkunft

Genau eine Herkunft muss gesetzt sein:

- `EinzelspielID IS NOT NULL AND DoppelspielID IS NULL`
- oder `EinzelspielID IS NULL AND DoppelspielID IS NOT NULL`

#### Satznummer

- `SatzNummer BETWEEN 1 AND 7`

#### Punkte

- `PunkteSeite1 >= 0`
- `PunkteSeite2 >= 0`
- `PunkteSeite1 <> PunkteSeite2`

### Gefilterter UNIQUE-Index für Einzelspiele

- `UX_Satz_Einzelspiel_SatzNummer`
- Schlüssel:
  - `EinzelspielID`
  - `SatzNummer`
- Filter: `EinzelspielID IS NOT NULL`

### Gefilterter UNIQUE-Index für Doppelspiele

- `UX_Satz_Doppelspiel_SatzNummer`
- Schlüssel:
  - `DoppelspielID`
  - `SatzNummer`
- Filter: `DoppelspielID IS NOT NULL`

Damit kann eine Satznummer innerhalb eines einzelnen Spiels nur einmal gespeichert werden.

---

## 41. Zusammenfassung

Die Datenintegrität wird auf mehreren Ebenen abgesichert:

- Primärschlüssel identifizieren Datensätze eindeutig.
- Fremdschlüssel verhindern ungültige Referenzen.
- UNIQUE-Regeln verhindern fachliche Dubletten.
- CHECK-Constraints begrenzen Wertebereiche und erlaubte Zustände.
- Gefilterte UNIQUE-Indizes sichern Regeln ab, die mit normalen UNIQUE-Constraints nicht ausreichend abbildbar sind.
- DEFAULT-Constraints liefern definierte Ausgangswerte.
- Zusätzliche Geschäftsregeln werden über Stored Procedures und kontrollierte Abläufe umgesetzt.

Besonders hervorzuheben sind:

- maximal eine aktuelle Saison;
- maximal ein aktiver Hauptspielort pro Club;
- maximal ein Hauptverein pro Spieler und Saison;
- normalisierte Eindeutigkeit von Doppelpaarungen;
- maximal ein Captain pro Turniermannschaft;
- eindeutige Satznummern je Einzel- oder Doppelspiel;
- konsistente Genehmigungsdaten bei Begegnungen;
- exklusive Herkunft von Einzelspielen, Doppelspielen und Sätzen.
