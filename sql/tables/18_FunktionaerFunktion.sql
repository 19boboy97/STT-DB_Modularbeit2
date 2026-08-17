USE STT_DB;
GO

/*
    Tabelle: FunktionaerFunktion
    Zweck:
    Verknüpft Vereinsfunktionäre mit ihren Funktionen.

    Ein Funktionär kann mehrere Funktionen gleichzeitig besitzen.
*/

CREATE TABLE dbo.FunktionaerFunktion
(
    FunktionaerID INT NOT NULL,
    FunktionID INT NOT NULL,
    GueltigAb DATE NOT NULL,
    GueltigBis DATE NULL,

    CONSTRAINT PK_FunktionaerFunktion
        PRIMARY KEY
        (
            FunktionaerID,
            FunktionID,
            GueltigAb
        ),

    CONSTRAINT FK_FunktionaerFunktion_Funktionaer
        FOREIGN KEY (FunktionaerID)
        REFERENCES dbo.Vereinsfunktionaer(FunktionaerID),

    CONSTRAINT FK_FunktionaerFunktion_Funktion
        FOREIGN KEY (FunktionID)
        REFERENCES dbo.Funktion(FunktionID),

    CONSTRAINT CK_FunktionaerFunktion_Gueltigkeit
        CHECK
        (
            GueltigBis IS NULL
            OR GueltigBis >= GueltigAb
        )
);
GO