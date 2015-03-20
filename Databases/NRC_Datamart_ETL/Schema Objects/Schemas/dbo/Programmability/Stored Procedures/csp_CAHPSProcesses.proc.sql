-- =============================================
-- Author:		Dave Gilsdorf
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[csp_CAHPSProcesses] 
AS
-- this code was previously in NRC_Datamart_ETL.dbo.csp_CAHPSProcesses. We're putting it in its own proc so that 
-- it can be called at the beginning of the ETL, instead of in the middle.

	DECLARE @country VARCHAR(10)
	SELECT @country = [STRPARAM_VALUE] FROM [QP_Prod].[dbo].[qualpro_params] WHERE STRPARAM_NM = 'Country'
	select @country
	IF @country = 'US'
	BEGIN
		EXEC [QP_Prod].[dbo].[CheckForCAHPSIncompletes] 
		EXEC [QP_Prod].[dbo].[CheckForACOCAHPSUsablePartials]
		EXEC [QP_Prod].[dbo].[CheckForMostCompleteUsablePartials] -- HHCAHPS and ICHCAHPS
		EXEC [QP_Prod].[dbo].[CheckHospiceCAHPSDispositions]
	END
