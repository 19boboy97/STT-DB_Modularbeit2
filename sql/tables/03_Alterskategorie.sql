USE STT_DB;
GO

/*
    Tabelle: Alterskategorie
    Zweck:
    Speichert die Alterskategorien eines Spielers.

    Wichtig:
    Die Alterskategorie beschreibt das Alter des Spielers.
    Sie ist nicht automatisch identisch mit der
    Teilnahmeberechtigung eines Wettbewerbs.
*/

CREATE TABLE dbo.Alterskategorie
(
    Bezeichnung VARCHAR(10) NOT NULL,
    MinAlter TINYINT NOT NULL,
    MaxAlter TINYINT NULL,

    CONSTRAINT PK_Alterskategorie
        PRIMARY KEY (Bezeichnung),

    CONSTRAINT CK_Alterskategorie_Alter
        CHECK
        (
            MinAlter >= 0
            AND
            (
                MaxAlter IS NULL
                OR MaxAlter >= MinAlter
            )
        )
);
GO