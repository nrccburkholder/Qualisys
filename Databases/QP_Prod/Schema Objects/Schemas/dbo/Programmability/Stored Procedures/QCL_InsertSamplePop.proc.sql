/*
Business Purpose: 
This procedure is used to add one record to the samplepop table
for each person sampled.  The people sampled will already have
their records inserted into selectedsample.

Created:  2/23/2006 by DC

Modified:

*/  
CREATE PROCEDURE [dbo].[QCL_InsertSamplePop]
 @SampleSet_id int,
 @Study_id int, 
 @pop_id int,
 @bitBadAddress bit,
 @bitBadPhone bit
AS
 
 INSERT INTO dbo.SamplePop
  (SampleSet_id, Study_id, Pop_id, bitBadAddress, bitBadPhone)
  Values (@SampleSet_id, @Study_id, @Pop_id, @bitBadAddress, @bitBadPhone)


