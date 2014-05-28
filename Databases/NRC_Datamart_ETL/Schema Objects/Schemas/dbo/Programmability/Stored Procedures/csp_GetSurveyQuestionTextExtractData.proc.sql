CREATE PROCEDURE [dbo].[csp_GetSurveyQuestionTextExtractData] 
	@ExtractFileID int
	--exec csp_GetSurveyQuestionTextExtractData 1029
AS
	SET NOCOUNT ON 
	
--    declare @ExtractFileID int
--    set @ExtractFileID = 99999

	declare @EntityTypeID int
	set @EntityTypeID = 4 -- SurveyQuestions

    -- NOTE: In ExtractHistory, PKey1 is SELQSTN_ID and PKey2 is SURVEY_ID
    -- NOTE:  The SP was changed on 8/12/08 by k nussrallah due to a 8/11/08 conference call with NRC.  
	--        It was decided that scale items had to be unique for the browser language (as containded in the DataMart Language table).
	--		  Hence, the group by statement was added.  	
    -- NOTE2:  The SP was changed on 9/18/08 by k nussrallah. The change was to use questioncore, not SELQSTNS_ID, as	
    --        part of the unique identifier 	
    
    IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#temp')) 
    DROP TABLE #temp

   --bubble questions
    select convert(varchar,questionText.QSTNCORE) + ',' + convert(varchar,questionText.SURVEY_ID) as surveyquestionid, 
			questionText.lang, 
			IsNull(questionText2.strfullquestion,space(0)) as value
			,ExtractHistoryID 
    into #temp
	from (
		  select questionText.QSTNCORE,questionText.SURVEY_ID
		   ,Min(questionText.LANGUAGE) As LANGUAGE,dbo.fn_LanguageKey(LANGUAGE) as lang
           ,Max(ExtractHistoryID) As ExtractHistoryID
		  from QP_PROD.dbo.SEL_QSTNS questionText with (NOLOCK)
				inner join ExtractHistory eh with (NOLOCK)
					on questionText.SELQSTNS_ID = eh.PKey1 and questionText.SURVEY_ID = eh.PKey2
		 where eh.ExtractFileID = @ExtractFileID
		   and eh.EntityTypeID = @EntityTypeID
		   and questionText.subtype = 1--bubble questions
		   and strfullquestion is not null 
		   and eh.IsDeleted = 0
   		   and exists(select 1 
					  from QP_Prod.dbo.SEL_SCLS sc with (NOLOCK)
					  where sc.QPC_ID = questionText.SCALEID 
					   and sc.SURVEY_ID = questionText.SURVEY_ID
					   and sc.LANGUAGE = questionText.LANGUAGE
					   and sc.intresptype = 1) -- Remove Short Answer Questions
		 group by questionText.QSTNCORE,questionText.SURVEY_ID,dbo.fn_LanguageKey(LANGUAGE)		
	 ) questionText
	 inner join QP_PROD.dbo.SEL_QSTNS questionText2 with (NOLOCK)
	   on questionText.QSTNCORE = questionText2.QSTNCORE and questionText.SURVEY_ID = questionText2.SURVEY_ID
	   and questionText.LANGUAGE = questionText2.LANGUAGE
      where questionText2.subtype = 1--bubble questions
    	
	--select * from #temp  
	
	
    IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#temp2')) 
    DROP TABLE #temp2
	
   
 --added 4/21/09, based on issue Questions with NULL strFullQuestion column value,excludes comment questions
    --insert
	select convert(varchar,questionText.QSTNCORE) + ',' + convert(varchar,questionText.SURVEY_ID) as surveyquestionid, 
				questionText.lang as lang,
				questionText2.label,ExtractHistoryID 
				--,
				--IsNull(label.strfullquestion,space(0)) as value,ExtractHistoryID    
     into #temp2				
	--select * 
	 from (
			select questionText.QSTNCORE,questionText.SURVEY_ID
			   ,Min(questionText.LANGUAGE) As LANGUAGE,dbo.fn_LanguageKey(LANGUAGE) as lang
			   ,Max(ExtractHistoryID) As ExtractHistoryID
			  from ExtractHistory eh with (NOLOCK)
			  inner join QP_PROD.dbo.SEL_QSTNS questionText with (NOLOCK)
			   on questionText.SELQSTNS_ID = eh.PKey1 and questionText.SURVEY_ID = eh.PKey2          
			 where eh.ExtractFileID = @ExtractFileID
			   and eh.EntityTypeID = @EntityTypeID
			   --and ( (questionText.subtype = 4 and questionText.height > 0 ) -- ignore "0-line" question
               -- or questionText.subtype = 1 ) 
               and questionText.subtype = 1  
			   and strfullquestion is null 
			   and eh.IsDeleted = 0
			  group by questionText.QSTNCORE,questionText.SURVEY_ID,dbo.fn_LanguageKey(LANGUAGE)
		 ) questionText
	 inner join QP_PROD.dbo.SEL_QSTNS questionText2 with (NOLOCK)
	   on questionText.QSTNCORE = questionText2.QSTNCORE and questionText.SURVEY_ID = questionText2.SURVEY_ID
	   and questionText.LANGUAGE = questionText2.LANGUAGE	
	----where (questionText2.subtype = 4 and questionText2.height > 0 ) Or questionText2.subtype = 1--bubble questions
	where questionText2.subtype = 1--bubble questions
	
	--select *
	--from #temp2		
	--print '#temp2	'	
	
    IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#tempLabel')) 
    DROP TABLE #tempLabel
	
	 select questionText2.label,max(questionText2.strFullQuestion) as strFullQuestion
	 into  #tempLabel	 
	  from ExtractHistory eh with (NOLOCK)
	  inner join QP_PROD.dbo.SEL_QSTNS questionText with (NOLOCK)
	   on questionText.SELQSTNS_ID = eh.PKey1 and questionText.SURVEY_ID = eh.PKey2      
	  inner join QP_PROD.dbo.SEL_QSTNS questionText2 with (NOLOCK) on  questionText.label = questionText2.label
	  where eh.ExtractFileID = @ExtractFileID
		  and eh.EntityTypeID = @EntityTypeID
				   --and (( questionText.subtype = 4 and questionText.height > 0 )-- ignore "0-line" question
					--            or questionText.subtype = 1 ) 
				   and questionText.subtype = 1 
				   and questionText.strfullquestion is null 
				   and eh.IsDeleted = 0
				   and questionText2.language = 1 and questionText2.strFullQuestion Is Not Null
	 group by questionText2.label 
			
	--select *
	--from #tempLabel		
	--print '#tempLabel'
	
	insert into #temp
	select surveyquestionid, questionText.lang as lang,IsNull(label.strfullquestion,space(0)) as value,ExtractHistoryID   	
	from #temp2 questionText
	inner join #tempLabel label on questionText.label = label.label	
	
	drop table #temp2 
	drop table #tempLabel
	
	--select *
	--from #temp
		
	---comment questions
	insert into #temp ( surveyquestionid,lang,value,ExtractHistoryID   )
	select convert(varchar,questionText.QSTNCORE) + ',' + convert(varchar,questionText.SURVEY_ID) as surveyquestionid, 
			questionText.lang as lang, 
			IsNull(IsNull(questionText2.strfullquestion,questionText2.LABEL),space(0)) as value
			,ExtractHistoryID    
	from (	
			select questionText.SELQSTNS_ID,questionText.QSTNCORE,questionText.SURVEY_ID
			   ,Min(questionText.LANGUAGE) As LANGUAGE,dbo.fn_LanguageKey(LANGUAGE) as lang
			   ,Max(ExtractHistoryID) As ExtractHistoryID
			  from QP_PROD.dbo.SEL_QSTNS questionText with (NOLOCK)
			  inner join ExtractHistory eh with (NOLOCK)
			   on questionText.SELQSTNS_ID = eh.PKey1 and questionText.SURVEY_ID = eh.PKey2
			 where eh.ExtractFileID = @ExtractFileID
			   and eh.EntityTypeID = @EntityTypeID
			   and questionText.subtype = 4--comment questions
			   and questionText.height > 0 -- ignore "0-line" question
			   --and strfullquestion is not null 
			   and eh.IsDeleted = 0
			  group by questionText.SELQSTNS_ID,questionText.QSTNCORE,questionText.SURVEY_ID,dbo.fn_LanguageKey(LANGUAGE)
			   ) questionText
	  inner join QP_PROD.dbo.SEL_QSTNS questionText2 with (NOLOCK)
	   on questionText.SELQSTNS_ID = questionText2.SELQSTNS_ID and questionText.SURVEY_ID = questionText2.SURVEY_ID
	   --and questionText.LANGUAGE = questionText2.LANGUAGE
	   and questionText2.LANGUAGE = 1--comemnts
     where questionText2.subtype = 4 and questionText2.height > 0 
 
     declare @TestString nvarchar(40)
     SET @TestString = '%[' + NCHAR(0) + NCHAR(1) + NCHAR(2) + NCHAR(3) + NCHAR(4) + NCHAR(5) + NCHAR(6) + NCHAR(7) + NCHAR(8) + NCHAR(11) + NCHAR(12) + NCHAR(14) + NCHAR(15) + NCHAR(16) + NCHAR(17) + NCHAR(18) + NCHAR(19) + NCHAR(20) + NCHAR(21) + NCHAR(22) + NCHAR(23) + NCHAR(24) + NCHAR(25) + NCHAR(26) + NCHAR(27) + NCHAR(28) + NCHAR(29) + NCHAR(30) + NCHAR(31) + ']%'

	 insert into ExtractHistoryError
     select eh.*,'csp_GetSurveyQuestionTextExtractData' As Source,value
     from #temp questionText with (NOLOCK)
     Inner Join ExtractHistory eh with (NOLOCK)
	   on questionText.ExtractHistoryID = eh.ExtractHistoryID
     where PATINDEX (@TestString, value COLLATE Latin1_General_BIN) > 0 

     select surveyquestionid,questionText.lang,value
     from #temp as questionText with (NOLOCK)
     where PATINDEX (@TestString, value COLLATE Latin1_General_BIN) = 0 
	 for xml auto,elements
--
     drop table #temp


