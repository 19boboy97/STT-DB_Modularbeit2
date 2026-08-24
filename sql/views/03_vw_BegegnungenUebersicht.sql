/*
    View: vw_BegegnungenUebersicht

    Zweck:
    Liefert eine gut lesbare Übersicht aller Begegnungen
    inklusive Saison, Liga, Heim-/Gastmannschaft,
    Spielort, Resultat und Status.
*/

CREATE VIEW dbo.vw_BegegnungenUebersicht
AS

SELECT
    b.BegegnungID,

    s.SaisonID,
    s.Bezeichnung AS Saison,

    lw.LigawettbewerbID,
    lw.Bezeichnung AS Ligawettbewerb,

    lp.LigaphaseID,
    lp.Bezeichnung AS Ligaphase,
    lp.Gruppenbezeichnung,

    b.Runde,
    b.Datum,
    b.Startzeit,
    b.Endzeit,

    hm.MannschaftID AS HeimMannschaftID,
    hc.VereinsNr AS HeimVereinsNr,
    hc.Clubname AS HeimClub,
    hc.Kurzname AS HeimClubKurzname,
    hm.MannschaftNummer AS HeimMannschaftNummer,

    gm.MannschaftID AS GastMannschaftID,
    gc.VereinsNr AS GastVereinsNr,
    gc.Clubname AS GastClub,
    gc.Kurzname AS GastClubKurzname,
    gm.MannschaftNummer AS GastMannschaftNummer,

    so.SpielortID,
    so.Bezeichnung AS Spielort,
    so.Gebaeude,
    so.Strasse,
    so.Hausnummer,
    so.PLZ,
    so.Ort AS SpielortOrt,
    so.Landcode,

    b.SiegeHeim,
    b.SiegeGast,

    b.MannschaftspunkteHeim,
    b.MannschaftspunkteGast,

    b.SaetzeHeim,
    b.SaetzeGast,

    b.BaelleHeim,
    b.BaelleGast,

    b.ZuschauerAnzahl,
    b.SchiedsrichterName,

    b.MatchblattGenehmigt,
    b.GenehmigtAm,
    b.GenehmigtVon,

    b.Status

FROM dbo.Begegnung AS b

INNER JOIN dbo.Ligaphase AS lp
    ON lp.LigaphaseID = b.LigaphaseID

INNER JOIN dbo.Ligawettbewerb AS lw
    ON lw.LigawettbewerbID = lp.LigawettbewerbID

INNER JOIN dbo.Saison AS s
    ON s.SaisonID = lw.SaisonID

INNER JOIN dbo.Mannschaft AS hm
    ON hm.MannschaftID = b.HeimMannschaftID

INNER JOIN dbo.Club AS hc
    ON hc.VereinsNr = hm.VereinsNr

INNER JOIN dbo.Mannschaft AS gm
    ON gm.MannschaftID = b.GastMannschaftID

INNER JOIN dbo.Club AS gc
    ON gc.VereinsNr = gm.VereinsNr

LEFT JOIN dbo.Spielort AS so
    ON so.SpielortID = b.SpielortID;
GO