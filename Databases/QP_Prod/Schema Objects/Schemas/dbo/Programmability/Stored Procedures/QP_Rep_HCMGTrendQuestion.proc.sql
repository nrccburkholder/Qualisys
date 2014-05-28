-- =============================================
-- Author:			Hui Holay
-- Create date:	06-20-2007
-- Description:		HCMG Trend Question
-- =============================================
-- Revision
-- =============================================
CREATE PROCEDURE [dbo].[QP_Rep_HCMGTrendQuestion]
	@HCMGYear VARCHAR(4),
	@HCMGMarket VARCHAR(255), 
	@HCMGQuestion VARCHAR(255),
	@MinN INTEGER,
	@MinP FLOAT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE 
		@MarketID INTEGER,
		@QuestionID INTEGER

	SELECT @QuestionID = 0, @MarketID = 0

	SELECT @MarketID = Market_id FROM HCMG.HCMG_Dev.dbo.Market 
	WHERE @HCMGMarket = Market_dsc

	SELECT @QuestionID = AppQuestion_id
	FROM HCMG.HCMG_Dev.dbo.App_Question
	WHERE strShortQuestion = @HCMGQuestion

	-- Vulcan
	EXEC HCMG.HCMG_Dev.dbo.TrendQuestion @HCMGYear, @QuestionID, @MarketID, @MinN, @MinP
END


