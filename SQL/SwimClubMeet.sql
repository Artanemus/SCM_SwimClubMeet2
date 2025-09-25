USE [SwimClubMeet2]
go

-- Standard Alter Table SQL

ALTER TABLE dbo.SwimClubGroup DROP CONSTRAINT PK_ClubGroup
go
ALTER TABLE dbo.SwimClubGroup
ALTER COLUMN ChildClubID int NOT NULL
go
ALTER TABLE dbo.SwimClubGroup ADD CONSTRAINT PK_ClubGroup
PRIMARY KEY CLUSTERED (SwimClubGroupID,ParentClubID,ChildClubID)
go
EXEC sp_rename 'dbo.FK_SwimClubGroup','FK_ParentClub'
go
ALTER TABLE dbo.SwimClubGroup ADD CONSTRAINT FK_ChildClub
FOREIGN KEY (ChildClubID)
REFERENCES dbo.SwimClub (SwimClubID)
go
