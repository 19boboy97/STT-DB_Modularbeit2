USE STT_DB;
GO

/*
    Tabelle: BegegnungAenderung
    Zweck:
    Dokumentiert nachträgliche Änderungen an
    bereits genehmigten Begegnungen.
*/

CREATE TABLE dbo.BegegnungAenderung
(
    BegegnungAenderungID BIGINT IDENTITY(1,1) NOT NULL,
    BegegnungID BIGINT NOT NULL,
    BenutzerID INT NOT NULL,
    Aenderungsdatum DATETIME2(0) NOT NULL
        CONSTRAINT DF_BegegnungAenderung_Aenderungsdatum DEFAULT (SYSDATETIME()),
    Grund NVARCHAR(500) NOT NULL,

    CONSTRAINT PK_BegegnungAenderung
        PRIMARY KEY (BegegnungAenderungID),

    CONSTRAINT FK_BegegnungAenderung_Begegnung
        FOREIGN KEY (BegegnungID)
        REFERENCES dbo.Begegnung(BegegnungID),

    CONSTRAINT FK_BegegnungAenderung_Benutzer
        FOREIGN KEY (BenutzerID)
        REFERENCES dbo.Benutzer(BenutzerID),

    CONSTRAINT CK_BegegnungAenderung_Grund
        CHECK
        (
            LEN(LTRIM(RTRIM(Grund))) > 0
        )
);
GO