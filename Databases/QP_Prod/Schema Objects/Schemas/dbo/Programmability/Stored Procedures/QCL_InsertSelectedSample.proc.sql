/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It inserts a record
for each unit that an pop record is sampled for into SelectedSample

Created:  02/24/2006 by DC

Modified:
*/  

CREATE  PROCEDURE [dbo].[QCL_InsertSelectedSample]
 @SampleSet_id int, 
 @study_id int,
 @pop_id int,
 @sampleunit_id int,
 @strunitSelectType char(1),
 @enc_id int = null,
 @encDate datetime,
 @reportDate datetime
AS

INSERT INTO dbo.selectedsample (SampleSet_id, Study_id, Pop_id, SampleUnit_id,
		StrunitSelecttype, enc_id, reportDate, sampleEncounterDate) values (@SampleSet_id, @study_id, @pop_id,
	@sampleunit_id, @strunitSelectType, @enc_id, @reportDate,@encDate)


