/*
    View: vw_Spielresultate

    Zweck:
    Fasst Einzel- und Doppelspiele in einer gemeinsamen
    Ergebnisübersicht zusammen.

    Die View zeigt:
    - Spielart
    - Herkunft (Liga / Turnier)
    - Spieler
    - Gewinner
    - Satzresultat
    - Spielgrund
    - Status
*/

CREATE VIEW dbo.vw_Spielresultate
AS

/*
    ============================================================
    EINZELSPIELE
    ============================================================
*/
SELECT
    'EINZEL' AS Spielart,

    e.EinzelspielID AS SpielID,

    CASE
        WHEN e.BegegnungID IS NOT NULL THEN 'LIGA'
        ELSE 'TURNIER'
    END AS Herkunft,

    e.BegegnungID,
    e.TurnierKategorieID,

    tk.Bezeichnung AS TurnierKategorie,

    e.Spielnummer,
    e.Spielcode,
    e.Spieldatum,

    e.Spieler1Lizenz AS Seite1Spieler1Lizenz,
    s1.Vorname AS Seite1Spieler1Vorname,
    s1.Nachname AS Seite1Spieler1Nachname,

    CAST(NULL AS INT) AS Seite1Spieler2Lizenz,
    CAST(NULL AS NVARCHAR(80)) AS Seite1Spieler2Vorname,
    CAST(NULL AS NVARCHAR(80)) AS Seite1Spieler2Nachname,

    e.Spieler2Lizenz AS Seite2Spieler1Lizenz,
    s2.Vorname AS Seite2Spieler1Vorname,
    s2.Nachname AS Seite2Spieler1Nachname,

    CAST(NULL AS INT) AS Seite2Spieler2Lizenz,
    CAST(NULL AS NVARCHAR(80)) AS Seite2Spieler2Vorname,
    CAST(NULL AS NVARCHAR(80)) AS Seite2Spieler2Nachname,

    e.GewinnerLizenz,
    gew.Vorname AS GewinnerVorname,
    gew.Nachname AS GewinnerNachname,

    CAST(NULL AS TINYINT) AS Gewinnerseite,

    e.SaetzeSpieler1 AS SaetzeSeite1,
    e.SaetzeSpieler2 AS SaetzeSeite2,

    e.PunkteSpieler1 AS PunkteSeite1,
    e.PunkteSpieler2 AS PunkteSeite2,

    e.Spielgrund,
    e.Status

FROM dbo.Einzelspiel AS e

LEFT JOIN dbo.TurnierKategorie AS tk
    ON tk.TurnierKategorieID = e.TurnierKategorieID

LEFT JOIN dbo.Spieler AS s1
    ON s1.LizenzNr = e.Spieler1Lizenz

LEFT JOIN dbo.Spieler AS s2
    ON s2.LizenzNr = e.Spieler2Lizenz

LEFT JOIN dbo.Spieler AS gew
    ON gew.LizenzNr = e.GewinnerLizenz


UNION ALL


/*
    ============================================================
    DOPPELSPIELE
    ============================================================
*/
SELECT
    'DOPPEL' AS Spielart,

    d.DoppelspielID AS SpielID,

    CASE
        WHEN d.BegegnungID IS NOT NULL THEN 'LIGA'
        ELSE 'TURNIER'
    END AS Herkunft,

    d.BegegnungID,
    d.TurnierKategorieID,

    tk.Bezeichnung AS TurnierKategorie,

    d.Spielnummer,
    d.Spielcode,
    d.Spieldatum,

    d.Seite1Spieler1Lizenz,
    s11.Vorname AS Seite1Spieler1Vorname,
    s11.Nachname AS Seite1Spieler1Nachname,

    d.Seite1Spieler2Lizenz,
    s12.Vorname AS Seite1Spieler2Vorname,
    s12.Nachname AS Seite1Spieler2Nachname,

    d.Seite2Spieler1Lizenz,
    s21.Vorname AS Seite2Spieler1Vorname,
    s21.Nachname AS Seite2Spieler1Nachname,

    d.Seite2Spieler2Lizenz,
    s22.Vorname AS Seite2Spieler2Vorname,
    s22.Nachname AS Seite2Spieler2Nachname,

    CAST(NULL AS INT) AS GewinnerLizenz,
    CAST(NULL AS NVARCHAR(80)) AS GewinnerVorname,
    CAST(NULL AS NVARCHAR(80)) AS GewinnerNachname,

    d.Gewinnerseite,

    d.SaetzeSeite1,
    d.SaetzeSeite2,

    d.PunkteSeite1,
    d.PunkteSeite2,

    d.Spielgrund,
    d.Status

FROM dbo.Doppelspiel AS d

LEFT JOIN dbo.TurnierKategorie AS tk
    ON tk.TurnierKategorieID = d.TurnierKategorieID

LEFT JOIN dbo.Spieler AS s11
    ON s11.LizenzNr = d.Seite1Spieler1Lizenz

LEFT JOIN dbo.Spieler AS s12
    ON s12.LizenzNr = d.Seite1Spieler2Lizenz

LEFT JOIN dbo.Spieler AS s21
    ON s21.LizenzNr = d.Seite2Spieler1Lizenz

LEFT JOIN dbo.Spieler AS s22
    ON s22.LizenzNr = d.Seite2Spieler2Lizenz;
GO