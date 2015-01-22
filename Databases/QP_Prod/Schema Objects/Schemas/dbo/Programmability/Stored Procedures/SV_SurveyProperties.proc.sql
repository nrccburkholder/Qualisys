/***********************************************************************************************************
Proc: SV_SurveyProperties
Created: ???
Purpose: called during survey validation.  This proc checks for generic rules that apply to all surveys 
		 contained within Qualisys

Modified:
	MWB 12/21/2009
		Added Householding field checks if householding is turned on.  
	MWB 03/11/2010
		Modified qstncore count to look at both Qualisys and Datamart for total questions.
		Does not account for questions that may have been removed from the datamart questions table.
	CJB 08/29/2014
		Added check for those survey types requiring USPS Address Change service 
  
***********************************************************************************************************/  
CREATE PROCEDURE [dbo].[SV_SurveyProperties]    
@Survey_id INT    
AS    

declare @Study_ID int, @qstncoreCnt int
    
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(100))    
Create table #tot_Qstncores (qstncore int, Type Varchar(1))  

IF NOT EXISTS(SELECT * FROM survey_def WHERE Survey_id=@Survey_id AND cutofftable_id=SampleEncounterTable_id and cutofffield_id=SampleEncounterField_id)    
INSERT INTO #M (Error, strMessage)    
SELECT 2 Error,'Sample Encounter Date Field and Report Date Field are different.'    
ELSE    
INSERT INTO #M (Error, strMessage)    
SELECT 0 Error,'Sample Encounter Date Field and Report Date Field are the same.'    

--===================================================================================
--CHECK TOTAL NUMBER OF QUESTIONS TO MAKE SURE THEY ARE NOT OVER THE 1024 LIMIT

Select @Study_ID = Study_Id from SURVEY_DEF where SURVEY_ID = @Survey_id

  
insert into #tot_Qstncores    
select distinct sq.qstncore, 'Q'  
from sel_qstns sq  
where sq.SURVEY_ID in (SELECT SURVEY_ID from SURVEY_DEF where STUDY_ID = @study_Id)
and sq.qstncore > 0
  
insert into #tot_Qstncores    
select distinct q.qstncore, 'D'  
from datamart.qp_comments.dbo.questions q    
where q.SURVEY_ID in (SELECT SURVEY_ID from datamart.qp_comments.dbo.clientstudysurvey where STUDY_ID = @study_Id)    
and q.qstncore > 0


Select @qstncoreCnt = COUNT(DISTINCT qstncore) from #tot_Qstncores

if (@qstncoreCnt) > 1000  
 BEGIN  
  INSERT INTO #M (Error, strMessage)    
  SELECT 1 Error,'Qstncore count is greater than 1000.  Please do not exceed 1000'    
 END  
ELSE    
 BEGIN  
  if (@qstncoreCnt) > 700  
  INSERT INTO #M (Error, strMessage)    
  SELECT 2 Error,'Qstncore count is greater than 700.  Please do not exceed 1000'    
  ELSE    
  INSERT INTO #M (Error, strMessage)    
  SELECT 0 Error,'You currently have ' + cast(@qstncoreCnt as varchar(15)) + ' questions fielded for study_ID ' + cast(@study_Id as varchar(15))  
 END  

--END: CHECK TOTAL NUMBER OF QUESTIONS TO MAKE SURE THEY ARE NOT OVER THE 1024 LIMIT 
--===================================================================================
  

--Check for HouseHolding            
if exists 
	(
	SELECT	'x'
	FROM	Survey_def sd         
	WHERE	sd.Survey_id=@Survey_id and 
			strHouseholdingType <> 'N'                       
	)     
BEGIN       
	--Check to make sure Addr, Addr2, City, St, Zip5 are householding columns                
	INSERT INTO #M (Error, strMessage)                
	SELECT 1,'When Householding is turned on ' + strField_nm+ ' must be an included householding column.'                
	FROM (Select strField_nm, Field_id FROM MetaField WHERE strField_nm IN ('Addr','Addr2','City','ST','Zip5')) a                
	  LEFT JOIN HouseHoldRule hhr                
	ON a.Field_id=hhr.Field_id                
	AND hhr.Survey_id=@Survey_id                
	WHERE hhr.Field_id IS NULL           
END

if dbo.SurveyProperty('UseUSPSAddrChangeServiceDefault', null, @Survey_id) = 1
BEGIN
	if exists(select 1 from survey_def where UseUSPSAddrChangeService = 0 and survey_id = @Survey_id)
	insert into #M (Error, strMessage)
		select 1,'This survey must have USPS Address Change Service turned on'
	else
	insert into #M (Error, strMessage)
		select 0,'This survey does have USPS Address Change Service turned on as it should'

	declare @FirstStepCover varchar(42)

	select @firstStepCover=rtrim(description)
	from (                  select distinct st.CoverID, st.Language, sc.description
							from sel_cover sc
							inner join sel_textbox st on sc.survey_id=st.survey_id and sc.selcover_id=st.coverid
							inner join mailingmethodology mm on st.survey_id=mm.survey_id
							inner join mailingstep ms on mm.methodology_id=ms.methodology_id and st.coverid=ms.selcover_id
							where st.survey_id=@survey_id
							and ms.intSequence=1) coverlang
	left outer join (select distinct st.CoverID, st.Language
							from sel_textbox st 
							inner join mailingmethodology mm on st.survey_id=mm.survey_id
							inner join mailingstep ms on mm.methodology_id=ms.methodology_id and st.coverid=ms.selcover_id
							where st.survey_id=@survey_id
							and ms.intSequence=1
							and st.richtext like '%ELECTRONIC SERVICE REQUESTED%') esr
		  on coverlang.coverid=esr.coverid and coverlang.language=esr.language
	where esr.coverid is null

	if @@rowcount>0
	  	insert into #M (Error, strMessage)
		select 1,'The phrase "ELECTRONIC SERVICE REQUESTED" isn''t on the "'+@firstStepCover+'" cover letter'
	else
	  	insert into #M (Error, strMessage)
		select 0,'The phrase "ELECTRONIC SERVICE REQUESTED" was found on the first letter'

END
    
SELECT * FROM #M    
    
DROP TABLE #M


