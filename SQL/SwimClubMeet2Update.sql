USE [SwimClubMeet2]
go

-- Drop Referencing Constraint SQL

ALTER TABLE dbo.Lane DROP CONSTRAINT FK_LaneTeam
go
ALTER TABLE dbo.TeamLink DROP CONSTRAINT FK_TeamLink
go

-- Drop Constraint, Rename and Create Table SQL

EXEC sp_rename 'dbo.Team.PK_Team','PK_Team_02062026044919001','INDEX'
go
EXEC sp_rename 'dbo.DF__Team__SeedTime__2E7BCEF5', 'DF__Team___02062026044919002',OBJECT
go
EXEC sp_rename 'dbo.DF__Team__PB__2D87AABC', 'DF__Team___02062026044919003',OBJECT
go
EXEC sp_rename 'dbo.DF__Team__TTB__2C938683', 'DF__Team___02062026044919004',OBJECT
go
EXEC sp_rename 'dbo.DF__Team__ABREV__2B9F624A', 'DF__Team___02062026044919005',OBJECT
go
EXEC sp_rename 'dbo.DF__Team__TeamName__70B3A6A6', 'DF__Team___02062026044919006',OBJECT
go
EXEC sp_rename 'dbo.DF__Team__Caption__6FBF826D', 'DF__Team___02062026044919007',OBJECT
go
EXEC sp_rename 'dbo.Team','Team_02062026044919000',OBJECT
go
CREATE TABLE dbo.Team
(
    TeamID        int            IDENTITY,
    Caption       nvarchar(128)  CONSTRAINT DF__Team__Caption__6FBF826D DEFAULT (NULL) NULL,
    TeamName      nvarchar(16)   CONSTRAINT DF__Team__TeamName__70B3A6A6 DEFAULT (NULL) NULL,
    ABREV         nvarchar(16)   CONSTRAINT DF__Team__ABREV__2B9F624A DEFAULT (NULL) NULL,
    TTB           time(7)        CONSTRAINT DF__Team__TTB__2C938683 DEFAULT (NULL) NULL,
    PB            time(7)        CONSTRAINT DF__Team__PB__2D87AABC DEFAULT (NULL) NULL,
    SeedTime      time(7)        CONSTRAINT DF__Team__SeedTime__2E7BCEF5 DEFAULT (NULL) NULL,
    AutoBuildFlag bit            NULL,
    EventID       int             NOT NULL
)
ON [PRIMARY]
go
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'table', 'Team', 'column', 'PB'))
BEGIN
  exec sys.sp_dropextendedproperty 'MS_Description', 'schema', 'dbo', 'table', 'Team', 'column', 'PB'
END
exec sys.sp_addextendedproperty 'MS_Description', 'RaceTime, PB, TTB, SeedTime all use MS SQLEXPRESS TIME variable', 'schema', 'dbo', 'table', 'Team', 'column', 'PB'
go
if exists (select * from ::fn_listextendedproperty('MS_Description', 'schema', 'dbo', 'table', 'Team', 'column', 'SeedTime'))
BEGIN
  exec sys.sp_dropextendedproperty 'MS_Description', 'schema', 'dbo', 'table', 'Team', 'column', 'SeedTime'
END
exec sys.sp_addextendedproperty 'MS_Description', 'RaceTime, PB, TTB, SeedTime all use MS SQLEXPRESS TIME variable', 'schema', 'dbo', 'table', 'Team', 'column', 'SeedTime'
go
GRANT DELETE ON dbo.Team TO SCM_Administrator
go
GRANT INSERT ON dbo.Team TO SCM_Administrator
go
GRANT SELECT ON dbo.Team TO SCM_Administrator
go
GRANT UPDATE ON dbo.Team TO SCM_Administrator
go
GRANT SELECT ON dbo.Team TO SCM_Guest
go
GRANT DELETE ON dbo.Team TO SCM_Marshall
go
GRANT INSERT ON dbo.Team TO SCM_Marshall
go
GRANT SELECT ON dbo.Team TO SCM_Marshall
go
GRANT UPDATE ON dbo.Team TO SCM_Marshall
go

-- Insert Data SQL

SET IDENTITY_INSERT dbo.Team ON
go
INSERT INTO dbo.Team(
                     TeamID,
                     Caption,
                     TeamName,
                     ABREV,
                     TTB,
                     PB,
                     SeedTime,
                     AutoBuildFlag,
                     EventID
                    )
              SELECT 
                     TeamID,
                     Caption,
                     TeamName,
                     ABREV,
                     TTB,
                     PB,
                     SeedTime,
                     AutoBuildFlag,
                     0
                FROM dbo.Team_02062026044919000 
go
SET IDENTITY_INSERT dbo.Team OFF
go

-- Add Constraint SQL

ALTER TABLE dbo.Team ADD CONSTRAINT PK_Team
PRIMARY KEY NONCLUSTERED (TeamID)
go

-- Add Referencing Foreign Keys SQL

ALTER TABLE dbo.Lane ADD CONSTRAINT FK_LaneTeam
FOREIGN KEY (TeamID)
REFERENCES dbo.Team (TeamID)
go
ALTER TABLE dbo.TeamLink ADD CONSTRAINT FK_TeamLink
FOREIGN KEY (TeamID)
REFERENCES dbo.Team (TeamID)
go
ALTER TABLE dbo.Team ADD CONSTRAINT FK_EventTeam
FOREIGN KEY (EventID)
REFERENCES dbo.Event (EventID)
go
