# Geschäftsregeln

## 1. Zweck

Dieses Dokument beschreibt die fachlichen Regeln der STT-Datenbank. Im
Gegensatz zu `Constraints.md` steht hier nicht die technische Umsetzung
einzelner SQL-Constraints im Vordergrund, sondern das fachlich erwartete
Verhalten des Systems.

Die Regeln basieren auf dem final implementierten Datenmodell sowie den
vorgesehenen Abläufen für Spieler, Vereine, Elo und Klassierungen,
Ligabetrieb, Begegnungen und Turniere.

------------------------------------------------------------------------

## 2. Spieler und Saison

### 2.1 Lizenznummer

-   Jeder Spieler wird über seine Lizenznummer eindeutig identifiziert.
-   Die Lizenznummer dient als dauerhafte Identität des Spielers.
-   Eine Lizenznummer darf nicht gleichzeitig mehreren Spielern
    zugeordnet sein.
-   Namensänderungen erzeugen keinen neuen Spieler. Es wird der aktuelle
    Name in den Spieler-Stammdaten geführt.

### 2.2 Saisonabhängige Spielerdaten

-   Ein Spieler kann in mehreren Saisons geführt werden.
-   Die saisonabhängigen Informationen werden getrennt von den
    dauerhaften Spieler-Stammdaten gespeichert.
-   Pro Spieler und Saison existiert höchstens ein
    `SpielerSaison`-Datensatz.
-   Die Alterskategorie eines Spielers wird für die jeweilige Saison
    festgehalten.
-   Der Lizenzstatus kann saisonabhängig aktiv oder inaktiv sein.

### 2.3 Alterskategorie

-   Alterskategorien besitzen ein Mindestalter und optional ein
    Höchstalter.
-   Eine Kategorie ohne Höchstalter kann für die höchste offene
    Altersgruppe verwendet werden.
-   Die Alterskategorie eines Spielers und die Teilnahmeberechtigung an
    einem Wettbewerb sind fachlich getrennte Konzepte.
-   Turnierkategorien können eigene Altersregeln besitzen.

------------------------------------------------------------------------

## 3. Vereine und Verbände

### 3.1 Verbandsstruktur

-   Swiss Table Tennis wird als nationaler Verband geführt.
-   Regionalverbände sind einem übergeordneten Verband zugeordnet.
-   Ein nationaler Verband besitzt keinen übergeordneten Verband.
-   Clubs sind einem Regionalverband zugeordnet.

### 3.2 Spielorte

-   Ein Club kann mehrere Spielorte besitzen.
-   Ein Spielort enthält die für eine Begegnung notwendige Adresse.
-   Pro Club darf höchstens ein aktiver Spielort als Hauptspielort
    gekennzeichnet sein.
-   Weitere aktive Spielorte sind zulässig.

### 3.3 Vereinszugehörigkeit eines Spielers

-   Die Vereinszugehörigkeit wird saisonabhängig gespeichert.
-   Ein Spieler kann pro Saison höchstens einen Hauptverein besitzen.
-   Zusätzlich kann eine Mehrfachlizenz geführt werden.
-   Eine Vereinszuordnung kann auf einen bestimmten Wettbewerbsbereich
    eingeschränkt werden.
-   Unterstützte Bereiche sind `ALLE`, `HERREN`, `DAMEN`, `NACHWUCHS`
    und `SENIOREN`.

------------------------------------------------------------------------

## 4. Klassierung und Elo

### 4.1 Klassierungsstufen

-   Die Klassierung wird über die Stufen D1 bis A22 abgebildet.
-   Technisch werden die Stufen mit den Werten 1 bis 22 gespeichert.
-   Die Klassierungsgrenzen können sich zwischen Bewertungsperioden
    verändern.

### 4.2 Herren- und Damenklassierung

-   Jeder bewertete Spieler besitzt eine Herrenklassierung.
-   Eine Damenklassierung kann zusätzlich geführt werden.
-   Herren- und Damenklassierung basieren auf demselben Elo-Wert.
-   Die Zuordnung eines Elo-Werts zu einer Klassierungsstufe kann für
    Herren und Damen unterschiedlich sein.

### 4.3 Bewertungsperioden

-   Offizielle Spielerbewertungen werden zu definierten
    Bewertungsperioden gespeichert.
