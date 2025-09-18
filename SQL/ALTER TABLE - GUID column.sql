USE SwimClubMeet2
go

-- 1. Add the column, with a DEFAULT, as NOT NULL
ALTER TABLE dbo.SwimClub
ADD GUID uniqueidentifier 
    CONSTRAINT DF_SwimClub_GUID DEFAULT NEWSEQUENTIALID()
    NOT NULL;


