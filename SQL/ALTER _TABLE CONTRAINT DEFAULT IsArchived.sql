USE SwimClubMeet2
GO

ALTER TABLE dbo.SwimClub
ADD CONSTRAINT DF_SwimClub_IsArchived
DEFAULT 0 FOR IsArchived;
