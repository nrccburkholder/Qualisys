CREATE PROCEDURE [dbo].[csp_GetSentMailings_OneTime] 
	 @MinLithoCode As NVarchar(20) , @MaxLithoCode As NVarchar(20)
AS
  BEGIN
	SET NOCOUNT ON 
	
	Select strlithocode,DatMailed,DatExpire,DatGenerated,DatPrinted,DatBundled,DatUndeliverable
    From QP_Prod.dbo.SENTMAILING with (NOLOCK)
    Where strLithoCode >= @MinLithoCode And strLithoCode <= @MaxLithoCode

	SET NOCOUNT OFF	

  END


