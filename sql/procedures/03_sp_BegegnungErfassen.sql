/*
    Procedure: sp_BegegnungErfassen

    Zweck:
    Erstellt eine neue Ligabegegnung.

    Vor dem INSERT werden die wichtigsten
    fachlichen Voraussetzungen geprüft.
*/

CREATE PROCEDURE dbo.sp_BegegnungErfassen
    @LigaphaseID INT,
    @HeimMannschaftID INT,
    @GastMannschaftID INT,
    @SpielortID INT,
    @Runde TINYINT = NULL,
    @Datum DATE,
    @Startzeit TIME(0),
    @Status VARCHAR(20) = 'GEPLANT'
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        /*
            Ligaphase prüfen.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Ligaphase
            WHERE LigaphaseID = @LigaphaseID
        )
        BEGIN
            THROW 50201, 'Ligaphase existiert nicht.', 1;
        END;


        /*
            Heimmannschaft prüfen.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Mannschaft
            WHERE MannschaftID = @HeimMannschaftID
        )
        BEGIN
            THROW 50202, 'Heimmannschaft existiert nicht.', 1;
        END;


        /*
            Gastmannschaft prüfen.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Mannschaft
            WHERE MannschaftID = @GastMannschaftID
        )
        BEGIN
            THROW 50203, 'Gastmannschaft existiert nicht.', 1;
        END;


        /*
            Heim und Gast dürfen nicht identisch sein.
        */
        IF @HeimMannschaftID = @GastMannschaftID
        BEGIN
            THROW 50204, 'Heim- und Gastmannschaft muessen verschieden sein.', 1;
        END;


        /*
            Heimmannschaft muss zur Ligaphase gehören.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Mannschaft
            WHERE MannschaftID = @HeimMannschaftID
              AND LigaphaseID = @LigaphaseID
        )
        BEGIN
            THROW 50205, 'Heimmannschaft gehoert nicht zur angegebenen Ligaphase.', 1;
        END;


        /*
            Gastmannschaft muss zur Ligaphase gehören.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Mannschaft
            WHERE MannschaftID = @GastMannschaftID
              AND LigaphaseID = @LigaphaseID
        )
        BEGIN
            THROW 50206, 'Gastmannschaft gehoert nicht zur angegebenen Ligaphase.', 1;
        END;


        /*
            Spielort prüfen.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Spielort
            WHERE SpielortID = @SpielortID
        )
        BEGIN
            THROW 50207, 'Spielort existiert nicht.', 1;
        END;


        /*
            Runde prüfen.
        */
        IF @Runde IS NOT NULL
           AND @Runde = 0
        BEGIN
            THROW 50208, 'Runde muss groesser als 0 sein.', 1;
        END;


        /*
            Status prüfen.
        */
        IF @Status NOT IN
        (
            'GEPLANT',
            'LAUFEND',
            'ABGESCHLOSSEN',
            'GENEHMIGT',
            'ANNULLIERT'
        )
        BEGIN
            THROW 50209, 'Ungueltiger Begegnungsstatus.', 1;
        END;


        /*
            Beim Erfassen einer neuen Begegnung soll
            GENEHMIGT noch nicht direkt gesetzt werden.
        */
        IF @Status = 'GENEHMIGT'
        BEGIN
            THROW 50210, 'Eine neue Begegnung kann nicht direkt genehmigt erstellt werden.', 1;
        END;


        BEGIN TRANSACTION;


        INSERT INTO dbo.Begegnung
        (
            LigaphaseID,
            HeimMannschaftID,
            GastMannschaftID,
            SpielortID,
            Runde,
            Datum,
            Startzeit,
            Status
        )
        VALUES
        (
            @LigaphaseID,
            @HeimMannschaftID,
            @GastMannschaftID,
            @SpielortID,
            @Runde,
            @Datum,
            @Startzeit,
            @Status
        );

        DECLARE @BegegnungID BIGINT = SCOPE_IDENTITY();


        COMMIT TRANSACTION;


        SELECT
            BegegnungID,
            LigaphaseID,
            HeimMannschaftID,
            GastMannschaftID,
            SpielortID,
            Runde,
            Datum,
            Startzeit,
            Status
        FROM dbo.Begegnung
        WHERE BegegnungID = @BegegnungID;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO