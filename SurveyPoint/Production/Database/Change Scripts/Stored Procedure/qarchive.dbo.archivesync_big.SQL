/****** Object:  StoredProcedure [dbo].[archivesync_big]    Script Date: 08/09/2006 13:18:23 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[archivesync_big]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[archivesync_big]
GO
/****** Object:  StoredProcedure [dbo].[archivesync_big]    Script Date: 08/09/2006 13:18:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[archivesync_big]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure archivesync_big (@mode int)
as
begin
exec triggerlog_pn @mode

exec respondentproperties_pn @mode
exec respondents_pn @mode
exec eventlog_pn @mode
exec responses_pn @mode
end
' 
END
GO
