-- ========================================================
-- Author:			Hui Holay
-- Create date:	02-20-2006
-- Description:		This procedure calls HCMG_DemoFrequency.
-- ========================================================
-- Revision
-- 03-23-2007 - SJS - Server Name changed from Medusa to HCMG alias
-- ========================================================
CREATE PROCEDURE [dbo].[QP_Rep_HCMGDemoFrequency]
	@HCMGYear VARCHAR(4),
	@HCMGMarket VARCHAR(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Market VARCHAR(4)

	SELECT @Market = Market_id FROM HCMG.HCMG_Dev.dbo.Market 
	WHERE @HCMGMarket = Market_dsc

	EXEC HCMG.HCMG_Dev.dbo.HCMG_DemoFrequency @Market, @HCMGYear
END