-   Im Modell sind `SAISONBEGINN` und `SAISONMITTE` vorgesehen.
-   Eine Bewertungsperiode besitzt einen Stichtag sowie einen
    Gültigkeitszeitraum.
-   Ein Spieler besitzt pro Bewertungsperiode höchstens einen
    offiziellen Bewertungsdatensatz.
-   Turniere referenzieren eine Bewertungsperiode, damit klar ist,
    welcher offizielle Bewertungsstand für die Kategorien verwendet
    wird.

### 4.4 Monatliche Elo-Läufe

-   Die laufende Elo-Entwicklung wird über monatliche Berechnungsläufe
    historisiert.
-   Ein Monatslauf besitzt einen Berechnungszeitraum und einen Status.
-   Mögliche Statuswerte sind `GEPLANT`, `LAUFEND`, `ABGESCHLOSSEN` und
    `FEHLER`.
-   Pro Spieler und Monatslauf wird höchstens ein offizieller Elo-Stand
    gespeichert.
-   Veränderungen zum Vormonat sowie Ranginformationen können zusätzlich
    gespeichert werden.

### 4.5 Elo-relevante Spiele

-   Regulär ausgetragene Einzelspiele sind Elo-relevant.
-   Eine Aufgabe nach Spielbeginn ist ebenfalls Elo-relevant.
-   Forfaitspiele verändern den Elo-Wert nicht.
-   Nicht angetretene Spiele verändern den Elo-Wert nicht.
-   Annullierte Spiele verändern den Elo-Wert nicht.
-   Doppelspiele sind nicht Elo-relevant.

### 4.6 Elo-Protokoll

-   Die Berechnung eines Elo-relevanten Einzelspiels wird
    nachvollziehbar protokolliert.
-   Das Protokoll enthält den Elo-Wert des Spielers vor der Berechnung,
    den Elo-Wert des Gegners, die Gewinnwahrscheinlichkeit und den
    berechneten Vorschau-Elo-Wert.
-   Spieler und Gegner müssen verschieden sein.
-   Für denselben Spieler und dasselbe Einzelspiel darf nicht mehrfach
    dieselbe Elo-Berechnung protokolliert werden.
-   Die Stored Procedure `sp_EloAktualisieren` führt die vorgesehenen
    Prüfungen durch und aktualisiert beziehungsweise erzeugt den
    monatlichen Elo-Stand.

------------------------------------------------------------------------

## 5. Benutzer und Zuständigkeiten

### 5.1 Benutzerrollen

Die Datenbank unterstützt folgende Rollen:

-   `CAPTAIN`
-   `VEREIN`
-   `KLASSENLEITER`
-   `ADMIN`

### 5.2 Captain

-   Ein Captain kann einer oder mehreren Mannschaften zugeordnet werden.
-   Die Zuordnung zwischen Benutzer und Mannschaft wird separat
    gespeichert.
-   Der in einer Mannschaft gespeicherte `KapitaenLizenz` verweist auf
    einen Spieler.
-   Benutzerkonto und Mannschaftskapitän sind damit fachlich verwandte,
    aber technisch getrennte Informationen.

### 5.3 Verein

-   Benutzer mit der Rolle `VEREIN` repräsentieren organisatorische
    Aufgaben eines Clubs.
-   Der Benutzer kann dazu einem Club zugeordnet werden.

### 5.4 Klassenleiter

-   Eine Ligaphase kann einem Klassenleiter zugeordnet werden.
-   Der Klassenleiter ist insbesondere für die organisatorische
    Kontrolle des Ligabetriebs relevant.

### 5.5 Administrator

-   Administratoren besitzen übergeordnete Verwaltungsaufgaben.
-   Administrative Bemerkungen und Änderungen können einem Benutzer
    zugeordnet und damit nachvollzogen werden.

------------------------------------------------------------------------

## 6. Mannschaften und Spielermeldung

### 6.1 Ligamannschaft

-   Eine Mannschaft gehört zu genau einem Club und einer Ligaphase.
-   Innerhalb derselben Ligaphase darf ein Club mehrere Mannschaften
    führen.
-   Diese werden über die Mannschaftsnummer unterschieden.
-   Jede Mannschaft besitzt einen Kapitän.
-   Ein Ball kann der Mannschaft zugeordnet werden.
-   Mannschaften können aktiv oder inaktiv sein.

### 6.2 Mannschaftsspieler

Spieler können als

-   `STAMMSPIELER`
-   oder `ERSATZSPIELER`

gemeldet werden.

