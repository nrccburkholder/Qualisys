CREATE FUNCTION [dbo].[fn_GetNrcDisposition] 
	(
	@SAMPLEPOP_ID int
	)
RETURNS int
AS
	BEGIN
	
	declare @id int
	
	-- get the latest disposition reported
	select @id = Disposition_id
      from QP_Prod.dbo.DispositionLog
	 where SamplePop_ID = @SAMPLEPOP_ID
	   and datLogged =
			(select max(datLogged)
			   from QP_Prod.dbo.DispositionLog
			  where SamplePop_ID = @SAMPLEPOP_ID)
	
	RETURN isnull(@id,0)
	
	END


