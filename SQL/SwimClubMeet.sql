USE [SwimClubMeet2]
go

-- Standard Alter Table SQL

ALTER TABLE dbo.ScoreDivision DROP CONSTRAINT FK_ScoreDivision
go
ALTER TABLE dbo.ScoreDivision DROP COLUMN SwimClubID
go
ALTER TABLE dbo.ScorePoints DROP CONSTRAINT FK_ScorePoints
go
ALTER TABLE dbo.ScorePoints DROP COLUMN SwimClubID
go
