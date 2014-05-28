CREATE PROCEDURE [dbo].[csp_GetSurveyQuestionExtractData] 
	@ExtractFileID int
AS
	SET NOCOUNT ON 

--    declare @ExtractFileID int
--	set @ExtractFileID = 1 
	
	declare @EntityTypeID int
	set @EntityTypeID = 4 -- SurveyQuestion

    
	
	-- NOTE: In ExtractQueue, PKey1 is SELQSTNS_ID and PKey2 is SURVEY_ID
    
	create table #ttt (
		SELQSTNS_ID int not null, 
		SURVEY_ID int not null,
		SCALEID int null,
		nrcQuestionCore int null, 
		responseType nvarchar(50) null, 
		isMeanable bit null, 
		sectionNum smallint null,
		sectionName nvarchar(60) null,
		subSectionNum smallint null,
		itemNum smallint null,
		deleteEntity varchar(10) not null)

	-- Insert bubble/short answer questions (subtype=1)
	insert #ttt
		select eh.PKey1, eh.PKey2, min(surveyQuestion.SCALEID) as SCALEID,
				min(surveyQuestion.QSTNCORE) as nrcQuestionCore,
				case
					when min(surveyQuestion.NUMMARKCOUNT) = 1 then 'Single Selection'
					else 'Multiple Selection' 
				end as responseType 
				,min(convert(tinyint,surveyQuestion.BITMEANABLE)) as isMeanable 
				,min(surveyQuestion.SECTION_ID) as sectionNum
				,null as sectionName,min(SUBSECTION) as subSectionNum,min(ITEM) as itemNum
				,'false' as deleteEntity
		  from QP_PROD.dbo.SEL_QSTNS surveyQuestion with (NOLOCK)
				inner join (select distinct PKey1 , PKey2
                            from ExtractHistory  with (NOLOCK) 
                            where ExtractFileID = @ExtractFileID
	                        and EntityTypeID = @EntityTypeID
	                        and IsDeleted = 0 ) eh 
					on surveyQuestion.SELQSTNS_ID = eh.PKey1 and surveyQuestion.SURVEY_ID = eh.PKey2
		 where surveyQuestion.subtype = 1
	   	   and exists(select 1 
						from QP_Prod.dbo.SEL_SCLS sc 
					   where sc.QPC_ID = surveyQuestion.SCALEID 
						 and sc.SURVEY_ID = surveyQuestion.SURVEY_ID
						 and sc.intresptype = 1) -- Remove Short Answer Questions
		 group by eh.PKey1, eh.PKey2

	-- Insert comment questions (subtype=4)
	insert #ttt
		select distinct eh.PKey1, eh.PKey2, surveyQuestion.SCALEID as SCALEID
				,surveyQuestion.QSTNCORE as nrcQuestionCore
				,'Comment' as responseType, 0 as isMeanable
				, surveyQuestion.SECTION_ID as sectionNum
				, null as sectionName,SUBSECTION as subSectionNum,ITEM as itemNum
				,'false' as deleteEntity
		  from QP_PROD.dbo.SEL_QSTNS surveyQuestion with (NOLOCK)
				inner join (select distinct PKey1 , PKey2
                            from ExtractHistory  with (NOLOCK) 
                            where ExtractFileID = @ExtractFileID
	                        and EntityTypeID = @EntityTypeID
	                        and IsDeleted = 0 ) eh
					on surveyQuestion.SELQSTNS_ID = eh.PKey1 and surveyQuestion.SURVEY_ID = eh.PKey2
		 where surveyQuestion.subtype = 4
		   and surveyQuestion.height > 0 -- ignore "0-line comments"

--changed 4/21 kmn- based on issue Questions with NULL strFullQuestion column value
--		select eh.PKey1, eh.PKey2, min(surveyQuestion.SCALEID) as SCALEID,
--				min(surveyQuestion.QSTNCORE) as nrcQuestionCore,
--				'Comment' as responseType, 
--				0 as isMeanable, min(surveyQuestion.SECTION_ID) as sectionNum, null as sectionName,
--				'false' as deleteEntity
--		  from QP_PROD.dbo.SEL_QSTNS surveyQuestion with (NOLOCK)
--				inner join (select distinct PKey1 , PKey2
--                            from ExtractHistory  with (NOLOCK) 
--                            where ExtractFileID = 286--@ExtractFileID
--	                        and EntityTypeID = 4--@EntityTypeID
--	                        and IsDeleted = 0 
--                             and PKey1 = 443	and PKey2 = 7298) eh
--					on surveyQuestion.SELQSTNS_ID = eh.PKey1 and surveyQuestion.SURVEY_ID = eh.PKey2
--		 where surveyQuestion.subtype = 4
--		   and surveyQuestion.height > 0 -- ignore "0-line comments"
--		 group by eh.PKey1, eh.PKey2
		 
	-- Update Section Names
	update #ttt
	   set SectionName = rtrim(sq.Label)
	  from #ttt
			inner join QP_Prod.dbo.SEL_QSTNS sq with (NOLOCK) on #ttt.sectionNum = sq.SECTION_ID and #ttt.SURVEY_ID = sq.SURVEY_ID
	 where sq.subtype = 3
	
	-- Add records to be deleted
	insert #ttt
		select distinct PKey1, PKey2,
			null as SCALEID,
			null as nrcQuestionCore, 
			null as responseType, 
			null as isMeanable, 
			null as sectionNum,
			null as sectionName,
			null as subSectionNum,
			null as itemNum,
			'true' as deleteEntity
		  from ExtractHistory with (NOLOCK)
		 where ExtractFileID = @ExtractFileID
		   and EntityTypeID = @EntityTypeID
		   and IsDeleted <> 0
    	   	

	select convert(nvarchar,surveyQuestion.nrcQuestionCore) + ',' + convert(nvarchar,surveyQuestion.SURVEY_ID) as id, 
			surveyQuestion.SURVEY_ID as surveyid, 
			surveyQuestion.nrcQuestionCore, 
			surveyQuestion.responseType, 
			surveyQuestion.isMeanable, 
			surveyQuestion.sectionNum, 
			surveyQuestion.sectionName, 
			surveyQuestion.subSectionNum,
			surveyQuestion.itemNum,
			surveyQuestion.deleteEntity
	  from #ttt surveyQuestion with (NOLOCK)
	   for xml auto
	   
	drop table #ttt


