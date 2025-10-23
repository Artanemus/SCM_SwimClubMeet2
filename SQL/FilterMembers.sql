-- ...existing code...
USE SwimClubMeet2;
GO

-- create temporary table to hold results
IF OBJECT_ID('tempdb..#SwimClubMembers') IS NOT NULL
    DROP TABLE #SwimClubMembers;    

DECLARE @SwimClubID INT = 1;
DECLARE @SortOn INT = 1;

CREATE TABLE #SwimClubMembers
(
    SwimClubID INT,
    MemberID   INT
);  

-- insert members from the parent club (distinct, skip if MemberID already in temp)
INSERT INTO #SwimClubMembers (SwimClubID, MemberID)
SELECT DISTINCT sc.SwimClubID, mm.MemberID
FROM dbo.SwimClub AS sc
INNER JOIN dbo.MemberLink AS ml ON sc.SwimClubID = ml.SwimClubID
INNER JOIN dbo.Member AS mm ON ml.MemberID = mm.MemberID
WHERE sc.SwimClubID = @SwimClubID
  AND NOT EXISTS (SELECT 1 FROM #SwimClubMembers m WHERE m.MemberID = mm.MemberID);

-- insert members from child clubs (distinct, skip if MemberID already in temp)
INSERT INTO #SwimClubMembers (SwimClubID, MemberID)
SELECT DISTINCT sg.ChildClubID, mm.MemberID
FROM dbo.SwimClubGroup AS sg
INNER JOIN dbo.MemberLink AS ml ON sg.ChildClubID = ml.SwimClubID
INNER JOIN dbo.Member AS mm ON ml.MemberID = mm.MemberID
WHERE sg.ParentClubID = @SwimClubID
  AND NOT EXISTS (SELECT 1 FROM #SwimClubMembers m WHERE m.MemberID = mm.MemberID);

-- final result from the temp table (no duplicate MemberID rows)
SELECT
    mlist.SwimClubID,
    mlist.MemberID,
    mm.FirstName,
    mm.MiddleInitial,
    mm.LastName,
    scc.NickName,
    dbo.SwimmerAge(GETDATE(), mm.DOB) AS Age,
	gender.ABREV,
	CASE 
	WHEN (mm.MiddleInitial IS NULL) THEN
		CONCAT(mm.FirstName, ' ', mm.LastName)
	ELSE
		CONCAT(mm.FirstName, ' ', mm.MiddleInitial, '. ', mm.LastName)
	END as FName 
FROM #SwimClubMembers AS mlist
INNER JOIN dbo.Member AS mm ON mlist.MemberID = mm.MemberID
INNER JOIN dbo.SwimClub AS scc ON mlist.SwimClubID = scc.SwimClubID
INNER JOIN dbo.Gender ON mm.GenderID = Gender.GenderID
ORDER BY 
	CASE WHEN (@SortOn = 1) THEN mm.LastName ELSE mm.FirstName END 
;

DROP TABLE #SwimClubMembers;
-- ...existing code...