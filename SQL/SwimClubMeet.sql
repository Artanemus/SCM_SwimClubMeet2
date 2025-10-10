USE [SwimClubMeet2]
go

-- Standard Alter Table SQL

ALTER TABLE dbo.Distance DROP CONSTRAINT EventTpeDistance
go
ALTER TABLE dbo.Distance DROP COLUMN EventTypeID
go
