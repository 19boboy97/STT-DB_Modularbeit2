USE STT_DB;
GO

/*
    Tabelle: Begegnungsaufstellung
    Zweck:
    Speichert die Spieleraufstellung für eine
    konkrete Mannschaftsbegegnung.

    Heimpositionen:
    A, B, C

    Gastpositionen:
    X, Y, Z
*/

CREATE TABLE dbo.Begegnungsaufstellung
(
    BegegnungsaufstellungID BIGINT IDENTITY(1,1) NOT NULL,
    BegegnungID BIGINT NOT NULL,
    MannschaftID INT NOT NULL,
    LizenzNr INT NOT NULL,
    Seite VARCHAR(4) NOT NULL,
    Position CHAR(1) NOT NULL,

    CONSTRAINT PK_Begegnungsaufstellung
        PRIMARY KEY (BegegnungsaufstellungID),

    CONSTRAINT FK_Begegnungsaufstellung_Begegnung
        FOREIGN KEY (BegegnungID)
        REFERENCES dbo.Begegnung(BegegnungID),

    CONSTRAINT FK_Begegnungsaufstellung_Mannschaft
        FOREIGN KEY (MannschaftID)
        REFERENCES dbo.Mannschaft(MannschaftID),

    CONSTRAINT FK_Begegnungsaufstellung_Spieler
        FOREIGN KEY (LizenzNr)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT CK_Begegnungsaufstellung_Seite
        CHECK
        (
            Seite IN ('HEIM', 'GAST')
        ),

    CONSTRAINT CK_Begegnungsaufstellung_Position
        CHECK
        (
            Position IN ('A', 'B', 'C', 'X', 'Y', 'Z')
        ),

    CONSTRAINT CK_Begegnungsaufstellung_SeitePosition
        CHECK
        (
            (Seite = 'HEIM' AND Position IN ('A', 'B', 'C'))
            OR
            (Seite = 'GAST' AND Position IN ('X', 'Y', 'Z'))
        ),

    CONSTRAINT UQ_Begegnungsaufstellung_Position
        UNIQUE
        (
            BegegnungID,
            Position
        ),

    CONSTRAINT UQ_Begegnungsaufstellung_Spieler
        UNIQUE
        (
            BegegnungID,
            LizenzNr
        )
);
GO