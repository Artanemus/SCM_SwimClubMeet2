-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Artanemus
-- Create date: 23/03/2026
-- Description:	Build a description string for swimming distance
-- =============================================
CREATE OR ALTER FUNCTION DistanceToString 
(
	-- Add the parameters for the function here
	@DistanceID int,
	@PoolTypeID int
)
RETURNS nvarchar(20)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result nvarchar(20)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = 
		CONCAT( CAST(D.Laps * P.LengthOfPool AS NVARCHAR(10)), U.ABREV)
			FROM dbo.PoolType AS P
			INNER JOIN dbo.UnitType AS U
				ON P.UnitTypeID = U.UnitTypeID
			CROSS JOIN dbo.Distance AS D
			WHERE D.DistanceID = @DistanceID
				AND P.PoolTypeID = @PoolTypeID;
		
	-- Return the result of the function
	RETURN ISNULL(@Result, N'');

END
GO

