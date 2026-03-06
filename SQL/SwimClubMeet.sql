USE [SwimClubMeet2]
go

-- Standard Alter Table SQL

EXEC sp_rename 'dbo.PoolType.PK_QualifyType','PK_PoolType','INDEX'
go
ALTER TABLE dbo.QualifyTime DROP CONSTRAINT FK_QualifyType
go
EXEC sp_rename 'dbo.QualifyTime.QualifyTypeID', 'PoolTypeID','COLUMN'
go
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'table', 'QualifyTime', default, default))
BEGIN
  exec sys.sp_dropextendedproperty 'MS_Description', 'schema', 'dbo', 'table', 'QualifyTime'
END
exec sys.sp_addextendedproperty 'MS_Description', 'Qualifying Times:
For a swimmer to compete in an event of said distance and stroke they must have swum the stoke in a (shorter) distance within a given time.', 'schema', 'dbo', 'table', 'QualifyTime'
go
ALTER TABLE dbo.SwimClub DROP CONSTRAINT FK_QualifyTypeSC
go
EXEC sp_rename 'dbo.SwimClub.QualifyTypeID', 'PoolTypeID','COLUMN'
go
ALTER TABLE dbo.QualifyTime ADD CONSTRAINT FK_QualifyType
FOREIGN KEY (PoolTypeID)
REFERENCES dbo.PoolType (PoolTypeID)
go
ALTER TABLE dbo.SwimClub ADD CONSTRAINT FK_PoolType
FOREIGN KEY (PoolTypeID)
REFERENCES dbo.PoolType (PoolTypeID)
go
