/****** Object:  Stored Procedure dbo.sp_Replace_Apostrophe    Script Date: 6/9/99 4:36:38 PM ******/
/****** Object:  Stored Procedure dbo.sp_Replace_Apostrophe    Script Date: 3/12/99 4:16:09 PM ******/
CREATE PROCEDURE sp_Replace_Apostrophe @study_id numeric AS
/*
'update S + CONVERT(VARCHAR, @study_id) + .population_load 
set addr = STUFF(ADDR,CHARINDEX("'",ADDR),1,"`") 
where addr like "%'%"'
*/


