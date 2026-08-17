USE STT_DB;
GO

/*
    Tabelle: SpielerElo
    Zweck:
    Speichert die offiziellen monatlichen Elo-Stände
    eines Spielers.

    Dadurch kann der Elo-Verlauf über Monate und Jahre
    nachvollzogen werden.
*/

CREATE TABLE dbo.SpielerElo
(
    SpielerEloID BIGINT IDENTITY(1,1) NOT NULL,
    LizenzNr INT NOT NULL,
    EloMonatslaufID BIGINT NOT NULL,
    Elo DECIMAL(10,3) NOT NULL,
    EloDeltaZumVormonat DECIMAL(10,3) NULL,
    HerrenStufenwert TINYINT NOT NULL,
    DamenStufenwert TINYINT NULL,
    HerrenRang INT NULL,
    Gesamtrang INT NULL,
    GueltigAb DATE NOT NULL,
    GueltigBis DATE NULL,

    CONSTRAINT PK_SpielerElo
        PRIMARY KEY (SpielerEloID),

    CONSTRAINT FK_SpielerElo_Spieler
        FOREIGN KEY (LizenzNr)
        REFERENCES dbo.Spieler(LizenzNr),

    CONSTRAINT FK_SpielerElo_EloMonatslauf
        FOREIGN KEY (EloMonatslaufID)
        REFERENCES dbo.EloMonatslauf(EloMonatslaufID),

    CONSTRAINT FK_SpielerElo_HerrenStufenwert
        FOREIGN KEY (HerrenStufenwert)
        REFERENCES dbo.Klassierungsstufe(Stufenwert),

    CONSTRAINT FK_SpielerElo_DamenStufenwert
        FOREIGN KEY (DamenStufenwert)
        REFERENCES dbo.Klassierungsstufe(Stufenwert),

    CONSTRAINT UQ_SpielerElo_Spieler_Monatslauf
        UNIQUE (LizenzNr, EloMonatslaufID),

    CONSTRAINT CK_SpielerElo_Elo
        CHECK (Elo >= 0),

    CONSTRAINT CK_SpielerElo_HerrenRang
        CHECK (HerrenRang IS NULL OR HerrenRang > 0),

    CONSTRAINT CK_SpielerElo_Gesamtrang
        CHECK (Gesamtrang IS NULL OR Gesamtrang > 0),

    CONSTRAINT CK_SpielerElo_Gueltigkeit
        CHECK (GueltigBis IS NULL OR GueltigBis >= GueltigAb)
);
GO