Für Stammspieler gilt:

-   Eine Stammposition ist erforderlich.
-   Die Stammposition liegt zwischen 1 und 3.

Für Ersatzspieler gilt:

-   Es wird keine Stammposition vergeben.

Zusätzlich kann für einen gemeldeten Spieler festgehalten werden:

-   ob er spielberechtigt ist;
-   ob eine Bemerkung zur Meldung vorhanden ist.

### 6.3 Hinzufügen eines Mannschaftsspielers

Die Stored Procedure `sp_MannschaftSpielerHinzufuegen` dient dazu, einen
Spieler kontrolliert einer Mannschaft hinzuzufügen.

Dabei werden die für diesen Ablauf vorgesehenen fachlichen Prüfungen
durchgeführt, bevor der Datensatz angelegt wird. Dadurch wird
verhindert, dass die Anwendung den Mannschaftskader nur über
unkontrollierte Direktinserts pflegt.

------------------------------------------------------------------------

## 7. Ligawettbewerbe und Spielsystem

### 7.1 Ligawettbewerb

-   Ein Ligawettbewerb gehört zu einer Saison und einem Verband.
-   Ein Wettbewerb ist entweder der Geschlechtskategorie `HERREN` oder
    `DAMEN` zugeordnet.
-   Optional kann eine Alterskategorie angegeben werden.
-   Jeder Ligawettbewerb verwendet ein Spielsystem.

### 7.2 Ligaphasen

Ein Ligawettbewerb kann in mehrere Phasen gegliedert werden.

Unterstützte Phasentypen sind:

-   `HAUPTRUNDE`
-   `VORRUNDE`
-   `FINALRUNDE`

Eine Ligaphase kann zusätzlich eine Gruppenbezeichnung und einen
zuständigen Klassenleiter besitzen.

### 7.3 Standardspielsystem

Das im Projekt als Seed-Datensatz hinterlegte Standardspielsystem ist
eine 3er-Mannschaft mit:

-   3 Spielern;
-   9 Einzeln;
-   1 Doppel;
-   maximal 10 Spielen.

Die maximale Anzahl Spiele entspricht der Summe aus Einzel- und
Doppelspielen.

------------------------------------------------------------------------

## 8. Begegnungen

### 8.1 Grundstruktur

-   Eine Begegnung findet innerhalb einer Ligaphase statt.
-   Sie besitzt eine Heim- und eine Gastmannschaft.
-   Heim- und Gastmannschaft müssen verschieden sein.
-   Eine Begegnung besitzt einen Spielort, ein Datum und eine Startzeit.
-   Optional können Runde, Endzeit, Zuschauerzahl und Schiedsrichter
    erfasst werden.

### 8.2 Begegnungsstatus

Unterstützte Statuswerte sind:

-   `GEPLANT`
-   `LAUFEND`
-   `ABGESCHLOSSEN`
-   `GENEHMIGT`
-   `ANNULLIERT`

Die Stored Procedure `sp_BegegnungErfassen` legt eine Begegnung
kontrolliert an. Eine neue Begegnung soll nicht direkt als `GENEHMIGT`
erzeugt werden.

### 8.3 Aufstellung

Für eine Begegnung werden die Spielerpositionen getrennt gespeichert.

Heimmannschaft:

-   `A`
-   `B`
-   `C`

Gastmannschaft:

-   `X`
-   `Y`
-   `Z`

Innerhalb einer Begegnung gilt:

-   eine Position darf nur einmal vorkommen;
-   ein Spieler darf nur einmal in der Aufstellung vorkommen;
-   Heimpositionen dürfen nur der Heimseite zugeordnet werden;
-   Gastpositionen dürfen nur der Gastseite zugeordnet werden.

### 8.4 Resultaterfassung

Für eine abgeschlossene Begegnung können unter anderem gespeichert
werden:

-   Siege Heim/Gast;
-   Mannschaftspunkte Heim/Gast;
-   Sätze Heim/Gast;
-   Bälle Heim/Gast;
-   Endzeit;
-   Zuschauerzahl;
-   Schiedsrichter.

Die Stored Procedure `sp_BegegnungResultatErfassen` dient zur
kontrollierten Erfassung des Gesamtergebnisses.

Dabei gelten unter anderem folgende Regeln:

-   genehmigte Begegnungen dürfen über diesen Ablauf nicht erneut
    überschrieben werden;
