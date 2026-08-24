
/*
    Tabelle: TurnierKategorie
    Zweck:
    Speichert eine einzelne Kategorie / Konkurrenz eines Turniers.

    Eine Kategorie kann über Alter, Klassierung, Elo
    oder eine Kombination dieser Kriterien eingeschränkt werden.
*/

CREATE TABLE dbo.TurnierKategorie
(
    TurnierKategorieID INT IDENTITY(1,1) NOT NULL,
    TurnierID INT NOT NULL,
    Bezeichnung NVARCHAR(150) NOT NULL,

    Kategorieart VARCHAR(20) NOT NULL,
    Wettkampfform VARCHAR(15) NOT NULL,
    Geschlechtskategorie VARCHAR(10) NOT NULL,
    VerwendeteKlassierungsart VARCHAR(10) NULL,

    Alterskategorie VARCHAR(10) NULL,
    Altersregel VARCHAR(20) NOT NULL,
    BevorzugePassendeKategorie BIT NOT NULL
        CONSTRAINT DF_TurnierKategorie_BevorzugePassendeKategorie DEFAULT (1),

    MinStufenwert TINYINT NULL,
    MaxStufenwert TINYINT NULL,
    AlleSpielerMuessenKlassierungErfuellen BIT NOT NULL
        CONSTRAINT DF_TurnierKategorie_KlassierungAlle DEFAULT (1),

    MinEloWert DECIMAL(10,3) NULL,
    TopEloWert DECIMAL(10,3) NULL,
    AlleSpielerMuessenEloErfuellen BIT NOT NULL
        CONSTRAINT DF_TurnierKategorie_EloAlle DEFAULT (1),

    SpielerProTeam TINYINT NULL,

    MinKlassierungSumme SMALLINT NULL,
    MaxKlassierungSumme SMALLINT NULL,

    MinEloSumme DECIMAL(10,3) NULL,
    MaxEloSumme DECIMAL(10,3) NULL,

    Gewinnsaetze TINYINT NOT NULL,
    Status VARCHAR(20) NOT NULL,

    CONSTRAINT PK_TurnierKategorie
        PRIMARY KEY (TurnierKategorieID),

    CONSTRAINT FK_TurnierKategorie_Turnier
        FOREIGN KEY (TurnierID)
        REFERENCES dbo.Turnier(TurnierID),

    CONSTRAINT FK_TurnierKategorie_Alterskategorie
        FOREIGN KEY (Alterskategorie)
        REFERENCES dbo.Alterskategorie(Bezeichnung),

    CONSTRAINT FK_TurnierKategorie_MinStufenwert
        FOREIGN KEY (MinStufenwert)
        REFERENCES dbo.Klassierungsstufe(Stufenwert),

    CONSTRAINT FK_TurnierKategorie_MaxStufenwert
        FOREIGN KEY (MaxStufenwert)
        REFERENCES dbo.Klassierungsstufe(Stufenwert),

    CONSTRAINT UQ_TurnierKategorie_Turnier_Bezeichnung
        UNIQUE
        (
            TurnierID,
            Bezeichnung
        ),

    CONSTRAINT CK_TurnierKategorie_Kategorieart
        CHECK
        (
            Kategorieart IN
            (
                'ALTER',
                'KLASSIERUNG',
                'ELO',
                'OFFEN',
                'KOMBINIERT'
            )
        ),

    CONSTRAINT CK_TurnierKategorie_Wettkampfform
        CHECK
        (
            Wettkampfform IN
            (
                'EINZEL',
                'DOPPEL',
                'MANNSCHAFT'
            )
        ),

    CONSTRAINT CK_TurnierKategorie_Geschlecht
        CHECK
        (
            Geschlechtskategorie IN
            (
                'HERREN',
                'DAMEN',
                'MIXED',
                'OFFEN'
            )
        ),

    CONSTRAINT CK_TurnierKategorie_Klassierungsart
        CHECK
        (
            VerwendeteKlassierungsart IS NULL
            OR VerwendeteKlassierungsart IN ('HERREN', 'DAMEN')
        ),

    CONSTRAINT CK_TurnierKategorie_Altersregel
        CHECK
        (
            Altersregel IN
            (
                'ALLE',
                'BIS_MAXALTER',
                'AB_MINALTER',
                'EXAKT'
            )
        ),

    CONSTRAINT CK_TurnierKategorie_Stufenbereich
        CHECK
        (
            MinStufenwert IS NULL
            OR MaxStufenwert IS NULL
            OR MinStufenwert <= MaxStufenwert
        ),

    CONSTRAINT CK_TurnierKategorie_EloBereich
        CHECK
        (
            MinEloWert IS NULL
            OR TopEloWert IS NULL
            OR MinEloWert <= TopEloWert
        ),

    CONSTRAINT CK_TurnierKategorie_KlassierungSumme
        CHECK
        (
            MinKlassierungSumme IS NULL
            OR MaxKlassierungSumme IS NULL
            OR MinKlassierungSumme <= MaxKlassierungSumme
        ),

    CONSTRAINT CK_TurnierKategorie_EloSumme
        CHECK
        (
            MinEloSumme IS NULL
            OR MaxEloSumme IS NULL
            OR MinEloSumme <= MaxEloSumme
        ),

    CONSTRAINT CK_TurnierKategorie_SpielerProTeam
        CHECK
        (
            SpielerProTeam IS NULL
            OR SpielerProTeam > 0
        ),

    CONSTRAINT CK_TurnierKategorie_Gewinnsaetze
        CHECK
        (
            Gewinnsaetze IN (3,4)
        ),

    CONSTRAINT CK_TurnierKategorie_Status
        CHECK
        (
            Status IN
            (
                'GEPLANT',
                'OFFEN',
                'AUSGELOST',
                'LAUFEND',
                'BEENDET',
                'ABGESAGT'
            )
        )
);
GO
