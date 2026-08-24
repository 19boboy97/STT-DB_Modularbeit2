/*
    Procedure: sp_MannschaftSpielerHinzufuegen

    Zweck:
    Fuegt einen Spieler einer Ligamannschaft hinzu.

    Meldungsarten:
    - STAMMSPIELER
    - ERSATZSPIELER
*/

CREATE PROCEDURE dbo.sp_MannschaftSpielerHinzufuegen
    @MannschaftID INT,
    @LizenzNr INT,
    @Meldungsart VARCHAR(20),
    @StammPosition TINYINT = NULL,
    @Spielberechtigt BIT = 1,
    @Bemerkung NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        /*
            Mannschaft pruefen.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Mannschaft
            WHERE MannschaftID = @MannschaftID
        )
        BEGIN
            THROW 50101, 'Mannschaft existiert nicht.', 1;
        END;


        /*
            Spieler pruefen.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Spieler
            WHERE LizenzNr = @LizenzNr
        )
        BEGIN
            THROW 50102, 'Spieler existiert nicht.', 1;
        END;


        /*
            Meldungsart pruefen.
        */
        IF @Meldungsart NOT IN ('STAMMSPIELER', 'ERSATZSPIELER')
        BEGIN
            THROW 50103, 'Ungueltige Meldungsart.', 1;
        END;


        /*
            Stammspieler brauchen Position 1 bis 3.
        */
        IF @Meldungsart = 'STAMMSPIELER'
           AND
           (
               @StammPosition IS NULL
               OR @StammPosition NOT BETWEEN 1 AND 3
           )
        BEGIN
            THROW 50104, 'Stammspieler benoetigen eine StammPosition zwischen 1 und 3.', 1;
        END;


        /*
            Ersatzspieler duerfen keine StammPosition haben.
        */
        IF @Meldungsart = 'ERSATZSPIELER'
           AND @StammPosition IS NOT NULL
        BEGIN
            THROW 50105, 'Ersatzspieler duerfen keine StammPosition besitzen.', 1;
        END;


        /*
            Doppelte Zuordnung verhindern.
        */
        IF EXISTS
        (
            SELECT 1
            FROM dbo.MannschaftSpieler
            WHERE MannschaftID = @MannschaftID
              AND LizenzNr = @LizenzNr
        )
        BEGIN
            THROW 50106, 'Spieler ist dieser Mannschaft bereits zugeordnet.', 1;
        END;


        BEGIN TRANSACTION;


        INSERT INTO dbo.MannschaftSpieler
        (
            MannschaftID,
            LizenzNr,
            Meldungsart,
            StammPosition,
            Spielberechtigt,
            Bemerkung
        )
        VALUES
        (
            @MannschaftID,
            @LizenzNr,
            @Meldungsart,
            @StammPosition,
            @Spielberechtigt,
            @Bemerkung
        );


        COMMIT TRANSACTION;


        SELECT
            MannschaftSpielerID,
            MannschaftID,
            LizenzNr,
            Meldungsart,
            StammPosition,
            Spielberechtigt,
            Bemerkung
        FROM dbo.MannschaftSpieler
        WHERE MannschaftID = @MannschaftID
          AND LizenzNr = @LizenzNr;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO