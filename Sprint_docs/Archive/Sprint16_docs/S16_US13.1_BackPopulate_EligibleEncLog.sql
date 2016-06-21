/*

	S16 US13 As an authorized Hospice CAHPS vendor, we need to log patients who are eligible to be sampled, so that we can report the count to CMS.

	Task 13.1 Create new table and populate the table from existing tables

	Tim Butler

*/


USE [QP_Prod]
GO

begin tran

		INSERT   INTO EligibleEncLog (sampleset_id, sampleunit_id, pop_Id, enc_id, sampleEncounterDate, SurveyType_ID)
		SELECT [sampleset_id]
			  ,[sampleunit_id]
			  ,[pop_id]
			  ,[enc_id]
			  ,[SampleEncounterDate]
			  ,2
		  FROM [dbo].[HCAHPSEligibleEncLog]
GO

commit tran

go

begin tran

	INSERT   INTO EligibleEncLog (sampleset_id, sampleunit_id, pop_Id, enc_id, sampleEncounterDate, SurveyType_ID)
	SELECT [sampleset_id]
		  ,[sampleunit_id]
		  ,[pop_id]
		  ,[enc_id]
		  ,[SampleEncounterDate]
		  ,3
	  FROM [dbo].[HHCAHPSEligibleEncLog]
GO

commit tran

GO

