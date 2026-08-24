/*
    Procedure: sp_BegegnungResultatErfassen

    Zweck:
    Erfasst das Resultat einer bestehenden Begegnung
    und setzt deren Status auf ABGESCHLOSSEN.

    Eine bereits genehmigte oder annullierte Begegnung
    darf nicht mehr über diese Procedure verändert werden.
*/

CREATE PROCEDURE dbo.sp_BegegnungResultatErfassen
    @BegegnungID BIGINT,

    @SiegeHeim TINYINT,
    @SiegeGast TINYINT,

    @MannschaftspunkteHeim TINYINT,
    @MannschaftspunkteGast TINYINT,

    @SaetzeHeim SMALLINT = NULL,
    @SaetzeGast SMALLINT = NULL,

    @BaelleHeim SMALLINT = NULL,
    @BaelleGast SMALLINT = NULL,

    @Endzeit TIME(0) = NULL,
    @ZuschauerAnzahl SMALLINT = NULL,
    @SchiedsrichterName NVARCHAR(150) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        /*
            Begegnung muss existieren.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Begegnung
            WHERE BegegnungID = @BegegnungID
        )
        BEGIN
            THROW 50301, 'Begegnung existiert nicht.', 1;
        END;


        /*
            Bereits genehmigte Begegnungen dürfen
            nicht mehr auf diesem Weg geändert werden.
        */
        IF EXISTS
        (
            SELECT 1
            FROM dbo.Begegnung
            WHERE BegegnungID = @BegegnungID
              AND Status = 'GENEHMIGT'
        )
        BEGIN
            THROW 50302, 'Eine genehmigte Begegnung darf nicht mehr direkt geaendert werden.', 1;
        END;


        /*
            Annullierte Begegnungen dürfen kein Resultat erhalten.
        */
        IF EXISTS
        (
            SELECT 1
            FROM dbo.Begegnung
            WHERE BegegnungID = @BegegnungID
              AND Status = 'ANNULLIERT'
        )
        BEGIN
            THROW 50303, 'Fuer eine annullierte Begegnung kann kein Resultat erfasst werden.', 1;
        END;


        /*
            Siege prüfen.
            Die Tabelle erlaubt maximal 10 pro Seite.
        */
        IF @SiegeHeim > 10 OR @SiegeGast > 10
        BEGIN
            THROW 50304, 'SiegeHeim und SiegeGast muessen zwischen 0 und 10 liegen.', 1;
        END;


        /*
            Mannschaftspunkte prüfen.
        */
        IF @MannschaftspunkteHeim > 4
           OR @MannschaftspunkteGast > 4
        BEGIN
            THROW 50305, 'Mannschaftspunkte muessen zwischen 0 und 4 liegen.', 1;
        END;


        /*
            Satzwerte dürfen nicht negativ sein.
        */
        IF @SaetzeHeim IS NOT NULL
           AND @SaetzeHeim < 0
        BEGIN
            THROW 50306, 'SaetzeHeim darf nicht negativ sein.', 1;
        END;

        IF @SaetzeGast IS NOT NULL
           AND @SaetzeGast < 0
        BEGIN
            THROW 50307, 'SaetzeGast darf nicht negativ sein.', 1;
        END;


        /*
            Ballwerte dürfen nicht negativ sein.
        */
        IF @BaelleHeim IS NOT NULL
           AND @BaelleHeim < 0
        BEGIN
            THROW 50308, 'BaelleHeim darf nicht negativ sein.', 1;
        END;

        IF @BaelleGast IS NOT NULL
           AND @BaelleGast < 0
        BEGIN
            THROW 50309, 'BaelleGast darf nicht negativ sein.', 1;
        END;


        /*
            Zuschauerzahl darf nicht negativ sein.
        */
        IF @ZuschauerAnzahl IS NOT NULL
           AND @ZuschauerAnzahl < 0
        BEGIN
            THROW 50310, 'ZuschauerAnzahl darf nicht negativ sein.', 1;
        END;


        /*
            Endzeit darf nicht vor Startzeit liegen.
        */
        IF @Endzeit IS NOT NULL
           AND EXISTS
           (
               SELECT 1
               FROM dbo.Begegnung
               WHERE BegegnungID = @BegegnungID
                 AND @Endzeit < Startzeit
           )
        BEGIN
            THROW 50311, 'Endzeit darf nicht vor der Startzeit liegen.', 1;
        END;


        /*
            Anzahl Siege darf die maximale Anzahl Spiele
            des verwendeten Spielsystems nicht überschreiten.
        */
        DECLARE @MaxAnzahlSpiele TINYINT;

        SELECT
            @MaxAnzahlSpiele = ss.MaxAnzahlSpiele
        FROM dbo.Begegnung AS b
        INNER JOIN dbo.Ligaphase AS lp
            ON lp.LigaphaseID = b.LigaphaseID
        INNER JOIN dbo.Ligawettbewerb AS lw
            ON lw.LigawettbewerbID = lp.LigawettbewerbID
        INNER JOIN dbo.Spielsystem AS ss
            ON ss.SpielsystemID = lw.SpielsystemID
        WHERE b.BegegnungID = @BegegnungID;


        IF @MaxAnzahlSpiele IS NOT NULL
           AND (@SiegeHeim + @SiegeGast) > @MaxAnzahlSpiele
        BEGIN
            THROW 50312, 'Die Anzahl Siege uebersteigt die maximale Anzahl Spiele des Spielsystems.', 1;
        END;


        BEGIN TRANSACTION;


        UPDATE dbo.Begegnung
        SET
            SiegeHeim = @SiegeHeim,
            SiegeGast = @SiegeGast,

            MannschaftspunkteHeim = @MannschaftspunkteHeim,
            MannschaftspunkteGast = @MannschaftspunkteGast,

            SaetzeHeim = @SaetzeHeim,
            SaetzeGast = @SaetzeGast,

            BaelleHeim = @BaelleHeim,
            BaelleGast = @BaelleGast,

            Endzeit = @Endzeit,
            ZuschauerAnzahl = @ZuschauerAnzahl,
            SchiedsrichterName = @SchiedsrichterName,

            Status = 'ABGESCHLOSSEN'

        WHERE BegegnungID = @BegegnungID;


        COMMIT TRANSACTION;


        /*
            Aktualisierte Begegnung zurückgeben.
        */
        SELECT
            BegegnungID,
            LigaphaseID,
            HeimMannschaftID,
            GastMannschaftID,
            Datum,
            Startzeit,
            Endzeit,

            SiegeHeim,
            SiegeGast,

            MannschaftspunkteHeim,
            MannschaftspunkteGast,

            SaetzeHeim,
            SaetzeGast,

            BaelleHeim,
            BaelleGast,

            ZuschauerAnzahl,
            SchiedsrichterName,

            MatchblattGenehmigt,
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