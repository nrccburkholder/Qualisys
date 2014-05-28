/****** Object:  Stored Procedure dbo.sp_MM_GetMethodologies    Script Date: 6/9/99 4:36:36 PM ******/
/****** Object:  Stored Procedure dbo.sp_MM_GetMethodologies    Script Date: 3/12/99 4:16:08 PM ******/
/****** Object:  Stored Procedure dbo.sp_MM_GetMethodologies    Script Date: 12/7/98 2:34:54 PM ******/

CREATE PROCEDURE sp_MM_GetMethodologies
 @mintMethodology_id int
AS
 SELECT DISTINCT MM.*, SM.Methodology_id as IsScheduled
 FROM MailingMethodology MM Left outer Join ScheduledMailing SM on MM.Methodology_id = SM.Methodology_ID
 WHERE MM.Methodology_id = @mintMethodology_id


