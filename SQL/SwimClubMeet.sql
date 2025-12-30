USE [SwimClubMeet2]
go

-- Dictionary Object Alter SQL

CREATE DEFAULT dbo.Def_TIME AS (NULL)
go
EXEC sp_bindefault 'dbo.Def_TIME', 'dbo.SplitTime.Time'
go
EXEC sp_bindefault 'dbo.Def_TIME', 'dbo.PB.RaceTime'
go
EXEC sp_bindefault 'dbo.Def_TIME', 'dbo.WatchTime.Time'
go

-- Standard Alter Table SQL

ALTER TABLE dbo.Team ADD DEFAULT (NULL) FOR ABREV
go
ALTER TABLE dbo.Team ADD DEFAULT (NULL) FOR TTB
go
ALTER TABLE dbo.Team ADD PB time(7)  DEFAULT (NULL) NULL
go
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'table', 'Team', 'column', 'PB'))
BEGIN
  exec sys.sp_dropextendedproperty 'MS_Description', 'schema', 'dbo', 'table', 'Team', 'column', 'PB'
END
exec sys.sp_addextendedproperty 'MS_Description', 'RaceTime, PB, TTB, SeedTime all use MS SQLEXPRESS TIME variable', 'schema', 'dbo', 'table', 'Team', 'column', 'PB'
go
ALTER TABLE dbo.Team ADD SeedTime time(7)  DEFAULT (NULL) NULL
go
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'table', 'Team', 'column', 'SeedTime'))
BEGIN
  exec sys.sp_dropextendedproperty 'MS_Description', 'schema', 'dbo', 'table', 'Team', 'column', 'SeedTime'
END
exec sys.sp_addextendedproperty 'MS_Description', 'RaceTime, PB, TTB, SeedTime all use MS SQLEXPRESS TIME variable', 'schema', 'dbo', 'table', 'Team', 'column', 'SeedTime'
go
ALTER TABLE dbo.Team ADD AutoBuildFlag bit  NULL
go
