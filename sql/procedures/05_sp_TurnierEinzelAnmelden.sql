/*
    Procedure: sp_TurnierEinzelAnmelden

    Zweck:
    Meldet einen Spieler zu einer Einzelkategorie
    eines Turniers an.

    Geprüft werden:
    - Spieler existiert und ist aktiv
    - Turnierkategorie existiert
    - Kategorie ist eine EINZEL-Kategorie
    - Kategorie ist OFFEN
    - Turnier ist OFFEN
    - Meldeschluss ist noch nicht überschritten
    - Spieler ist noch nicht angemeldet
*/

CREATE PROCEDURE dbo.sp_TurnierEinzelAnmelden
    @TurnierKategorieID INT,
    @LizenzNr INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        /*
            Spieler prüfen.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Spieler
            WHERE LizenzNr = @LizenzNr
        )
        BEGIN
            THROW 50401, 'Spieler existiert nicht.', 1;
        END;


        /*
            Spieler muss aktiv sein.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Spieler
            WHERE LizenzNr = @LizenzNr
              AND Aktiv = 1
        )
        BEGIN
            THROW 50402, 'Spieler ist nicht aktiv.', 1;
        END;


        /*
            Turnierkategorie prüfen.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.TurnierKategorie
            WHERE TurnierKategorieID = @TurnierKategorieID
        )
        BEGIN
            THROW 50403, 'Turnierkategorie existiert nicht.', 1;
        END;


        /*
            Nur EINZEL-Kategorien sind erlaubt.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.TurnierKategorie
            WHERE TurnierKategorieID = @TurnierKategorieID
              AND Wettkampfform = 'EINZEL'
        )
        BEGIN
            THROW 50404, 'Die Turnierkategorie ist keine Einzelkategorie.', 1;
        END;


        /*
            Kategorie muss offen sein.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.TurnierKategorie
            WHERE TurnierKategorieID = @TurnierKategorieID
              AND Status = 'OFFEN'
        )
        BEGIN
            THROW 50405, 'Die Turnierkategorie ist nicht offen.', 1;
        END;


        /*
            Turnier muss offen sein.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.TurnierKategorie AS tk
            INNER JOIN dbo.Turnier AS t
                ON t.TurnierID = tk.TurnierID
            WHERE tk.TurnierKategorieID = @TurnierKategorieID
              AND t.Status = 'OFFEN'
        )
        BEGIN
            THROW 50406, 'Das Turnier ist nicht offen.', 1;
        END;


        /*
            Meldeschluss prüfen.
        */
        IF EXISTS
        (
            SELECT 1
            FROM dbo.TurnierKategorie AS tk
            INNER JOIN dbo.Turnier AS t
                ON t.TurnierID = tk.TurnierID
            WHERE tk.TurnierKategorieID = @TurnierKategorieID
              AND SYSDATETIME() > t.Meldeschluss
        )
        BEGIN
            THROW 50407, 'Der Meldeschluss ist bereits abgelaufen.', 1;
        END;


        /*
            Doppelte Anmeldung verhindern.
        */
        IF EXISTS
        (
            SELECT 1
            FROM dbo.Einzelanmeldung
            WHERE TurnierKategorieID = @TurnierKategorieID
              AND LizenzNr = @LizenzNr
        )
        BEGIN
            THROW 50408, 'Spieler ist fuer diese Kategorie bereits angemeldet.', 1;
        END;


        BEGIN TRANSACTION;


        INSERT INTO dbo.Einzelanmeldung
        (
            TurnierKategorieID,
            LizenzNr,
            Status
        )
        VALUES
        (
            @TurnierKategorieID,
            @LizenzNr,
            'ANGEMELDET'
        );


        DECLARE @EinzelanmeldungID BIGINT = SCOPE_IDENTITY();


        COMMIT TRANSACTION;


        SELECT
            ea.EinzelanmeldungID,
            ea.TurnierKategorieID,
            tk.Bezeichnung AS Kategorie,
            ea.LizenzNr,
            s.Vorname,
            s.Nachname,
            ea.Anmeldedatum,
            ea.Status,
            ea.Ablehnungsgrund
        FROM dbo.Einzelanmeldung AS ea

        INNER JOIN dbo.TurnierKategorie AS tk
            ON tk.TurnierKategorieID = ea.TurnierKategorieID

        INNER JOIN dbo.Spieler AS s
            ON s.LizenzNr = ea.LizenzNr

        WHERE ea.EinzelanmeldungID = @EinzelanmeldungID;


    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO