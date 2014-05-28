/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It indexes the list of
all eligible encounters and is used during the sampling process.

Created:  02/28/2006 by DC

Modified:

*/ 
CREATE      PROCEDURE [dbo].[QCL_SampleSetIndexUniverse]
 @bitEncounterExists bit = 0
AS

 
 IF @bitEncounterExists = 1
 BEGIN
  CREATE INDEX idxSUU_Pop_Enc
   ON #SampleUnit_Universe (Pop_id, Enc_id)
  CREATE CLUSTERED INDEX IX_PreSample_DSPopSU 
	ON #PreSample
		    (sampleunit_id, pop_id, Enc_id)
 END
 ELSE
 BEGIN
  CREATE INDEX idxSUU_Pop_Enc
   ON #SampleUnit_Universe (Pop_id)
  CREATE CLUSTERED INDEX IX_PreSample_DSPopSU 
	ON #PreSample
		    (sampleunit_id, Pop_id)
 END