-   annullierte Begegnungen dürfen nicht regulär abgeschlossen werden;
-   Wertebereiche werden geprüft;
-   die Summe der Siege darf die maximale Anzahl Spiele des verwendeten
    Spielsystems nicht überschreiten;
-   bei erfolgreicher Erfassung wird der Status auf `ABGESCHLOSSEN`
    gesetzt;
-   die zusammengehörenden Änderungen werden transaktional ausgeführt.

### 8.5 Mannschaftspunkte

Für das Standardspielsystem werden die Mannschaftspunkte anhand der
Anzahl gewonnener Spiele vergeben:

       Siege   Mannschaftspunkte
  ---------- -------------------
    8 bis 10                   4
     6 bis 7                   3
           5                   2
     3 bis 4                   1
     0 bis 2                   0

Diese Regel beschreibt die fachliche Punktevergabe. Die Datenbank
speichert die resultierenden Mannschaftspunkte in der Begegnung.

### 8.6 Genehmigung

Eine genehmigte Begegnung muss konsistent gekennzeichnet sein.

Dazu gehören:

-   Status `GENEHMIGT`;
-   gesetztes Genehmigungskennzeichen;
-   Genehmigungszeitpunkt;
-   genehmigender Benutzer.

Damit ist nachvollziehbar, wann und durch wen ein Matchblatt genehmigt
wurde.

### 8.7 Bemerkungen und Änderungen

-   Bemerkungen können einer Begegnung mit Benutzer und Zeitpunkt
    zugeordnet werden.
-   Unterstützte Bemerkungsarten sind `VEREIN`, `KLASSENLEITER` und
    `ADMIN`.
-   Nachträgliche Änderungen können separat protokolliert werden.
-   Eine protokollierte Änderung benötigt einen nicht leeren Grund.
-   Dadurch bleiben Änderungen an relevanten Begegnungsdaten
    nachvollziehbar.

------------------------------------------------------------------------

## 9. Einzelspiele

### 9.1 Herkunft

Ein Einzelspiel stammt genau aus einer der beiden Quellen:

-   Ligabegegnung;
-   Turnierkategorie.

Ein Einzelspiel darf nicht gleichzeitig beiden Quellen zugeordnet sein.

### 9.2 Spielgründe

Unterstützte Spielgründe sind:

-   `REGULAER`
-   `AUFGABE`
-   `FORFAIT`
-   `NICHTANGETRETEN`
-   `ANNULLIERT`

### 9.3 Reguläres Einzel

-   Bei einem regulären Einzel müssen beide Spieler bekannt sein.
-   Die beiden Spieler müssen verschieden sein.
-   Ein gespeicherter Gewinner muss einem der beiden Spieler
    entsprechen.
-   Das Satzresultat wird zusätzlich durch die einzelnen Satzdatensätze
    detailliert abgebildet.

### 9.4 Forfait und Nichtantreten

-   Sonderfälle wie Forfait und Nichtantreten müssen abbildbar sein,
    auch wenn nicht beide Spieler vollständig gesetzt werden können.
-   Deshalb sind die Spielerfelder im Einzelspiel technisch nullable.
-   Diese Sonderfälle sind nicht Elo-relevant.

### 9.5 Aufgabe

-   Eine Aufgabe nach Spielbeginn wird über `AUFGABE` abgebildet.
-   Im Unterschied zu Forfait und Nichtantreten ist eine Aufgabe
    Elo-relevant.

------------------------------------------------------------------------

## 10. Doppelspiele

### 10.1 Herkunft

Ein Doppelspiel stammt genau aus:

-   einer Ligabegegnung;
-   oder einer Turnierkategorie.

### 10.2 Reguläres Doppel

Bei einem regulären Doppel gilt:

-   alle vier Spieler müssen bekannt sein;
-   alle vier Spieler müssen verschieden sein;
-   die Gewinnerseite kann als Seite 1 oder Seite 2 gespeichert werden.

### 10.3 Elo

-   Doppelspiele verändern den Elo-Wert nicht.
-   Die Elo-Berechnung erfolgt ausschließlich auf Basis Elo-relevanter
    Einzelspiele.

------------------------------------------------------------------------

## 11. Sätze

-   Ein Satz gehört genau zu einem Einzelspiel oder einem Doppelspiel.
-   Eine gleichzeitige Zuordnung zu beiden Spielarten ist nicht
    zulässig.
