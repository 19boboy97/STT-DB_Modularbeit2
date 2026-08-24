/*
    Procedure: sp_SpielerAnmelden

    Zweck:
    Meldet einen bestehenden Spieler für eine Saison an
    und ordnet ihn einem Verein zu.

    Die Procedure erstellt:
    - SpielerSaison
    - SpielerVerein

    Beide Schritte laufen innerhalb einer Transaktion.
*/

CREATE PROCEDURE dbo.sp_SpielerAnmelden
    @LizenzNr INT,
    @SaisonID INT,
    @Alterskategorie VARCHAR(10),
    @VereinsNr INT,
    @Zuordnungsart VARCHAR(20) = 'HAUPTVEREIN',
    @Wettbewerbsbereich VARCHAR(20) = 'ALLE',
    @LizenzAktiv BIT = 1
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
            THROW 50001, 'Spieler existiert nicht.', 1;
        END;


        /*
            Saison prüfen.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Saison
            WHERE SaisonID = @SaisonID
        )
        BEGIN
            THROW 50002, 'Saison existiert nicht.', 1;
        END;


        /*
            Club prüfen.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Club
            WHERE VereinsNr = @VereinsNr
        )
        BEGIN
            THROW 50003, 'Club existiert nicht.', 1;
        END;


        /*
            Alterskategorie prüfen.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Alterskategorie
            WHERE Bezeichnung = @Alterskategorie
        )
        BEGIN
            THROW 50004, 'Alterskategorie existiert nicht.', 1;
        END;


        /*
            Doppelte Saisonanmeldung verhindern.
        */
        IF EXISTS
        (
            SELECT 1
            FROM dbo.SpielerSaison
            WHERE LizenzNr = @LizenzNr
              AND SaisonID = @SaisonID
        )
        BEGIN
            THROW 50005, 'Spieler ist fuer diese Saison bereits angemeldet.', 1;
        END;


        BEGIN TRANSACTION;


        INSERT INTO dbo.SpielerSaison
        (
            LizenzNr,
            SaisonID,
            Alterskategorie,
            LizenzAktiv
        )
        VALUES
        (
            @LizenzNr,
            @SaisonID,
            @Alterskategorie,
            @LizenzAktiv
        );


        INSERT INTO dbo.SpielerVerein
        (
            LizenzNr,
            SaisonID,
            VereinsNr,
            Zuordnungsart,
            Wettbewerbsbereich
        )
        VALUES
        (
            @LizenzNr,
            @SaisonID,
            @VereinsNr,
            @Zuordnungsart,
            @Wettbewerbsbereich
        );


        COMMIT TRANSACTION;


        /*
            Ergebnis zurückgeben.
        */
        SELECT
            @LizenzNr AS LizenzNr,
            @SaisonID AS SaisonID,
            @VereinsNr AS VereinsNr,
            @Alterskategorie AS Alterskategorie,
            @Zuordnungsart AS Zuordnungsart,
            @Wettbewerbsbereich AS Wettbewerbsbereich,
            @LizenzAktiv AS LizenzAktiv;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO