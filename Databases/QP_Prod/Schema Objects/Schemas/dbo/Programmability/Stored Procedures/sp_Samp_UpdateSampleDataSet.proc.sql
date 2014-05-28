/****** Object:  Stored Procedure dbo.sp_Samp_UpdateSampleDataSet    Script Date: 9/28/99 2:57:19 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_UpdateSampleDataSet
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
Modified 8/26/3 BD  Added procedure to populate the date range fields in sampleset if they are null
***********************************************************************************************************************************/
CREATE  PROCEDURE sp_Samp_UpdateSampleDataSet
 @intSampleSet_id int
AS
	--insert into dc_temp_timer (sp, starttime)
	--values ('sp_Samp_UpdateSampleDataSet', getdate())

 INSERT INTO dbo.SampleDataSet
  SELECT @intSampleSet_id, DS.DataSet_id
  FROM #DataSet DS

EXEC SP_Samp_DefineDateRange @intSampleSet_id


