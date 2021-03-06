/****** Object:  StoredProcedure [dbo].[compute_SeniorRiskFactorDummyQuestion]    Script Date: 08/08/2006 15:58:39 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[compute_SeniorRiskFactorDummyQuestion]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[compute_SeniorRiskFactorDummyQuestion]
GO
/****** Object:  StoredProcedure [dbo].[compute_SeniorRiskFactorDummyQuestion]    Script Date: 08/08/2006 15:58:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[compute_SeniorRiskFactorDummyQuestion]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE    PROCEDURE compute_SeniorRiskFactorDummyQuestion(@RespondentID int)
AS
BEGIN

SET NOCOUNT ON

DECLARE @AdvancedDirectives	int
DECLARE @PowerOfAttorney	int
DECLARE @LivingWill		int
DECLARE @ManyMeds		int
DECLARE @MedCount		varchar(1000)
DECLARE @Depression		int
DECLARE @Male			int
DECLARE @Age			varchar(10)
DECLARE @Age75to79		int
DECLARE @Age80to84		int
DECLARE @Age85orOlder		int
DECLARE @HelpWithForm	int
DECLARE @ActivityHelper	int
DECLARE @HelperInfo		varchar(1000)
DECLARE @AcitivityHelperInfo	varchar(1000)

SET SELECT
@AdvancedDirectives	= CASE WHEN dbo.GetResponseAnswerCategorySelected(@RespondentID, ''Advance directives, etc?'', 1) = 1 THEN 0 ELSE 1 END, 
@PowerOfAttorney	= CASE WHEN dbo.GetResponseAnswerCategorySelected(@RespondentID, ''Advance directives, etc?'', 2) = 1 THEN 0 ELSE 1 END, 
@LivingWill		= CASE WHEN dbo.GetResponseAnswerCategorySelected(@RespondentID, ''Advance directives, etc?'', 3) = 1 THEN 0 ELSE 1 END, 
@ManyMeds		= dbo.GetResponseAnswerCategorySelected(@RespondentID, ''How many medicines taken regularly?'', 4), 
@Depression		= CASE WHEN CAST(dbo.GetRespondentPropertyValue(@RespondentID, ''DEPRESSION_SCORE'') AS int) >= 2 THEN 1 ELSE 0 END,
@Male			= CASE WHEN UPPER(Gender) = ''M'' THEN 1 ELSE 0 END,
@Age			= CAST(dbo.GetAge(DOB, GETDATE()) AS varchar(10)), 
@Age75to79		= CASE WHEN dbo.GetAge(DOB, GETDATE()) BETWEEN 75 AND 79 THEN 1 ELSE 0 END, 
@Age80to84		= CASE WHEN dbo.GetAge(DOB, GETDATE()) BETWEEN 80 AND 84 THEN 1 ELSE 0 END, 
@Age85orOlder		= CASE WHEN dbo.GetAge(DOB, GETDATE()) >= 85 THEN 1 ELSE 0 END, 
@HelpWithForm		= dbo.GetResponseAnswerCategorySelected(@RespondentID, ''Help with form?'', 1), 
@ActivityHelper		= 0
FROM Respondents
WHERE RespondentID = @RespondentID

/* Check ''Help to complete form?'' question */
SET @HelperInfo = ''''
IF @HelpWithForm = 1 AND dbo.GetResponseAnswerCategorySelected(@RespondentID, ''May we call helper?'', 1) = 1	-- Had help completing form and may call helper
	SET @HelperInfo =  	ISNULL(dbo.GetResponseAnswerCategoryText(@RespondentID, ''Information on person who helped fill out form'', 1), '''') + 
				ISNULL('', '' + dbo.GetResponseAnswerCategoryText(@RespondentID, ''Information on person who helped fill out form'', 2), '''') + 
				ISNULL('', '' + dbo.GetResponseAnswerCategoryText(@RespondentID, ''Information on person who helped fill out form'', 3), '''')

/* Check Activity helper question */
SET @AcitivityHelperInfo = ''''
IF @ActivityHelper = 1
	SET @AcitivityHelperInfo =  ISNULL(dbo.GetResponseAnswerCategoryText(@RespondentID, ''Who is your helper?'', 1), '''') + 
				ISNULL('', '' + dbo.GetResponseAnswerCategoryText(@RespondentID, ''Who is your helper?'', 2), '''') + 
				ISNULL('', '' + dbo.GetResponseAnswerCategoryText(@RespondentID, ''Who is your helper?'', 3), '''')

/* Calculate Many meds */
SET @MedCount = ''''
IF @ManyMeds = 1 
	SET @MedCount = dbo.GetResponseText(@RespondentID,''Rxs'')

/* Comitt dummy question settings */
EXEC [dbo].[spSelectResponse] @RespondentID, ''Risk Factors Dummy'', 1, '''', @AdvancedDirectives
EXEC [dbo].[spSelectResponse] @RespondentID, ''Risk Factors Dummy'', 2, '''', @PowerOfAttorney
EXEC [dbo].[spSelectResponse] @RespondentID, ''Risk Factors Dummy'', 3, '''', @LivingWill
EXEC [dbo].[spSelectResponse] @RespondentID, ''Risk Factors Dummy'', 4, @MedCount, @ManyMeds
EXEC [dbo].[spSelectResponse] @RespondentID, ''Risk Factors Dummy'', 5, '''', @Depression
EXEC [dbo].[spSelectResponse] @RespondentID, ''Risk Factors Dummy'', 6, '''', @Male
EXEC [dbo].[spSelectResponse] @RespondentID, ''Risk Factors Dummy'', 7, @Age, 1
EXEC [dbo].[spSelectResponse] @RespondentID, ''Risk Factors Dummy'', 8, '''', @Age75to79
EXEC [dbo].[spSelectResponse] @RespondentID, ''Risk Factors Dummy'', 9, '''', @Age80to84
EXEC [dbo].[spSelectResponse] @RespondentID, ''Risk Factors Dummy'', 10, '''', @Age85orOlder
EXEC [dbo].[spSelectResponse] @RespondentID, ''Risk Factors Dummy'', 11, @HelperInfo, @HelpWithForm
EXEC [dbo].[spSelectResponse] @RespondentID, ''Risk Factors Dummy'', 12, @ActivityHelper, @AcitivityHelperInfo

EXEC insert_SeniorHealthScores @RespondentID

/* Legal None Property */
IF (@AdvancedDirectives + @PowerOfAttorney + @LivingWill) > 0
	EXEC dbo.spSetRespondentProperty @RespondentID, ''LEGAL_NONE'', ''2'' -- Yes Value
ELSE
	EXEC dbo.spSetRespondentProperty @RespondentID, ''LEGAL_NONE'', ''1'' -- No Value

SET NOCOUNT OFF

END
' 
END
GO