-   Satznummern liegen zwischen 1 und 7.
-   Innerhalb eines Spiels darf dieselbe Satznummer nur einmal
    vorkommen.
-   Die beiden Punktestände eines abgeschlossenen Satzes dürfen nicht
    identisch sein.
-   Satzdaten ermöglichen eine detaillierte Resultatdarstellung
    zusätzlich zum aggregierten Spielresultat.

------------------------------------------------------------------------

## 12. Turniere

### 12.1 Turnierstammdaten

Ein Turnier besitzt:

-   eine Saison;
-   eine Bewertungsperiode;
-   einen Veranstalter;
-   einen Spielort;
-   ein Startdatum;
-   optional ein Enddatum;
-   einen Meldeschluss;
-   optional einen Hallenschiedsrichter;
-   einen Status.

Der Meldeschluss darf nicht nach dem Turnierstart liegen.

### 12.2 Turnierstatus

Unterstützte Statuswerte sind:

-   `GEPLANT`
-   `OFFEN`
-   `AUSGELOST`
-   `LAUFEND`
-   `BEENDET`
-   `ABGESAGT`

Anmeldungen über den vorgesehenen Anmeldeablauf erfolgen nur zu einem
dafür offenen Turnier.

------------------------------------------------------------------------

## 13. Turnierkategorien

### 13.1 Wettkampfform

Eine Turnierkategorie besitzt genau eine Wettkampfform:

-   `EINZEL`
-   `DOPPEL`
-   `MANNSCHAFT`

### 13.2 Kategorieart

Unterstützte Kategoriearten sind:

-   `ALTER`
-   `KLASSIERUNG`
-   `ELO`
-   `OFFEN`
-   `KOMBINIERT`

Dadurch können Turnierkategorien unterschiedlich eingeschränkt werden.

### 13.3 Geschlechtskategorie

Unterstützte Werte sind:

-   `HERREN`
-   `DAMEN`
-   `MIXED`
-   `OFFEN`

### 13.4 Altersregeln

Unterstützte Altersregeln sind:

-   `ALLE`
-   `BIS_MAXALTER`
-   `AB_MINALTER`
-   `EXAKT`

Die Alterskategorie und die Altersregel bestimmen gemeinsam die
gewünschte fachliche Einschränkung.

### 13.5 Klassierungsregeln

Eine Kategorie kann über minimale und maximale Klassierungsstufen
eingeschränkt werden.

Bei Mannschaftskategorien kann zusätzlich festgelegt werden:

-   ob alle Spieler die Klassierungsanforderung erfüllen müssen;
-   welche minimale Klassierungssumme gilt;
-   welche maximale Klassierungssumme gilt.

### 13.6 Elo-Regeln

Eine Kategorie kann über Elo-Grenzen eingeschränkt werden.

Bei Mannschaftskategorien kann zusätzlich festgelegt werden:

-   ob alle Spieler die Elo-Anforderung erfüllen müssen;
-   welche minimale Elo-Summe gilt;
-   welche maximale Elo-Summe gilt.

### 13.7 Gewinnsätze

Eine Turnierkategorie wird auf:

-   3 Gewinnsätze;
-   oder 4 Gewinnsätze

festgelegt.

------------------------------------------------------------------------

## 14. Turnieranmeldungen

### 14.1 Allgemeine Statuswerte

Einzel-, Doppel- und Mannschaftsanmeldungen verwenden:

-   `ANGEMELDET`
-   `BESTAETIGT`
-   `ABGELEHNT`
-   `ZURUECKGEZOGEN`

Ein Ablehnungsgrund kann gespeichert werden.

### 14.2 Einzelanmeldung

-   Ein Spieler darf innerhalb derselben Turnierkategorie nur einmal als
    Einzelspieler angemeldet werden.
-   Elo, Klassierung und Alterskategorie werden nicht redundant in der
    Anmeldung gespeichert.
-   Die fachlich relevante Bewertung wird über die Bewertungsperiode des
    Turniers bestimmt.

Die Stored Procedure `sp_TurnierEinzelAnmelden` führt den kontrollierten
Anmeldeablauf aus. Dabei werden unter anderem folgende Voraussetzungen
geprüft:

-   der Spieler ist aktiv;
-   die Kategorie ist eine Einzelkategorie;
-   die Kategorie ist offen;
-   das Turnier ist offen;
-   der Meldeschluss wurde nicht überschritten;
-   es existiert noch keine Anmeldung desselben Spielers in dieser
    Kategorie.

