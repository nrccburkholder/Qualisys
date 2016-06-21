/*************
S30_US10_T1_Update_Code800To926_HCAHPSOnly.sql

10	new spanish salutation code for HCAHPS 	
as client service team I want HCAHPS cover letters updated to use the new spanish personalization code	
need to respond to CMS by July 13

Update all HCAHPS survey Spanish cover letters to change personalization code 800 to 926

Created 07/10/2015 dmp
	*****************/

--create table temp_dmp_Code800Update_log 
--(datUpdated datetime, survey_id int, qpc_id int, lang_id int, richtext_before varchar(max), richtext_after varchar(max))

--drop table temp_dmp_Code800Update_log 


/***** testing 5 at a time *****/
--select distinct sd.survey_id
--into #surveysX
--from survey_def sd, CODETXTBOX ct
--where sd.SURVEY_ID = ct.SURVEY_ID
--and sd.SurveyType_id = 2
--and ct.CODE = 800

--select top 5 SURVEY_ID
--into #surveys 
--from #surveysX 

--delete sx
--from #surveysX sx, #surveys s
--where sx.SURVEY_ID = s.SURVEY_ID

/********************************/

/*********Just do one survey *********/

--create table #surveys (survey_id int)

--insert into #surveys (SURVEY_ID)
--values (7995)

/********************************/


----Get a list of HCAHPS surveys using code 800
--select distinct sd.survey_id
--into #surveys
--from survey_def sd, CODETXTBOX ct
--where sd.SURVEY_ID = ct.SURVEY_ID
--and sd.SurveyType_id = 2
--and ct.CODE = 800

--select * from #surveys

--drop table #surveys
--drop table #surveysX

--select * from temp_dmp_Code800Update_log

/***************/

declare @survey int

--Loop through the surveys
select top 1 @survey =  survey_id from #surveys

while @@ROWCOUNT > 0
begin

print @survey
	
	--Get the text boxes with code 800 & put into table var
	declare @QPCIDs table (qpc_id int, lang_id int)
	insert into @QPCIDs
	select qpc_id, LANGUAGE from sel_textbox
	where survey_id = @survey
	and richtext like '%{800\}%'

select * from @QPCIDs

	declare @qpc_id int
	declare @lang_id int

	--Loop through the textboxes to update each one in sel_textbox
	--Have to include lang, since all languages have the same QPCID
	select top 1 @qpc_id = qpc_id, @lang_id = lang_id from @QPCIDs

	while @@rowcount > 0
	begin

		declare @richtext varchar(max)
		select @richtext = richtext
		from sel_textbox
		where survey_id = @survey
		and qpc_id = @qpc_id
		and LANGUAGE = @lang_id

		--Log the original text
		insert into temp_dmp_Code800Update_log (datupdated, survey_id, qpc_id, lang_id, richtext_before)
		select getdate(), @survey, @qpc_id, @lang_id, @richtext

print @richtext
		
		--replace the code
		select @richtext = replace(@richtext, '{800\}', '{926\}')

		--log the updated text
		update temp_dmp_Code800Update_log
		set richtext_after = @richtext
		where survey_id = @survey
		and qpc_id = @qpc_id
		and lang_id = @lang_id
		

print @richtext
		
		--update sel_textbox
		update sel_textbox
		set RICHTEXT = @richtext
		where survey_id = @survey
		and qpc_id = @qpc_id
		and language = @lang_id

		delete from @QPCIDs where qpc_id = @qpc_id and lang_id = @lang_id

		select top 1 @qpc_id = qpc_id, @lang_id = lang_id from @QPCIDs

	continue
	end


	--update codetxtbox to replace 800 w/ 926
	update codetxtbox
	set code = 926
	where survey_id = @survey
	and code = 800

	delete from #surveys where survey_id = @survey

	select top 1 @survey =  survey_id from #surveys

continue
end

