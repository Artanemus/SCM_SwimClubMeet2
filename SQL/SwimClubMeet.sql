USE [SwimClubMeet2]
go

-- Dictionary Object Alter SQL

CREATE DEFAULT dbo.Def_NULL AS ((NULL))
go

-- Drop Referencing Constraint SQL

ALTER TABLE dbo.PB DROP CONSTRAINT FK_MemberPB
go
ALTER TABLE dbo.MemberLink DROP CONSTRAINT FK_MemberLink
go
ALTER TABLE dbo.ContactNum DROP CONSTRAINT MemberContactNum
go
ALTER TABLE dbo.MemberRoleLink DROP CONSTRAINT MemberMemberRoleLink
go
ALTER TABLE dbo.Nominee DROP CONSTRAINT FK_MemberNominee
go
ALTER TABLE dbo.ParaCodeLink DROP CONSTRAINT FK_ParaCodeLink
go

-- Drop Constraint, Rename and Create Table SQL

EXEC sp_rename 'dbo.Member.PK_Member','PK_Member_11302025234214001','INDEX'
go
EXEC sp_rename 'dbo.GenderMember','GenderMemb_11302025234214002'
go
EXEC sp_rename 'dbo.DF__Member__IsActive__2A4B4B5E', 'DF__Member_11302025234214003',OBJECT
go
EXEC sp_rename 'dbo.DF_Member_IsArchived', 'DF_Member__11302025234214004',OBJECT
go
EXEC sp_rename 'dbo.DF__Member__LastName__5CACADF9', 'DF__Member_11302025234214005',OBJECT
go
EXEC sp_rename 'dbo.DF__Member__FirstNam__5BB889C0', 'DF__Member_11302025234214006',OBJECT
go
EXEC sp_rename 'dbo.Member','Member_11302025234214000',OBJECT
go
CREATE TABLE dbo.Member
(
    MemberID                 int            IDENTITY,
    MembershipNum            int            NULL,
    MembershipStr            nvarchar(24)   NULL,
    FirstName                nvarchar(128)  CONSTRAINT DF__Member__FirstNam__5BB889C0 DEFAULT (NULL) NULL,
    MiddleName               nvarchar(128)  NULL,
    LastName                 nvarchar(128)  CONSTRAINT DF__Member__LastName__5CACADF9 DEFAULT (NULL) NULL,
    RegisterNum              int            NULL,
    RegisterStr              nvarchar(24)   NULL,
    DOB                      datetime       NULL,
    IsArchived               bit            CONSTRAINT DF_Member_IsArchived DEFAULT ((0))  NOT NULL,
    IsActive                 bit            CONSTRAINT DF__Member__IsActive__2A4B4B5E DEFAULT ((1))  NOT NULL,
    IsSwimmer                bit             NOT NULL,
    Email                    nvarchar(256)  NULL,
    CreatedOn                datetime       NULL,
    ArchivedOn               datetime       NULL,
    EnableEmailOut           bit             NOT NULL,
    EnableEmailNomineeForm   bit             NOT NULL,
    EnableEmailSessionReport bit             NOT NULL,
    TAGS                     ntext          NULL,
    GenderID                 int            NULL
)
ON [PRIMARY]
go
GRANT DELETE ON dbo.Member TO SCM_Administrator
go
GRANT INSERT ON dbo.Member TO SCM_Administrator
go
GRANT SELECT ON dbo.Member TO SCM_Administrator
go
GRANT UPDATE ON dbo.Member TO SCM_Administrator
go
GRANT SELECT ON dbo.Member TO SCM_Guest
go
GRANT SELECT ON dbo.Member TO SCM_Marshall
go
EXEC sp_bindefault 'Def_NULL', 'dbo.Member.MiddleName'
go
EXEC sp_bindefault 'BIT_1', 'dbo.Member.IsSwimmer'
go
EXEC sp_bindefault 'BIT_0', 'dbo.Member.EnableEmailOut'
go
EXEC sp_bindefault 'BIT_0', 'dbo.Member.EnableEmailNomineeForm'
go
EXEC sp_bindefault 'BIT_0', 'dbo.Member.EnableEmailSessionReport'
go

-- Insert Data SQL

SET IDENTITY_INSERT dbo.Member ON
go
INSERT INTO dbo.Member(
                       MemberID,
                       MembershipNum,
                       MembershipStr,
                       FirstName,
                       MiddleName,
                       LastName,
                       RegisterNum,
                       RegisterStr,
                       DOB,
                       IsArchived,
                       IsActive,
                       IsSwimmer,
                       Email,
                       CreatedOn,
                       ArchivedOn,
                       EnableEmailOut,
                       EnableEmailNomineeForm,
                       EnableEmailSessionReport,
                       TAGS,
                       GenderID
                      )
                SELECT 
                       MemberID,
                       MembershipNum,
                       MembershipStr,
                       FirstName,
                       NULL,
                       LastName,
                       RegisterNum,
                       RegisterStr,
                       DOB,
                       IsArchived,
                       IsActive,
                       IsSwimmer,
                       Email,
                       CreatedOn,
                       ArchivedOn,
                       EnableEmailOut,
                       EnableEmailNomineeForm,
                       EnableEmailSessionReport,
                       TAGS,
                       GenderID
                  FROM dbo.Member_11302025234214000 
go
SET IDENTITY_INSERT dbo.Member OFF
go

-- Add Constraint SQL

ALTER TABLE dbo.Member ADD CONSTRAINT PK_Member
PRIMARY KEY NONCLUSTERED (MemberID)
go

-- Add Referencing Foreign Keys SQL

ALTER TABLE dbo.PB ADD CONSTRAINT FK_MemberPB
FOREIGN KEY (MemberID)
REFERENCES dbo.Member (MemberID)
go
ALTER TABLE dbo.MemberLink ADD CONSTRAINT FK_MemberLink
FOREIGN KEY (MemberID)
REFERENCES dbo.Member (MemberID)
go
ALTER TABLE dbo.ContactNum ADD CONSTRAINT MemberContactNum
FOREIGN KEY (MemberID)
REFERENCES dbo.Member (MemberID)
 ON DELETE CASCADE
go
ALTER TABLE dbo.MemberRoleLink ADD CONSTRAINT MemberMemberRoleLink
FOREIGN KEY (MemberID)
REFERENCES dbo.Member (MemberID)
go
ALTER TABLE dbo.Nominee ADD CONSTRAINT FK_MemberNominee
FOREIGN KEY (MemberID)
REFERENCES dbo.Member (MemberID)
go
ALTER TABLE dbo.ParaCodeLink ADD CONSTRAINT FK_ParaCodeLink
FOREIGN KEY (MemberID)
REFERENCES dbo.Member (MemberID)
go
ALTER TABLE dbo.Member ADD CONSTRAINT GenderMember
FOREIGN KEY (GenderID)
REFERENCES dbo.Gender (GenderID)
 ON DELETE SET NULL
go
