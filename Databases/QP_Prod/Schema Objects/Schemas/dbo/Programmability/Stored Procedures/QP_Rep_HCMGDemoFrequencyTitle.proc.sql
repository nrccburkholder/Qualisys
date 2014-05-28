-- =======================================================================
-- Author:			Hui Holay
-- Create date:	02-20-2007
-- Description:		
-- =======================================================================
-- Revision:
-- 03-23-2007 - SJS - Server Name changed from Medusa to HCMG alias
-- =======================================================================
CREATE PROCEDURE QP_Rep_HCMGDemoFrequencyTitle	
	@HCMGYear VARCHAR(4),
	@HCMGMarket VARCHAR(255)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE 
		@Market VARCHAR(4),
		@StandardMarket BIT,
		@MarketType VARCHAR(15),
		@MarketTypeDef INT

	SELECT @Market = Market_id,
		@MarketType = MarketType,
		@MarketTypeDef = MarketType_Def
	FROM HCMG.HCMG_Dev.dbo.Market 
	WHERE @HCMGMarket = Market_dsc

	SELECT 'Healthcare Market Guide ' + @HCMGYear + '/' + 
		RIGHT(CONVERT(VARCHAR(4), (CONVERT(INT, @HCMGYear) + 1)),2) AS [Year],
		@MarketType + ' Market' AS [Market Type],
		@Market AS [Market ID],
		RTRIM(@HCMGMarket) AS [Market Name]

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END


