/****** Object:  StoredProcedure [dbo].[dxv_GetDropView]    Script Date: 08/09/2006 14:41:32 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[dxv_GetDropView]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[dxv_GetDropView]
GO
/****** Object:  StoredProcedure [dbo].[dxv_GetDropView]    Script Date: 08/09/2006 14:41:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[dxv_GetDropView]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


create procedure dxv_GetDropView (@SurveyID  int)
/*This procedure prints out a create view statement that can be used to create a view.
Later incarnations will probably create the view on the fly.*/
as
begin
declare @phase int
declare @itemorder int
declare @textorder varchar(1000)
declare @subphase int

declare abc cursor for
select 1 phase,1 itemorder,''x'' textorder,1 subphase,
        dbo.dxv_DropViewDefinition(@SurveyID)


declare @atext varchar(2000)
open abc
fetch abc into @phase,@itemorder,@textorder,@Subphase,@atext
 while @@FETCH_STATUS = 0
   begin
   print @atext
   fetch abc into @phase,@itemorder,@textorder,@Subphase,@atext
   end
close abc
deallocate abc
end


' 
END
GO
GRANT EXECUTE ON [dbo].[dxv_GetDropView] TO [reporter]
GO
