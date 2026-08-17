USE STT_DB;
GO

/*
    Tabelle: Begegnungsbemerkung
    Zweck:
    Speichert Bemerkungen zu einer Begegnung.

    Die Bemerkungen können von Verein,
    Klassenleiter oder Admin stammen.
*/

CREATE TABLE dbo.Begegnungsbemerkung
(
    BegegnungsbemerkungID BIGINT IDENTITY(1,1) NOT NULL,
    BegegnungID BIGINT NOT NULL,
    BenutzerID INT NOT NULL,
    Bemerkungsart VARCHAR(20) NOT NULL,
    Text NVARCHAR(MAX) NOT NULL,
    ErstelltAm DATETIME2(0) NOT NULL
        CONSTRAINT DF_Begegnungsbemerkung_ErstelltAm DEFAULT (SYSDATETIME()),

    CONSTRAINT PK_Begegnungsbemerkung
        PRIMARY KEY (BegegnungsbemerkungID),

    CONSTRAINT FK_Begegnungsbemerkung_Begegnung
        FOREIGN KEY (BegegnungID)
        REFERENCES dbo.Begegnung(BegegnungID),

    CONSTRAINT FK_Begegnungsbemerkung_Benutzer
        FOREIGN KEY (BenutzerID)
        REFERENCES dbo.Benutzer(BenutzerID),

    CONSTRAINT CK_Begegnungsbemerkung_Art
        CHECK
        (
            Bemerkungsart IN
            (
                'VEREIN',
                'KLASSENLEITER',
                'ADMIN'
            )
        )
);
GO