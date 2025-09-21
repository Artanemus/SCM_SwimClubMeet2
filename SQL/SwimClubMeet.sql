USE [SwimClubMeet2]
go

-- Drop Referencing Constraint SQL

ALTER TABLE dbo.Lane DROP CONSTRAINT FK_LaneNominee
go
ALTER TABLE dbo.TeamLink DROP CONSTRAINT FK_NomineeTeamLink
go

-- Drop Constraint, Rename and Create Table SQL

EXEC sp_rename 'dbo.Nominee.PK_Nominee','PK_Nominee_09212025002134001','INDEX'
go
EXEC sp_rename 'dbo.EventNominee','EventNomin_09212025002134002'
go
EXEC sp_rename 'dbo.FK_MemberLinkNominee','FK_MemberL_09212025002134003'
go
EXEC sp_rename 'dbo.Def_SeedTime', 'Def_SeedTi_09212025002134004',OBJECT
go
EXEC sp_rename 'dbo.Def_IsEntrant', 'Def_IsEntr_09212025002134005',OBJECT
go
EXEC sp_rename 'dbo.Def_PB', 'Def_PB_09212025002134006',OBJECT
go
EXEC sp_rename 'dbo.Def_TTB', 'Def_TTB_09212025002134007',OBJECT
go
EXEC sp_rename 'dbo.Nominee','Nominee_09212025002134000',OBJECT
go
CREATE TABLE dbo.Nominee
(
    NomineeID     int      IDENTITY,
    AGE           int      NULL,
    TTB           time(7)  CONSTRAINT Def_TTB DEFAULT (NULL) NULL,
    PB            time(7)  CONSTRAINT Def_PB DEFAULT (NULL) NULL,
    IsEntrant     bit      CONSTRAINT Def_IsEntrant DEFAULT ((0))  NOT NULL,
    SeedTime      time(7)  CONSTRAINT Def_SeedTime DEFAULT (NULL) NULL,
    AutoBuildFlag bit      NULL,
    EventID       int      NULL,
    MemberID      int      NULL
)
ON [PRIMARY]
go
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'table', 'Nominee', 'column', 'TTB'))
BEGIN
  exec sys.sp_dropextendedproperty 'MS_Description', 'schema', 'dbo', 'table', 'Nominee', 'column', 'TTB'
END
exec sys.sp_addextendedproperty 'MS_Description', 'RaceTime, PB, TTB, SeedTime all use MS SQLEXPRESS TIME variable', 'schema', 'dbo', 'table', 'Nominee', 'column', 'TTB'
go
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'table', 'Nominee', 'column', 'PB'))
BEGIN
  exec sys.sp_dropextendedproperty 'MS_Description', 'schema', 'dbo', 'table', 'Nominee', 'column', 'PB'
END
exec sys.sp_addextendedproperty 'MS_Description', 'RaceTime, PB, TTB, SeedTime all use MS SQLEXPRESS TIME variable', 'schema', 'dbo', 'table', 'Nominee', 'column', 'PB'
go
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'table', 'Nominee', 'column', 'SeedTime'))
BEGIN
  exec sys.sp_dropextendedproperty 'MS_Description', 'schema', 'dbo', 'table', 'Nominee', 'column', 'SeedTime'
END
exec sys.sp_addextendedproperty 'MS_Description', 'RaceTime, PB, TTB, SeedTime all use MS SQLEXPRESS TIME variable', 'schema', 'dbo', 'table', 'Nominee', 'column', 'SeedTime'
go
GRANT DELETE ON dbo.Nominee TO SCM_Administrator
go
GRANT INSERT ON dbo.Nominee TO SCM_Administrator
go
GRANT SELECT ON dbo.Nominee TO SCM_Administrator
go
GRANT UPDATE ON dbo.Nominee TO SCM_Administrator
go
GRANT SELECT ON dbo.Nominee TO SCM_Guest
go
GRANT DELETE ON dbo.Nominee TO SCM_Marshall
go
GRANT INSERT ON dbo.Nominee TO SCM_Marshall
go
GRANT SELECT ON dbo.Nominee TO SCM_Marshall
go
GRANT UPDATE ON dbo.Nominee TO SCM_Marshall
go

-- Insert Data SQL

SET IDENTITY_INSERT dbo.Nominee ON
go
INSERT INTO dbo.Nominee(
                        NomineeID,
                        AGE,
                        TTB,
                        PB,
                        IsEntrant,
                        SeedTime,
                        AutoBuildFlag,
                        EventID,
                        MemberID
                       )
                 SELECT 
                        NomineeID,
                        AGE,
                        TTB,
                        PB,
                        IsEntrant,
                        SeedTime,
                        AutoBuildFlag,
                        EventID,
                        NULL
                   FROM dbo.Nominee_09212025002134000 
go
SET IDENTITY_INSERT dbo.Nominee OFF
go

-- Add Constraint SQL

ALTER TABLE dbo.Nominee ADD CONSTRAINT PK_Nominee
PRIMARY KEY CLUSTERED (NomineeID)
go

-- Add Referencing Foreign Keys SQL

ALTER TABLE dbo.Lane ADD CONSTRAINT FK_LaneNominee
FOREIGN KEY (NomineeID)
REFERENCES dbo.Nominee (NomineeID)
go
ALTER TABLE dbo.TeamLink ADD CONSTRAINT FK_NomineeTeamLink
FOREIGN KEY (NomineeID)
REFERENCES dbo.Nominee (NomineeID)
go
ALTER TABLE dbo.Nominee ADD CONSTRAINT EventNominee
FOREIGN KEY (EventID)
REFERENCES dbo.Event (EventID)
 ON DELETE CASCADE
go
ALTER TABLE dbo.Nominee ADD CONSTRAINT FK_MemberNominee
FOREIGN KEY (MemberID)
REFERENCES dbo.Member (MemberID)
go
