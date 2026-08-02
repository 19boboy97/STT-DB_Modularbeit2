# Datenmodell

## Ziel

Dieses Dokument beschreibt die Tabellen, Beziehungen, Schlüssel und Geschäftsregeln der STT-Datenbank.

## Fachbereiche

1. Saison und Verbände
2. Clubs und Spielorte
3. Spieler und Vereinszuordnungen
4. Elo und Klassierungen
5. Ligawettbewerbe und Mannschaften
6. Begegnungen, Einzel, Doppel und Sätze
7. Turniere und Anmeldungen
8. Benutzer und Berechtigungen

## Tabellen

Die endgültigen Tabellen werden nach Abschluss der fachlichen Prüfung hier dokumentiert.

## Beziehungen

Das ER-Diagramm wird später ergänzt.

## Konventionen

- Primärschlüssel werden mit `PK` gekennzeichnet.
- Fremdschlüssel werden mit `FK` gekennzeichnet.
- Technische Schlüssel verwenden überwiegend `INT IDENTITY`.
- Lizenznummer und Vereinsnummer sind fachliche Schlüssel.
- Datumswerte verwenden `DATE` oder `DATETIME2`.
- Texte mit Umlauten verwenden `NVARCHAR`.