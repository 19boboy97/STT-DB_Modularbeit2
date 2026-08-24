/*
    View: vw_SpielerAktuell
    Zweck:
    Zeigt den aktuellen Stand eines Spielers mit:
    - Stammdaten
    - aktueller Saison
    - Alterskategorie
    - Hauptverein
    - aktueller Bewertung
*/

CREATE VIEW dbo.vw_SpielerAktuell
AS

SELECT
    s.LizenzNr,
    s.Vorname,
    s.Nachname,
    s.Geburtsdatum,
    s.Geschlecht,
    s.Aktiv AS SpielerAktiv,

    sa.SaisonID,
    sa.Bezeichnung AS Saison,
    ss.Alterskategorie,
    ss.LizenzAktiv,

    c.VereinsNr,
    c.Clubname,
    c.Kurzname AS ClubKurzname,

    sb.Elo,
    sb.HerrenStufenwert,
    kh.Bezeichnung AS HerrenKlassierung,

    sb.DamenStufenwert,
    kd.Bezeichnung AS DamenKlassierung

FROM dbo.Spieler AS s

INNER JOIN dbo.SpielerSaison AS ss
    ON ss.LizenzNr = s.LizenzNr

INNER JOIN dbo.Saison AS sa
    ON sa.SaisonID = ss.SaisonID
   AND sa.IstAktuell = 1

LEFT JOIN dbo.SpielerVerein AS sv
    ON sv.LizenzNr = s.LizenzNr
   AND sv.SaisonID = sa.SaisonID
   AND sv.Zuordnungsart = 'HAUPTVEREIN'

LEFT JOIN dbo.Club AS c
    ON c.VereinsNr = sv.VereinsNr

LEFT JOIN dbo.Bewertungsperiode AS bp
    ON bp.SaisonID = sa.SaisonID
   AND CAST(GETDATE() AS DATE) BETWEEN bp.GueltigAb AND bp.GueltigBis

LEFT JOIN dbo.SpielerBewertung AS sb
    ON sb.LizenzNr = s.LizenzNr
   AND sb.BewertungsperiodeID = bp.BewertungsperiodeID

LEFT JOIN dbo.Klassierungsstufe AS kh
    ON kh.Stufenwert = sb.HerrenStufenwert

LEFT JOIN dbo.Klassierungsstufe AS kd
    ON kd.Stufenwert = sb.DamenStufenwert;
GO