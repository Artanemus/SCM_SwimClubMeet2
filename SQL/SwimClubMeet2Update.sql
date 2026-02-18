USE [SwimClubMeet2]
go

-- Standard Alter Table SQL

ALTER TABLE dbo.MemberLink ADD MembershipNum int  NULL
go
ALTER TABLE dbo.MemberLink ADD MembershipStr nvarchar(24)  NULL
go
ALTER TABLE dbo.MemberLink ADD CreatedOn datetime  NULL
go
ALTER TABLE dbo.MemberLink ADD ArchivedOn datetime  NULL
go
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

DROP TABLE dbo.MemberLink_02082026012222000
go
