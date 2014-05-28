CREATE PROCEDURE [dbo].[csp_GetScaleItemTextExtractData] 
	@ExtractFileID int
AS
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 4 -- SurveyQuestions

--    declare @ExtractFileID int
--	set @ExtractFileID = 1
	
	-- RETRIEVE ALL SCALE ITEMS FOR SELECTED QUESTIONS!!!
	-- NOTE: In ExtractQueue, PKey1 is SELQSTN_ID and PKey2 is SURVEY_ID
	-- NOTE:  The SP was changed on 8/12/08 by k nussrallah due to a 8/11/08 conference call with NRC.  
	--        It was decided that scale items had to be unique for the browser language (as containded in the DataMart Language table).
	--		  Hence, the group by statement was added.  	
      

       select convert(varchar,scaleItemText.QSTNCORE) + ',' + convert(varchar,scaleItemText.SURVEY_ID) + ',' + convert(varchar,scaleItemText.val) as scaleitemid 
		,lang,rtrim(scaleItemText2.LABEL) as value,ExtractHistoryID
        into #temp
--		from (	select sq.SELQSTNS_ID,sq.SURVEY_ID,sq.SCALEID,scaleItemText.item,scaleItemText.val,
        from (	select sq.QSTNCORE,sq.SURVEY_ID,sq.SCALEID,scaleItemText.item,scaleItemText.val,
	  				dbo.fn_LanguageKey(scaleItemText.LANGUAGE) as lang
                   ,Min(scaleItemText.LANGUAGE) As LANGUAGE
                   ,Max(ExtractHistoryID) As ExtractHistoryID
				from QP_PROD.dbo.SEL_SCLS scaleItemText with (NOLOCK)
					inner join QP_PROD.dbo.SEL_QSTNS sq with (NOLOCK)
						on scaleItemText.SURVEY_ID = sq.SURVEY_ID and scaleItemText.QPC_ID = sq.SCALEID
						and scaleItemText.language = sq.language--lang. added 7/30 by kmn
					inner join ExtractHistory eh with (NOLOCK)
						on sq.SELQSTNS_ID = eh.PKey1 and sq.SURVEY_ID = eh.PKey2
				where eh.ExtractFileID = @ExtractFileID
					and eh.EntityTypeID = @EntityTypeID
					and eh.IsDeleted = 0
					and scaleItemText.LABEL is not null
					and scaleItemText.intresptype = 1					
--				group by sq.SELQSTNS_ID,sq.SURVEY_ID,sq.SCALEID,scaleItemText.item,scaleItemText.val,dbo.fn_LanguageKey(scaleItemText.LANGUAGE) 
                group by sq.QSTNCORE,sq.SURVEY_ID,sq.SCALEID,scaleItemText.item,scaleItemText.val,dbo.fn_LanguageKey(scaleItemText.LANGUAGE) 
			 )scaleItemText
		inner join QP_PROD.dbo.SEL_SCLS scaleItemText2 with (NOLOCK)
			on scaleItemText.SURVEY_ID = scaleItemText2.SURVEY_ID and scaleItemText2.QPC_ID = scaleItemText.SCALEID
				and scaleItemText.item = scaleItemText2.item and scaleItemText.language = scaleItemText2.language--lang. added 7/30 by kmn 
				and scaleItemText.val = scaleItemText2.val
--	   for xml auto, elements


      declare @TestString nvarchar(40)
      SET @TestString = '%[' + NCHAR(0) + NCHAR(1) + NCHAR(2) + NCHAR(3) + NCHAR(4) + NCHAR(5) + NCHAR(6) + NCHAR(7) + NCHAR(8) + NCHAR(11) + NCHAR(12) + NCHAR(14) + NCHAR(15) + NCHAR(16) + NCHAR(17) + NCHAR(18) + NCHAR(19) + NCHAR(20) + NCHAR(21) + NCHAR(22) + NCHAR(23) + NCHAR(24) + NCHAR(25) + NCHAR(26) + NCHAR(27) + NCHAR(28) + NCHAR(29) + NCHAR(30) + NCHAR(31) + ']%'

	 insert into ExtractHistoryError
     select eh.*,'csp_GetScaleItemTextExtractData' As Source,value
     from #temp scaleText with (NOLOCK)
     Inner Join ExtractHistory eh with (NOLOCK)
	   on scaleText.ExtractHistoryID = eh.ExtractHistoryID
     where PATINDEX (@TestString, value COLLATE Latin1_General_BIN) > 0 

    
     select scaleitemid ,scaleItemText.lang,value
     from #temp as scaleItemText with (NOLOCK)
     where PATINDEX (@TestString, value COLLATE Latin1_General_BIN) = 0 
	 for xml auto,elements

     drop table #temp


