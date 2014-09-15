USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectSubTypes]    Script Date: 8/19/2014 10:55:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[QCL_SelectSubTypes] 
@surveytypeid int,
@subtypecategory int,
@surveyid int 
AS

SELECT distinct st.SubType_id, SurveyType_ID, SubType_NM, stc.SubtypeCategory_id, stc.SubtypeCategory_nm, stc.bitMultiSelect, st.bitRuleOverride, CASE WHEN sst.Subtype_id IS NULL THEN 0 ELSE 1 END bitSelected
FROM SurveyTypeSubType stst
inner join Subtype st on (st.Subtype_id = stst.Subtype_id)
inner join SubtypeCategory stc on (stc.SubtypeCategory_id = st.SubtypeCategory_id)
left join SurveySubtype sst on (sst.Subtype_id = st.Subtype_id and sst.Survey_id = @surveyid)
WHERE SurveyType_ID = @surveytypeid
and stc.SubtypeCategory_id = @subtypecategory


GO


