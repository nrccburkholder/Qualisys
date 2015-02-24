/*

	S19 US20 Add three ICH more methodologies.

	Tim Butler

	BACKOUT

	alter table [dbo].[StandardMethodologybySurveyType] add expired (QP_PROD) US20.1


*/


use [QP_Prod]
go
begin tran
go
if exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'StandardMethodologybySurveyType' 
					   AND sc.NAME = 'bitExpired' )

	alter table [dbo].[StandardMethodologybySurveyType] drop column bitExpired
go

commit tran
go


USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectStandardMethodologiesBySurveyTypeId]    Script Date: 2/24/2015 11:22:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QCL_SelectStandardMethodologiesBySurveyTypeId]
 @SurveyTypeID INT,
 @SubType_Id INT = NULL
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF @SubType_Id is NULL
	SELECT sm.StandardMethodologyId, sm.strStandardMethodology_nm, sm.bitCustom
	FROM StandardMethodology sm 
	INNER JOIN StandardMethodologyBySurveyType smst ON smst.StandardMethodologyID=sm.StandardMethodologyID
	WHERE smst.SurveyType_id=@SurveyTypeID
	ORDER BY sm.strStandardMethodology_nm
ELSE
	SELECT sm.StandardMethodologyId, sm.strStandardMethodology_nm, sm.bitCustom
	FROM StandardMethodology sm 
	INNER JOIN StandardMethodologyBySurveyType smst ON smst.StandardMethodologyID=sm.StandardMethodologyID
	WHERE smst.SurveyType_id=@SurveyTypeID
	AND smst.SubType_ID = @SubType_Id
	ORDER BY sm.strStandardMethodology_nm

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
