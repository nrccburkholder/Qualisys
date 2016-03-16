
/*

	S44 US11 CG-CAHPS Dispositions 
	As a CG-CAHPS vendor, we need to update the disposition hierarchy to match the new specs, so that we can submit accurate data.

	Task 1 - Update SurveyTypeDisposition on NRC10 & Medusa

	Tim Butler
*/

USE [QP_Comments]
GO

-- remove current records for CGCAHPS
delete dbo.SurveyTypeDispositions 
where SurveyType_ID = 4


