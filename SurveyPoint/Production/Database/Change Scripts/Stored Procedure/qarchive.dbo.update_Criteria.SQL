/****** Object:  StoredProcedure [dbo].[update_Criteria]    Script Date: 08/09/2006 12:54:39 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Criteria]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_Criteria]
GO
/****** Object:  StoredProcedure [dbo].[update_Criteria]    Script Date: 08/09/2006 12:54:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Criteria]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [update_Criteria]
	(@CriteriaID 	[int],
	 @CriteriaName 	[char](100),
	 @SurveyID 	[int],
	 @CriteriaTypeID 	[int],
	 @AnswerCategoryID 	[int],
	 @CriteriaDataTypeID 	[smallint],
	 @ParameterName 	[varchar](100),
	 @TextValue 	[varchar](1000),
	 @ReferenceCriteriaID 	[int],
	 @ReferenceCriteriaSequence 	[int],
	 @Flag 	[int])

AS UPDATE [QMS].[dbo].[Criteria] 

SET   [CriteriaName]	 = @CriteriaName,
	 [SurveyID]	 = @SurveyID,
	 [CriteriaTypeID]	 = @CriteriaTypeID,
	 [AnswerCategoryID]	 = @AnswerCategoryID,
	 [CriteriaDataTypeID]	 = @CriteriaDataTypeID,
	 [ParameterName]	 = @ParameterName,
	 [TextValue]	 = @TextValue,
	 [ReferenceCriteriaID]	 = @ReferenceCriteriaID,
	 [ReferenceCriteriaSequence]	 = @ReferenceCriteriaSequence,
	 [Flag]	 = @Flag 

WHERE 
	( [CriteriaID]	 = @CriteriaID)



' 
END
GO
