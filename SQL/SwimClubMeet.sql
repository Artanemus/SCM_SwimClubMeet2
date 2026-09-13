USE [SwimClubMeet2]
go

-- Standard Alter Table SQL

ALTER TABLE dbo.Report ADD DEFAULT (NULL) FOR BlobCreatedOn
go
ALTER TABLE dbo.Report ADD DEFAULT (NULL) FOR BlobModifiedOn
go
