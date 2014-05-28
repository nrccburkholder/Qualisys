/*  
Business Purpose:   
  
This procedure is used to support the Qualisys Class Library.  It indicates if 
a survey has been sampled.  
  
Created:  02/27/2006 by Brian Dohmen  
  
Modified:  
*/      
CREATE PROCEDURE QCL_IsSurveySampled
@Survey_id INT
AS

SELECT CASE WHEN EXISTS (SELECT SampleSet_id FROM SampleSet WHERE Survey_id=@Survey_id) 
   THEN CONVERT(BIT,1) ELSE CONVERT(BIT,0) END bitHasSampled


