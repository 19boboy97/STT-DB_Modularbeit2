USE STT_DB;
GO

/*
    Tabelle: BenutzerMannschaft
    Zweck:
    Ordnet Benutzer mit der Rolle CAPTAIN
    einer oder mehreren Mannschaften zu.

    Damit kann eingeschränkt werden,
    welche Mannschaftsergebnisse ein Captain pflegen darf.
*/

CREATE TABLE dbo.BenutzerMannschaft
(
    BenutzerID INT NOT NULL,
    MannschaftID INT NOT NULL,

    CONSTRAINT PK_BenutzerMannschaft
        PRIMARY KEY
        (
            BenutzerID,
            MannschaftID
        ),

    CONSTRAINT FK_BenutzerMannschaft_Benutzer
        FOREIGN KEY (BenutzerID)
        REFERENCES dbo.Benutzer(BenutzerID),

    CONSTRAINT FK_BenutzerMannschaft_Mannschaft
        FOREIGN KEY (MannschaftID)
        REFERENCES dbo.Mannschaft(MannschaftID)
);
GO