CREATE FUNCTION [dbo].[fn_GetHcahpsDisposition] 
	(
	@SAMPLEPOP_ID int
	)
RETURNS int
AS
	BEGIN
	
	declare @currentValue int, @currentHierachy int
	
	set @currentValue = 0 
	set @currentHierachy = 1000 -- Higher is lower priority
	
	DECLARE log_cursor CURSOR FOR 
	 select convert(int,d.hcahpsvalue), isnull(d.hcahpshierarchy,999)
	   from QP_Prod.dbo.DispositionLog dl
			inner join QP_Prod.dbo.Disposition d on d.Disposition_id = dl.Disposition_id
	  where dl.samplepop_id = @SAMPLEPOP_ID
	    and d.hcahpsvalue is not null
	  order by datLogged asc			  
			  
	OPEN log_cursor

	declare @V int, @H int
	FETCH NEXT FROM log_cursor INTO @V, @H

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- lower H-values take precedence over higher H-values
		if @currentHierachy > @H 
		begin
			set @currentValue = @V
			set @currentHierachy = @H
		end

		FETCH NEXT FROM log_cursor INTO @V, @H
	END

	CLOSE log_cursor
	DEALLOCATE log_cursor

	RETURN @currentValue
	
	END


