CREATE PROCEDURE [dbo].[csp_ProcessSkipPatterns_HHCAHPS] 
	@ExtractFileID int
	--EXEC [dbo].[csp_ProcessSkipPatterns_HHCAHPS] 1806
AS
	SET NOCOUNT ON


	DECLARE @oExtractRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [InsertExtractRunLog] @ExtractFileID, @TaskName, @currDateTime1, @ExtractRunLogID = @oExtractRunLogID OUTPUT;
	

		--SELECT bt.[ExtractFileID]
		--,bt.[LithoCode]
		--,bt.[QUESTIONFORM_ID] 
		--,bt.[SAMPLEUNIT_ID]
		--,bt.[nrcQuestionCore]
		--,bt.[responseVal]
		--,s.STUDY_ID
		-- ,q38694RV.*
		--  ,q38726RV.*
		--,qp.*         
		----,qf.*,s.*
		UPDATE bt
		SET responseVal = CASE WHEN q38694RV.responseVal <> 1 AND bt.[responseVal] NOT IN (-4,-8,-9) AND bt.[responseVal] < 10000 AND bt.[nrcQuestionCore] <> 38694 THEN bt.[responseVal] + 10000 
							   WHEN q38726RV.responseVal <> 1 AND bt.[nrcQuestionCore] = 38727 AND bt.[responseVal] NOT IN (-4,-8,-9) AND bt.[responseVal] < 10000 THEN bt.[responseVal] + 10000 
							   ELSE bt.[responseVal] 
					      END
		FROM [NRC_DataMart_ETL].[dbo].[BubbleTemp] bt WITH (NOLOCK)
			INNER JOIN QP_Prod.dbo.QUESTIONFORM qf WITH (NOLOCK) ON qf.QUESTIONFORM_ID = bt.QUESTIONFORM_ID
			INNER JOIN QP_Prod.dbo.SURVEY_DEF s WITH (NOLOCK) ON qf.SURVEY_ID = s.SURVEY_ID
			INNER JOIN (SELECT DISTINCT bt.QUESTIONFORM_ID,bt.nrcQuestionCore , bt.responseVal
   						FROM  [NRC_DataMart_ETL].[dbo].[BubbleTemp] bt WITH (NOLOCK) 
						WHERE bt.nrcQuestionCore = 38694) q38694RV ON bt.QUESTIONFORM_ID = q38694RV.QUESTIONFORM_ID
			LEFT JOIN (SELECT DISTINCT bt.QUESTIONFORM_ID,bt.nrcQuestionCore , bt.responseVal
   					   FROM  [NRC_DataMart_ETL].[dbo].[BubbleTemp] bt WITH (NOLOCK) 
					   WHERE bt.nrcQuestionCore = 38726 ) q38726RV ON bt.QUESTIONFORM_ID = q38726RV.QUESTIONFORM_ID		 
		WHERE bt.ExtractFileID = @ExtractFileID AND s.SurveyType_id = 3 --HHCAHPS

  

  	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2

	RETURN


