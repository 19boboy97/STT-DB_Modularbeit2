/*
    Projekt:        STT-DB Modulararbeit II
    Datei:          00_CreateDatabase.sql
    Beschreibung:   Erstellt die Datenbank für das
                    Swiss-Table-Tennis-Demonstrationsprojekt.
*/

USE master;
GO

IF DB_ID(N'STT_DB') IS NULL
BEGIN
    CREATE DATABASE STT_DB;
END;
GO

USE STT_DB;
GO