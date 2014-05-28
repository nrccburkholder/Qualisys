/****** Object:  Stored Procedure dbo.sp_Samp_UpdateSamplePop    Script Date: 9/28/99 2:57:19 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_UpdateSamplePop
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
***********************************************************************************************************************************/
CREATE    PROCEDURE sp_Samp_UpdateSamplePop
 @intSampleSet_id int
AS

	--insert into dc_temp_timer (sp, starttime)
	--values ('sp_Samp_UpdateSamplePop', getdate())
 DECLARE @intStudy_id int

 /*Fetch the Study id*/
 SELECT @intStudy_id = SD.Study_id
  FROM dbo.Survey_def SD, dbo.SampleSet SS
  WHERE SD.Survey_id = SS.Survey_id
   AND SS.SampleSet_id = @intSampleSet_id
 
 INSERT INTO dbo.SamplePop
  (SampleSet_id, Study_id, Pop_id)
  SELECT Distinct @intSampleSet_id, @intStudy_id, SS.Pop_id
   FROM dbo.SelectedSample SS
   WHERE SS.SampleSet_id = @intSampleSet_id
   --GROUP BY SS.Pop_id


