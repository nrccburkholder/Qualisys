CREATE PROCEDURE [dbo].[csp_GetScaleItemExtractData] 
	@ExtractFileID int
AS
	SET NOCOUNT ON  
		
	declare @EntityTypeID int
	set @EntityTypeID = 4 -- SurveyQuestions

--    declare @ExtractFileID int
--	set @ExtractFileID = 1 
	
	-- RETRIEVE ALL SCALE ITEMS FOR SELECTED QUESTIONS!!!
	-- NOTE: In ExtractQueue, PKey1 is SELQSTN_ID and PKey2 is SURVEY_ID

	create table #ttt (
		QSTNCORE int not null, 
		SURVEY_ID int not null, 
		QPC_ID int not null,
		ITEM int null,
		ResponseValue int null, 
		ScaleOrder int null, 
		ScaleRank int null, 
		isMissing bit null)

	  insert #ttt
		select sq.QSTNCORE, eh.PKey2, min(ss.QPC_ID), ss.ITEM, min(ss.VAL), min(ss.SCALEORDER), NULL, min(convert(tinyint,MISSING))	
        --select eh.PKey1, eh.PKey2, min(ss.QPC_ID), ss.ITEM, min(ss.VAL), min(ss.SCALEORDER), NULL, min(convert(tinyint,MISSING)) kmn 9/18	  
      from QP_PROD.dbo.SEL_SCLS ss With (NOLOCK)
				inner join QP_PROD.dbo.SEL_QSTNS sq With (NOLOCK)
					on ss.SURVEY_ID = sq.SURVEY_ID and ss.QPC_ID = sq.SCALEID 
                     and ss.language = sq.language--lang. added 7/30 by kmn
				inner join (select distinct PKey1 ,PKey2
                        from ExtractHistory  with (NOLOCK) 
                         where ExtractFileID = @ExtractFileID
	                     and EntityTypeID = @EntityTypeID
	                     and IsDeleted = 0 ) eh 
					on sq.SELQSTNS_ID = eh.PKey1 and sq.SURVEY_ID = eh.PKey2
		 where ss.intresptype = 1        
		 group by sq.QSTNCORE, eh.PKey2,ss.ITEM
         --group by eh.PKey1, eh.PKey2,ss.ITEM

	-- Ignore deleted survey questions.  Their items will be cleaned up as orphaned records.
    	   	
	select convert(varchar,surveyQuestionScaleItem.QSTNCORE) + ',' + convert(varchar,surveyQuestionScaleItem.SURVEY_ID) + ',' + convert(varchar,surveyQuestionScaleItem.responseValue) as id, 
		   convert(varchar,surveyQuestionScaleItem.QSTNCORE) + ',' + convert(varchar,surveyQuestionScaleItem.SURVEY_ID) as surveyquestionid, 
		   surveyQuestionScaleItem.responseValue as responseValue, 
		   surveyQuestionScaleItem.isMissing as isMissing, 
		   surveyQuestionScaleItem.scaleOrder as scaleOrder, 
		   surveyQuestionScaleItem.scaleRank as scaleRank
	  from #ttt surveyQuestionScaleItem with (NOLOCK)
	   for xml auto
	
	drop table #ttt


