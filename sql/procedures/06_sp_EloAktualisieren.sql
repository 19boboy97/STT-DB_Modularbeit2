/*
    Procedure: sp_EloAktualisieren

    Zweck:
    Verarbeitet die Elo-Auswirkung eines abgeschlossenen,
    Elo-relevanten Einzelspiels für genau einen Spieler.

    Voraussetzungen:
    - Einzelspiel existiert
    - Status = ABGESCHLOSSEN
    - Spielgrund = REGULAER oder AUFGABE
    - Spieler und Gegner sind im Einzelspiel enthalten
    - EloMonatslauf existiert
    - Elo-Werte sind nicht negativ
    - Gewinnwahrscheinlichkeit liegt zwischen 0 und 1

    Die Procedure:
    1. validiert das Einzelspiel
    2. schreibt einen Eintrag in EloProtokoll
    3. schreibt bzw. aktualisiert SpielerElo
*/

CREATE PROCEDURE dbo.sp_EloAktualisieren
    @EinzelspielID BIGINT,
    @LizenzNr INT,
    @EloMonatslaufID BIGINT,

    @StichtagsElo DECIMAL(10,3),
    @GegnerStichtagsElo DECIMAL(10,3),
    @Gewinnwahrscheinlichkeit DECIMAL(6,5),
    @VorschauElo DECIMAL(10,3),

    @HerrenStufenwert TINYINT,
    @DamenStufenwert TINYINT = NULL,

    @GueltigAb DATE
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        /*
            Einzelspiel prüfen.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Einzelspiel
            WHERE EinzelspielID = @EinzelspielID
        )
        BEGIN
            THROW 50501, 'Einzelspiel existiert nicht.', 1;
        END;


        /*
            Nur abgeschlossene Spiele dürfen Elo-relevant sein.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Einzelspiel
            WHERE EinzelspielID = @EinzelspielID
              AND Status = 'ABGESCHLOSSEN'
        )
        BEGIN
            THROW 50502, 'Einzelspiel ist nicht abgeschlossen.', 1;
        END;


        /*
            Elo-relevant sind nur REGULAER und AUFGABE.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Einzelspiel
            WHERE EinzelspielID = @EinzelspielID
              AND Spielgrund IN ('REGULAER', 'AUFGABE')
        )
        BEGIN
            THROW 50503, 'Einzelspiel ist nicht Elo-relevant.', 1;
        END;


        /*
            Spieler muss am Einzelspiel beteiligt sein.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Einzelspiel
            WHERE EinzelspielID = @EinzelspielID
              AND
              (
                  Spieler1Lizenz = @LizenzNr
                  OR Spieler2Lizenz = @LizenzNr
              )
        )
        BEGIN
            THROW 50504, 'Spieler ist nicht an diesem Einzelspiel beteiligt.', 1;
        END;


        /*
            Gegner bestimmen.
        */
        DECLARE @GegnerLizenzNr INT;

        SELECT
            @GegnerLizenzNr =
                CASE
                    WHEN Spieler1Lizenz = @LizenzNr
                        THEN Spieler2Lizenz
                    ELSE Spieler1Lizenz
                END
        FROM dbo.Einzelspiel
        WHERE EinzelspielID = @EinzelspielID;


        IF @GegnerLizenzNr IS NULL
        BEGIN
            THROW 50505, 'Fuer dieses Einzelspiel konnte kein Gegner bestimmt werden.', 1;
        END;


        /*
            Monatslauf prüfen.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.EloMonatslauf
            WHERE EloMonatslaufID = @EloMonatslaufID
        )
        BEGIN
            THROW 50506, 'EloMonatslauf existiert nicht.', 1;
        END;


        /*
            Elo-Werte prüfen.
        */
        IF @StichtagsElo < 0
           OR @GegnerStichtagsElo < 0
           OR @VorschauElo < 0
        BEGIN
            THROW 50507, 'Elo-Werte duerfen nicht negativ sein.', 1;
        END;


        /*
            Gewinnwahrscheinlichkeit prüfen.
        */
        IF @Gewinnwahrscheinlichkeit < 0
           OR @Gewinnwahrscheinlichkeit > 1
        BEGIN
            THROW 50508, 'Gewinnwahrscheinlichkeit muss zwischen 0 und 1 liegen.', 1;
        END;


        /*
            Herrenklassierung prüfen.
        */
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Klassierungsstufe
            WHERE Stufenwert = @HerrenStufenwert
        )
        BEGIN
            THROW 50509, 'HerrenStufenwert existiert nicht.', 1;
        END;


        /*
            Damenklassierung prüfen, falls gesetzt.
        */
        IF @DamenStufenwert IS NOT NULL
           AND NOT EXISTS
           (
               SELECT 1
               FROM dbo.Klassierungsstufe
               WHERE Stufenwert = @DamenStufenwert
           )
        BEGIN
            THROW 50510, 'DamenStufenwert existiert nicht.', 1;
        END;


        /*
            Derselbe Spieler darf für dasselbe Einzelspiel
            nur einmal im EloProtokoll verarbeitet werden.
        */
        IF EXISTS
        (
            SELECT 1
            FROM dbo.EloProtokoll
            WHERE EinzelspielID = @EinzelspielID
              AND LizenzNr = @LizenzNr
        )
        BEGIN
            THROW 50511, 'Elo fuer diesen Spieler und dieses Einzelspiel wurde bereits verarbeitet.', 1;
        END;


        BEGIN TRANSACTION;


        /*
            Elo-Protokoll schreiben.
        */
        INSERT INTO dbo.EloProtokoll
        (
            EinzelspielID,
            LizenzNr,
            GegnerLizenzNr,
            EloMonatslaufID,
            StichtagsElo,
            GegnerStichtagsElo,
            Gewinnwahrscheinlichkeit,
            VorschauElo
        )
        VALUES
        (
            @EinzelspielID,
            @LizenzNr,
            @GegnerLizenzNr,
            @EloMonatslaufID,
            @StichtagsElo,
            @GegnerStichtagsElo,
            @Gewinnwahrscheinlichkeit,
            @VorschauElo
        );


        /*
            Elo-Differenz zum Ausgangswert berechnen.
        */
        DECLARE @EloDelta DECIMAL(10,3);

        SET @EloDelta = @VorschauElo - @StichtagsElo;


        /*
            Falls für Spieler + Monatslauf bereits ein Datensatz
            existiert, aktualisieren wir ihn.
            Ansonsten wird er neu angelegt.
        */
        IF EXISTS
        (
            SELECT 1
            FROM dbo.SpielerElo
            WHERE LizenzNr = @LizenzNr
              AND EloMonatslaufID = @EloMonatslaufID
        )
        BEGIN
            UPDATE dbo.SpielerElo
            SET
                Elo = @VorschauElo,
                EloDeltaZumVormonat = @EloDelta,
                HerrenStufenwert = @HerrenStufenwert,
                DamenStufenwert = @DamenStufenwert,
                GueltigAb = @GueltigAb
            WHERE LizenzNr = @LizenzNr
              AND EloMonatslaufID = @EloMonatslaufID;
        END
        ELSE
        BEGIN
            INSERT INTO dbo.SpielerElo
            (
                LizenzNr,
                EloMonatslaufID,
                Elo,
                EloDeltaZumVormonat,
                HerrenStufenwert,
                DamenStufenwert,
                HerrenRang,
                Gesamtrang,
                GueltigAb,
                GueltigBis
            )
            VALUES
            (
                @LizenzNr,
                @EloMonatslaufID,
                @VorschauElo,
                @EloDelta,
                @HerrenStufenwert,
                @DamenStufenwert,
                NULL,
                NULL,
                @GueltigAb,
                NULL
            );
        END;


        COMMIT TRANSACTION;


        /*
            Ergebnis zurückgeben.
        */
        SELECT
            ep.EloProtokollID,
            ep.EinzelspielID,
            ep.LizenzNr,
            ep.GegnerLizenzNr,
            ep.EloMonatslaufID,
            ep.StichtagsElo,
            ep.GegnerStichtagsElo,
            ep.Gewinnwahrscheinlichkeit,
            ep.VorschauElo,

            se.SpielerEloID,
            se.Elo,
            se.EloDeltaZumVormonat,
            se.HerrenStufenwert,
            se.DamenStufenwert,
            se.GueltigAb,
            se.GueltigBis

        FROM dbo.EloProtokoll AS ep

        INNER JOIN dbo.SpielerElo AS se
            ON se.LizenzNr = ep.LizenzNr
           AND se.EloMonatslaufID = ep.EloMonatslaufID

        WHERE ep.EinzelspielID = @EinzelspielID
          AND ep.LizenzNr = @LizenzNr;


    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO