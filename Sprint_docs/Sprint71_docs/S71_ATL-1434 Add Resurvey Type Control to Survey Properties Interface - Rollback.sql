/*
    S71_ATL-1434 Add Resurvey Type Control to Survey Properties Interface - Rollback.sql

	Chris Burkholder

	3/28/2017

	ALTER 
*/
USE [QP_Prod]
GO

ALTER PROCEDURE [dbo].[QCL_SelectSubTypes] 
@surveytypeid int,
@subtypecategory int,
@surveyid int 
AS

/*
	S23 US13	Tim Butler -- changed to join with SubtypeSubtypeMapping
	S32 US12.3	Tim Butler -- added bitActive to SELECT 

*/

if @SubtypeCategory = 1
-- this returns records for loading the SubType combobox
	SELECT distinct st.SubType_id, SurveyType_ID, SubType_NM, stc.SubtypeCategory_id, stc.SubtypeCategory_nm, stc.bitMultiSelect, st.bitRuleOverride, st.bitActive, CASE WHEN sst.Subtype_id IS NULL THEN 0 ELSE 1 END bitSelected, ISNULL(ststm.ParentSubtype_id,
0) ParentSubType_id, st.bitQuestionnaireRequired
	FROM SurveyTypeSubType stst
	inner join Subtype st on (st.Subtype_id = stst.Subtype_id)
	inner join SubtypeCategory stc on (stc.SubtypeCategory_id = st.SubtypeCategory_id)
	left join SurveySubtype sst on (sst.Subtype_id = st.Subtype_id and sst.Survey_id = @surveyid)
	left join SubtypeSubtypeMapping ststm on (ststm.ParentSubtype_id = st.Subtype_id)  -- joins on ParentSubType_id
	WHERE SurveyType_ID = @surveytypeid
	and stc.SubtypeCategory_id = @SubtypeCategory

ELSE if @SubtypeCategory = 2
-- this returns records for loading the Questionnaire combobox
	SELECT distinct st.SubType_id, SurveyType_ID, SubType_NM, stc.SubtypeCategory_id, stc.SubtypeCategory_nm, stc.bitMultiSelect, st.bitRuleOverride, st.bitActive, CASE WHEN sst.Subtype_id IS NULL THEN 0 ELSE 1 END bitSelected, ISNULL(ststm.ParentSubtype_id,
0) ParentSubType_id, st.bitQuestionnaireRequired
	--INTO #QuestionnaireTypes
	FROM SurveyTypeSubType stst
	inner join Subtype st on (st.Subtype_id = stst.Subtype_id)
	inner join SubtypeCategory stc on (stc.SubtypeCategory_id = st.SubtypeCategory_id)
	left join SurveySubtype sst on (sst.Subtype_id = st.Subtype_id and sst.Survey_id = @surveyid)
	left join SubtypeSubtypeMapping ststm on (ststm.ChildSubtype_id = st.Subtype_id)  -- joins on ChildSubType_id
	WHERE SurveyType_ID = @surveytypeid
	and stc.SubtypeCategory_id = @SubtypeCategory

GO