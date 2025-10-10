USE SwimClubMeet
GO 

Select [SwimClubMeet].dbo.Member.MemberID, [SwimClubMeet2].dbo.Lane.LaneNum, [SwimClubMeet2].dbo.Nominee.NomineeID  from [SwimClubMeet].dbo.Member
INNER JOIN [SwimClubMeet].dbo.Entrant ON [SwimClubMeet].dbo.Entrant.memberID = [SwimClubMeet].dbo.Member.MemberID
INNER JOIN [SwimClubMeet].dbo.HeatIndividual ON [SwimClubMeet].dbo.Entrant.HeatID = [SwimClubMeet].dbo.HeatIndividual.HeatID
INNER JOIN [SwimClubMeet2].dbo.HEAT on [SwimClubMeet].dbo.HeatIndividual.HeatID = [SwimClubMeet2].dbo.Heat.HeatID
INNER JOIN [SwimClubMeet2].dbo.Lane on [SwimClubMeet].dbo.Entrant.Lane = [SwimClubMeet2].dbo.Lane.LaneNum 
INNER JOIN [SwimClubMeet2].dbo.Nominee on [SwimClubMeet2].dbo.Lane.NomineeID = [SwimClubMeet2].dbo.Nominee.NomineeID
Where [SwimClubMeet2].dbo.Heat.EventID = 1413 and [SwimClubMeet2].dbo.Nominee.EventID = 1413;
go


UPDATE N
SET N.MemberID = M.MemberID
FROM [SwimClubMeet2].dbo.Nominee N
INNER JOIN [SwimClubMeet2].dbo.Lane L ON N.NomineeID = L.NomineeID
INNER JOIN [SwimClubMeet2].dbo.Heat H2 ON L.HeatID = H2.HeatID
INNER JOIN [SwimClubMeet].dbo.HeatIndividual HI ON H2.HeatID = HI.HeatID
INNER JOIN [SwimClubMeet].dbo.Entrant E ON HI.HeatID = E.HeatID AND L.LaneNum = E.Lane
INNER JOIN [SwimClubMeet].dbo.Member M ON E.MemberID = M.MemberID
-- No WHERE clause, so this applies to all EventIDs