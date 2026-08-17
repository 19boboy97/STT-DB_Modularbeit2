USE STT_DB;
GO

/*
    Tabelle: EloMonatslauf
    Zweck:
    Speichert die monatlichen offiziellen Elo-Berechnungsläufe.

    Alle Elo-relevanten Einzelspiele seit dem letzten
    Berechnungsstichtag werden einem Monatslauf zugeordnet.
*/

CREATE TABLE dbo.EloMonatslauf
(
    EloMonatslaufID BIGINT IDENTITY(1,1) NOT NULL,
    Berechnungsdatum DATE NOT NULL,
    PeriodeVon DATE NOT NULL,
    PeriodeBis DATE NOT NULL,
    Status VARCHAR(20) NOT NULL,
    GestartetAm DATETIME2(0) NULL,
    AbgeschlossenAm DATETIME2(0) NULL,
    Bemerkung NVARCHAR(500) NULL,

    CONSTRAINT PK_EloMonatslauf
        PRIMARY KEY (EloMonatslaufID),

    CONSTRAINT UQ_EloMonatslauf_Berechnungsdatum
        UNIQUE (Berechnungsdatum),

    CONSTRAINT CK_EloMonatslauf_Periode
        CHECK (PeriodeBis >= PeriodeVon),

    CONSTRAINT CK_EloMonatslauf_Status
        CHECK
        (
            Status IN
            (
                'GEPLANT',
                'LAUFEND',
                'ABGESCHLOSSEN',
                'FEHLER'
            )
        ),

    CONSTRAINT CK_EloMonatslauf_Zeit
        CHECK
        (
            AbgeschlossenAm IS NULL
            OR GestartetAm IS NULL
            OR AbgeschlossenAm >= GestartetAm
        )
);
GO