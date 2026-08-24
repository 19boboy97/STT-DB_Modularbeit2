/*
    Rebuild-Test für STT-DB

    Erstellt eine frische Testdatenbank und baut
    alle Tabellen aus den einzelnen SQL-Dateien auf.

    WICHTIG:
    SQLCMD-Modus muss in SSMS aktiviert sein.
*/

USE master;
GO

IF DB_ID(N'STT_DB_REBUILD_TEST') IS NOT NULL
BEGIN
    ALTER DATABASE STT_DB_REBUILD_TEST
        SET SINGLE_USER
        WITH ROLLBACK IMMEDIATE;

    DROP DATABASE STT_DB_REBUILD_TEST;
END
GO

CREATE DATABASE STT_DB_REBUILD_TEST;
GO

USE STT_DB_REBUILD_TEST;
GO


:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\01_Saison.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\02_Verband.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\03_Alterskategorie.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\04_Klassierungsstufe.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\05_Club.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\06_Spielort.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\07_Spieler.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\08_SpielerSaison.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\09_SpielerVerein.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\10_Bewertungsperiode.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\11_Klassierungsgrenze.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\12_SpielerBewertung.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\13_EloMonatslauf.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\14_SpielerElo.sql"

-- 15 wird erst nach 37 erstellt, weil EloProtokoll
-- von Einzelspiel abhängig ist.

:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\16_Funktion.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\17_Vereinsfunktionaer.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\18_FunktionaerFunktion.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\19_Benutzer.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\20_Ball.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\21_Spielsystem.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\22_Ligawettbewerb.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\23_Ligaphase.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\24_Mannschaft.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\25_MannschaftSpieler.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\26_BenutzerMannschaft.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\27_Begegnung.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\28_Begegnungsaufstellung.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\29_Begegnungsbemerkung.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\30_BegegnungAenderung.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\31_Turnier.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\32_TurnierKategorie.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\33_Einzelanmeldung.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\34_Doppelanmeldung.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\35_Turniermannschaft.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\36_TurniermannschaftSpieler.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\37_Einzelspiel.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\38_Doppelspiel.sql"
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\39_Satz.sql"

-- Jetzt existiert dbo.Einzelspiel.
:r "C:\GithubRepo\STT-DB_Modularbeit2\sql\tables\15_EloProtokoll.sql"

PRINT '========================================';
PRINT 'STT-DB REBUILD ERFOLGREICH';
PRINT '========================================';
GO

SELECT
    COUNT(*) AS AnzahlTabellen
FROM sys.tables
WHERE schema_id = SCHEMA_ID('dbo');
GO

SELECT
    name AS Tabellenname
FROM sys.tables
WHERE schema_id = SCHEMA_ID('dbo')
ORDER BY name;
GO