Die Anmeldung wird transaktional durchgeführt.

### 14.3 Doppelanmeldung

-   Ein Spieler darf nicht mit sich selbst ein Doppel bilden.
-   Die Reihenfolge der beiden Spieler ist für die Identität des
    Doppelpaares irrelevant.
-   Das Paar Spieler A / Spieler B ist fachlich identisch mit Spieler B
    / Spieler A.
-   Die Datenbank normalisiert deshalb die beiden Lizenznummern in eine
    kleinere und eine grössere Lizenznummer.
-   Dadurch kann dasselbe Paar in einer Kategorie nicht in vertauschter
    Reihenfolge doppelt angemeldet werden.

### 14.4 Turniermannschaft

-   Eine Turniermannschaft gehört zu einer Mannschaftskategorie.
-   Der Mannschaftsname muss innerhalb der Kategorie eindeutig sein.
-   Eine Turniermannschaft ist nicht fest an einen einzelnen Club
    gebunden.
-   Dadurch können Spieler verschiedener Clubs gemeinsam antreten.

### 14.5 Spieler einer Turniermannschaft

-   Ein Spieler kann innerhalb derselben Turniermannschaft nur einmal
    vorkommen.
-   Eine Position kann optional vergeben werden.
-   Eine vergebene Position darf innerhalb derselben Mannschaft nur
    einmal vorkommen.
-   Pro Turniermannschaft kann höchstens ein Spieler als Captain
    gekennzeichnet werden.

------------------------------------------------------------------------

## 15. Transaktionen und Fehlerbehandlung

Fachlich zusammengehörende Änderungen sollen atomar ausgeführt werden.
Deshalb verwenden zentrale Stored Procedures Transaktionen.

Dies betrifft insbesondere Abläufe wie:

-   Erfassen eines Begegnungsresultats;
-   Turnier-Einzelanmeldung;
-   Aktualisierung eines Elo-Stands.

Wenn während eines solchen Ablaufs ein Fehler auftritt, sollen keine
fachlich unvollständigen Teiländerungen zurückbleiben.

Die Stored Procedures prüfen deshalb wichtige Vorbedingungen und brechen
ungültige Vorgänge mit Fehlern ab.

------------------------------------------------------------------------

## 16. Abgrenzung zwischen Constraints und Geschäftslogik

Nicht jede Geschäftsregel kann sinnvoll durch einen einzelnen
Tabellen-Constraint abgebildet werden.

Beispiele:

-   Prüfung, ob eine Begegnung zum verwendeten Spielsystem passt;
-   Prüfung der maximalen Anzahl Siege anhand des Spielsystems;
-   Prüfung, ob eine Turnierkategorie für eine bestimmte Anmeldeart
    offen ist;
-   Prüfung des Meldeschlusses;
-   Elo-Aktualisierung eines abgeschlossenen Einzelspiels;
-   komplexe rollen- oder ablaufabhängige Berechtigungen.

Solche Regeln werden, soweit im Projekt umgesetzt, durch Stored
Procedures und kontrollierte Abläufe ergänzt.

Die Tabellen-Constraints bilden dagegen die grundlegende Datenintegrität
ab. Die detaillierte technische Beschreibung dieser Regeln befindet sich
in `Constraints.md`.

------------------------------------------------------------------------

## 17. Zusammenfassung

Die Geschäftsregeln verbinden das relationale Datenmodell mit den realen
Abläufen des Tischtennisbetriebs.

Besonders wichtig sind:

-   saisonabhängige Spieler- und Vereinsdaten;
-   Hauptverein und Mehrfachlizenz;
-   getrennte offizielle Bewertung und monatliche Elo-Historie;
-   unterschiedliche Behandlung von regulären Spielen, Aufgabe, Forfait
    und Nichtantreten;
-   Stamm- und Ersatzspielermeldungen;
-   kontrollierte Begegnungs- und Resultaterfassung;
-   Genehmigung und Änderungsnachvollziehbarkeit;
-   flexible Turnierkategorien;
-   Einzel-, Doppel- und Mannschaftsanmeldungen;
-   transaktionale Geschäftslogik über Stored Procedures.

Damit werden nicht nur Tabellen gespeichert, sondern zentrale fachliche
Prozesse des Liga- und Turnierbetriebs nachvollziehbar und konsistent
abgebildet.
