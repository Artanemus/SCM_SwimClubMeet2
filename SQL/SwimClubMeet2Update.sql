USE [SwimClubMeet2]
go

-- Dictionary Object Alter SQL

CREATE DEFAULT dbo.BIT_0 AS ((0))
go
EXEC sp_bindefault 'dbo.BIT_0', 'dbo.Lane.IsDisqualified'
go
EXEC sp_bindefault 'dbo.BIT_0', 'dbo.Lane.IsScratched'
go
EXEC sp_bindefault 'dbo.BIT_0', 'dbo.EventCategory.IsArchived'
go
EXEC sp_bindefault 'dbo.BIT_0', 'dbo.Member.EnableEmailOut'
go
EXEC sp_bindefault 'dbo.BIT_0', 'dbo.Member.EnableEmailNomineeForm'
go
EXEC sp_bindefault 'dbo.BIT_0', 'dbo.Member.EnableEmailSessionReport'
go
EXEC sp_bindefault 'dbo.BIT_0', 'dbo.ContactNum.IsArchived'
go
EXEC sp_bindefault 'dbo.BIT_0', 'dbo.House.IsArchived'
go
EXEC sp_bindefault 'dbo.BIT_0', 'dbo.SwimClub.IsArchived'
go
EXEC sp_bindefault 'dbo.BIT_0', 'dbo.SwimClub.IsClubGroup'
go
EXEC sp_bindefault 'dbo.BIT_0', 'dbo.MemberRole.IsArchived'
go
EXEC sp_bindefault 'dbo.BIT_0', 'dbo.MemberRoleLink.IsArchived'
go
EXEC sp_bindefault 'dbo.BIT_0', 'dbo.PoolType.IsArchived'
go
EXEC sp_bindefault 'dbo.BIT_0', 'dbo.SwimClubType.IsArchived'
go

-- Standard Alter Table SQL

ALTER TABLE dbo.Team DROP CONSTRAINT DF__Team__TTB__2C938683
go
ALTER TABLE dbo.Team DROP CONSTRAINT DF__Team__PB__2D87AABC
go
ALTER TABLE dbo.Team DROP CONSTRAINT DF__Team__SeedTime__2E7BCEF5
go
ALTER TABLE dbo.Team ADD CONSTRAINT DF__Team__TTB__2C938683 DEFAULT (NULL) FOR TTB
go
ALTER TABLE dbo.Team ADD CONSTRAINT DF__Team__PB__2D87AABC DEFAULT (NULL) FOR PB
go
ALTER TABLE dbo.Team ADD CONSTRAINT DF__Team__SeedTime__2E7BCEF5 DEFAULT (NULL) FOR SeedTime
go

-- Drop Constraint, Rename and Create Table SQL

EXEC sp_rename 'dbo.MemberLink.PK_MemberLink','PK_MemberL_02082026012222001','INDEX'
go
EXEC sp_rename 'dbo.HouseMemberLink','HouseMembe_02082026012222002'
go
EXEC sp_rename 'dbo.MemberLinkSwimClub','MemberLink_02082026012222003'
go
EXEC sp_rename 'dbo.FK_MemberLink','FK_MemberL_02082026012222004'
go
EXEC sp_rename 'dbo.MemberLink','MemberLink_02082026012222000',OBJECT
go
CREATE TABLE dbo.MemberLink
(
    MemberID   int   NOT NULL,
    SwimClubID int   NOT NULL,
    IsArchived bit   NOT NULL,
    HouseID    int  NULL
)
ON [PRIMARY]
go
EXEC sp_bindefault 'BIT_0', 'dbo.MemberLink.IsArchived'
go
DROP TABLE dbo.Team_02062026044919000
go

-- Insert Data SQL

INSERT INTO dbo.MemberLink(
                           MemberID,
                           SwimClubID,
--                         IsArchived,
                           HouseID
                          )
                    SELECT 
                           MemberID,
                           SwimClubID,
--                         IsArchived,
                           HouseID
                      FROM dbo.MemberLink_02082026012222000 
go

-- Add Constraint SQL

ALTER TABLE dbo.MemberLink ADD CONSTRAINT PK_MemberLink
PRIMARY KEY CLUSTERED (MemberID,SwimClubID)
go

-- Add Referencing Foreign Keys SQL

ALTER TABLE dbo.MemberLink ADD CONSTRAINT HouseMemberLink
FOREIGN KEY (HouseID)
REFERENCES dbo.House (HouseID)
go
ALTER TABLE dbo.MemberLink ADD CONSTRAINT MemberLinkSwimClub
FOREIGN KEY (SwimClubID)
REFERENCES dbo.SwimClub (SwimClubID)
go
ALTER TABLE dbo.MemberLink ADD CONSTRAINT FK_MemberLink
FOREIGN KEY (MemberID)
REFERENCES dbo.Member (MemberID)
go
