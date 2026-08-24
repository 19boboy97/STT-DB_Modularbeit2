/*
    View: vw_MannschaftenLiga

    Zweck:
    Zeigt Mannschaften mit den wichtigsten
    Informationen aus Liga, Club, Saison,
    Captain und Ball in einer lesbaren Sicht.
*/

CREATE VIEW dbo.vw_MannschaftenLiga
AS

SELECT
    m.MannschaftID,
    m.MannschaftNummer,
    m.Aktiv AS MannschaftAktiv,

    c.VereinsNr,
    c.Clubname,
    c.Kurzname AS ClubKurzname,

    lp.LigaphaseID,
    lp.Bezeichnung AS Ligaphase,
    lp.Phasentyp,
    lp.Gruppenbezeichnung,

    lw.LigawettbewerbID,
    lw.Bezeichnung AS Ligawettbewerb,
    lw.Geschlechtskategorie,
    lw.Alterskategorie,

    s.SaisonID,
    s.Bezeichnung AS Saison,
    s.Startdatum,
    s.Enddatum,
    s.IstAktuell,

    kap.LizenzNr AS KapitaenLizenz,
    kap.Vorname AS KapitaenVorname,
    kap.Nachname AS KapitaenNachname,

    b.BallID,
    b.Marke AS BallMarke,
    b.Modell AS BallModell,
    b.Farbe AS BallFarbe

FROM dbo.Mannschaft AS m

INNER JOIN dbo.Club AS c
    ON c.VereinsNr = m.VereinsNr

INNER JOIN dbo.Ligaphase AS lp
    ON lp.LigaphaseID = m.LigaphaseID

INNER JOIN dbo.Ligawettbewerb AS lw
    ON lw.LigawettbewerbID = lp.LigawettbewerbID

INNER JOIN dbo.Saison AS s
    ON s.SaisonID = lw.SaisonID

INNER JOIN dbo.Spieler AS kap
    ON kap.LizenzNr = m.KapitaenLizenz

LEFT JOIN dbo.Ball AS b
    ON b.BallID = m.BallID;
GO