USE STT_DB;
GO

/*
    Tabelle: SpielerVerein
    Zweck:
    Speichert die aktuelle Vereinszuordnung eines Spielers
    innerhalb einer Saison.

    Es werden Hauptverein und Mehrfachlizenz unterschieden.
*/

CREATE TABLE dbo.SpielerVerein
(
    SpielerVereinID BIGINT IDENTITY(1,1) NOT NULL,
    LizenzNr INT NOT NULL,
    SaisonID INT NOT NULL,
    VereinsNr INT NOT NULL,
    Zuordnungsart VARCHAR(20) NOT NULL,
    Wettbewerbsbereich VARCHAR(20) NOT NULL,

    CONSTRAINT PK_SpielerVerein
        PRIMARY KEY (SpielerVereinID),

    CONSTRAINT FK_SpielerVerein_Spieler
        FOREIGN KEY (LizenzNr)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT FK_SpielerVerein_Saison
        FOREIGN KEY (SaisonID)
        REFERENCES dbo.Saison(SaisonID),

    CONSTRAINT FK_SpielerVerein_Club
        FOREIGN KEY (VereinsNr)
        REFERENCES dbo.Club(VereinsNr),

    CONSTRAINT UQ_SpielerVerein_Zuordnung
        UNIQUE
        (
            LizenzNr,
            SaisonID,
            VereinsNr,
            Zuordnungsart,
            Wettbewerbsbereich
        ),

    CONSTRAINT CK_SpielerVerein_Zuordnungsart
        CHECK
        (
            Zuordnungsart IN
            (
                'HAUPTVEREIN',
                'MEHRFACHLIZENZ'
            )
        ),

    CONSTRAINT CK_SpielerVerein_Wettbewerbsbereich
        CHECK
        (
            Wettbewerbsbereich IN
            (
                'ALLE',
                'HERREN',
                'DAMEN',
                'NACHWUCHS',
                'SENIOREN'
            )
        )
);
GO

/*
    Pro Spieler und Saison darf nur ein Hauptverein existieren.
*/
CREATE UNIQUE INDEX UX_SpielerVerein_Hauptverein
ON dbo.SpielerVerein
(
    LizenzNr,
    SaisonID
)
WHERE Zuordnungsart = 'HAUPTVEREIN';
GO