/****** Object:  StoredProcedure [dbo].[insert_Criteria]    Script Date: 08/09/2006 16:29:32 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Criteria]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_Criteria]
GO
/****** Object:  StoredProcedure [dbo].[insert_Criteria]    Script Date: 08/09/2006 16:29:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Criteria]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [insert_Criteria]
	(@CriteriaID 	[int] output,
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
AS
BEGIN

-- insert row, so criteria id is known
INSERT INTO [QMS].[dbo].[Criteria] 
	 ( [CriteriaName],
	 [SurveyID],
	 [CriteriaTypeID],
	 [AnswerCategoryID],
	 [CriteriaDataTypeID],
	 [ParameterName],
	 [TextValue],
	 [ReferenceCriteriaID],
	 [ReferenceCriteriaSequence],
	 [Flag]) 
 
VALUES 
	( @CriteriaName,
	 @SurveyID,
	 @CriteriaTypeID,
	 @AnswerCategoryID,
	 @CriteriaDataTypeID,
	 @ParameterName,
	 @TextValue,
	 @ReferenceCriteriaID,
	 @ReferenceCriteriaSequence,
	 @Flag)

SET @CriteriaID = @@IDENTITY

END

' 
END
GO
