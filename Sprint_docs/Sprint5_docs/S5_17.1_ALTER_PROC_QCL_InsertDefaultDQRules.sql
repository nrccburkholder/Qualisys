use qp_prod
go
alter table dbo.SurveyTypeDefaultCriteria add Subtype_id int
go
update dbo.SurveyTypeDefaultCriteria set Subtype_id=0
go
/*********************************************************************************************************************************
  ** Copyright (c) National Research Corporation
  ** Stored Procedure:  dbo.QCL_InsertDefaultDQRules
  ** Description:  Called by ConfigManagerUI.vbp, this SP calls dbo.QCL_InsertCriteriaStmt,
  **  dbo.QCL_InsertBusinessRule, and dbo.QCL_InsertDefaultCriteriaClause to add the standard disqualification
  **  criteria to a Survey.
  **
  ** Modified: 9/7/1999 - Daniel Vansteenburg - Added check to make sure the Field exists before adding DQ rule.
  ** Modified: 4/23/2001 - Brian Dohmen - Added null langid DQ rule.
  ** Modified: 9/09/2002 - Ron Niewohner - Added null MRN DQ rule.
  ** Modified: 7/14/2003 - Brian Dohmen - Added additional address DQ rules
  ** Modified: 5/06/2004 - Dan Christensen - Added strcriteriastring
  ** Modified: 6/03/2005 - Brian Dohmen - Added Address Error 420 rule
  ** Modified: 9/14/2005 - Brian Dohmen - Added Province and Postal_Code errors for Canada
  ** Modified: 7/31/2007 - Steve Spicka - Added Addl. DQ Rules (E505, E601)
  ** Modified: 1/13/2010 - Michael Beltz - modified CriteriaStmt code to change (( to ( and )) to ) b/c it was not
  **                       consistant with how where clasue generation box was creating sql statment
  ** Modified: 1/19/2010 - Michael Beltz - Added new DQ_QASAE and DQ_QASFA rules
  **                       and removed old DQ_AE420 and DQ_AddEr rules
  ** Modified: 8/10/2010 - Michael Beltz - Added new DQ_MDAE rule for MelissaData address cleaning errors
  ** Modified 10/21/2010 - Dana Petersen - Modified foreign address rule to use AddrErr instead of addrstat
  ** Modified 07/18/2013 - Dave Hansen - changed hardcoded QCL_InsertCriteriaStmt parameter from POPULATIONZIPostal_Code IS NULL to POPULATIONPostal_Code IS NULL
  ** Modified 09/11/2013 - Dave Hansen - changed default AddrErr DQ, adding new NRC Canada survey type ID (=7) so that it receives the same AddrErr DQ as the NRC Picker survery type ID (=1)
  **                       and changed Sex DQ to only insert Sex <> "M" and <> "F" for US only
  ** Modified 10/10/2013 - Don Mayhew - Added 'FO' to default values for CriteriaStmt for AddrErr Rule, Operator 7 - INC0021806
  ** Modified 01/07/2014 - Dave Hansen - Added 'NU' to default values for CriteriaStmt for AddrErr DQ_MDAE Rule - INC0028553
  ** Modified 06/02/2014 - Dave Gilsdorf - Removed the hard coded DQ rules and starting using Default Criteria tables
  ** Modified 08/01/2014 - Dave Gilsdorf - added the ability to assign default DQ rules to survey subtypes as well
**********************************************************************************************************************************/
ALTER PROCEDURE [dbo].[QCL_InsertDefaultDQRules]
	@Survey_id INT
AS

set nocount on

DECLARE @Study_id INT
DECLARE @Country_id INT
DECLARE @CriteriaStmt_id INT
DECLARE @SurveyType_ID int

/*Get the Study_id for this Survey*/
SELECT @Study_id=Study_id, @SurveyType_ID=surveytype_id
FROM dbo.Survey_def
WHERE Survey_id=@Survey_id
IF @Study_id IS NULL
	RETURN

/*Get the Country_id from the QualPro_Params*/
SELECT @Country_id=numParam_Value
FROM QualPro_Params
WHERE strParam_nm='Country'

/*Make sure POPULATION Table exists*/
if not exists (	SELECT *
				FROM dbo.MetaTable mt
				WHERE mt.strTable_nm='POPULATION'
				AND mt.Study_id=@Study_id)
BEGIN
	RAISERROR ('No Population Table defined for Survey %s', 16, 1, @Survey_id)
	RETURN
END

create table #DefaultCriteriaStmt (DefaultCriteriaStmt_id int, strCriteriaStmt_nm char(8))
create table #DefaultCriteriaClause (DefaultCriteriaClause_id int 
	, CriteriaPhrase_id int
	, strTable_nm varchar(20)
	, Table_id int
	, Field_id int
	, intOperator int
	, strLowValue varchar(42)
	, strHighValue varchar(42)
	, bitFieldExistsInStudy bit
	, CriteriaClause_id int
	)

/* list all the DQ Rules for this surveytype/country */
if exists (	select * 
			from dbo.subtype st
			inner join dbo.surveysubtype sst on st.subtype_id=sst.subtype_id
			where st.bitRuleOverRide=1
			and sst.survey_id=@Survey_id)
	-- if any one of the survey's subtype's has bitOverride=1, only use that subtype's default DQ rules
	-- (BTW: there shouldn't be more than one subtype that has bitOverride=1 for any given survey_id. Config Mgr interface enforces this.)
	insert into #DefaultCriteriaStmt (DefaultCriteriaStmt_id,strCriteriaStmt_nm)
	select distinct dc.DefaultCriteriaStmt_id,strCriteriaStmt_nm
	from dbo.SurveyTypeDefaultCriteria dc
	inner join dbo.DefaultCriteriaStmt cs on dc.DefaultCriteriaStmt_id = cs.DefaultCriteriaStmt_id
	where dc.SurveyType_id=@SurveyType_ID
	and dc.country_id=@Country_id
	and dc.Subtype_id=(	select top 1 st.subtype_id
						from dbo.subtype st
						inner join dbo.surveysubtype sst on st.subtype_id=sst.subtype_id
						where st.bitRuleOverRide=1
						and sst.survey_id=@Survey_id)
else
	-- if none of the survey's subtype's has bitOveride=1, use all of the default DQ rules for the survey type and all the subtype(s)
	insert into #DefaultCriteriaStmt (DefaultCriteriaStmt_id,strCriteriaStmt_nm)
	select distinct dc.DefaultCriteriaStmt_id,strCriteriaStmt_nm
	from dbo.SurveyTypeDefaultCriteria dc
	inner join dbo.DefaultCriteriaStmt cs on dc.DefaultCriteriaStmt_id = cs.DefaultCriteriaStmt_id
	where dc.SurveyType_id=@SurveyType_ID
	and dc.country_id=@Country_id
	and (dc.Subtype_id=0
		or dc.subtype_id in (	select st.subtype_id 
								from dbo.subtype st
								inner join dbo.surveysubtype sst on st.subtype_id=sst.subtype_id
								where sst.survey_id=@Survey_id )
		)

/* process each rule, one at a time */
declare @DefaultDQ_id int, @Crit_nm char(8)
select top 1 @DefaultDQ_id=DefaultCriteriaStmt_id, @Crit_nm=strCriteriaStmt_nm from #DefaultCriteriaStmt 
while @@rowcount>0
begin
	if exists (	select * 
				from CriteriaStmt cs
				inner join BusinessRule br on cs.criteriastmt_id=br.criteriastmt_id
				where cs.study_id=@study_id
				and cs.strCriteriaStmt_nm=@Crit_nm
				and br.survey_id=@survey_id)
	begin
		print '"'+@Crit_nm+'" already exists for survey '+convert(varchar,@survey_id)+'. skipping...'
	end
	else
	begin
		begin tran
		
		INSERT INTO CriteriaStmt (study_id, strcriteriastmt_nm, strCriteriaString)
		select @Study_id, strCriteriaStmt_nm, strCriteriaString
		from dbo.DefaultCriteriaStmt 
		where DefaultCriteriaStmt_id=@DefaultDQ_id
		
		set @CriteriaStmt_id = SCOPE_IDENTITY()

		insert into BusinessRule (survey_id, study_id, CriteriaStmt_id, BusRule_cd)
		select @survey_id, @study_id, @CriteriaStmt_id, BusRule_cd
		from dbo.DefaultCriteriaStmt 
		where DefaultCriteriaStmt_id=@DefaultDQ_id
		
		/* put all criteria clauses in a temp table. If one or more of them don't check out, we'll roll back the transaction and the DQ rule won't get applied */
		insert into #DefaultCriteriaClause (DefaultCriteriaClause_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue, bitFieldExistsInStudy)
		select DefaultCriteriaClause_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue, 0
		from dbo.DefaultCriteriaClause 
		where DefaultCriteriaStmt_id=@DefaultDQ_id

		/* make sure the needed table exists. If it doesn't Table_id will remain NULL */
		update dcc
		set Table_id=mt.table_id
		from #DefaultCriteriaClause dcc
		inner join metatable mt on dcc.strTable_nm=mt.strTable_nm and mt.study_id=@study_id
		
		/* Make sure the needed field exists. If it doesn't, bitFieldExistsInStudy will remain 0 */
		update dcc
		set bitFieldExistsInStudy=1
		from #DefaultCriteriaClause dcc
		inner join metastructure ms on dcc.table_id=ms.table_id and dcc.field_id=ms.field_id
		
		/* abort if either the table or field doesn't exist */
		if exists (select * from #DefaultCriteriaClause where table_id is null or bitFieldExistsInStudy=0)
		begin
			-- note: I do NOT raise an error here. I simply don't want to apply the DQ rule being processed during the current iteration of the loop 
			-- because the required field doesn't exist. I still want any other DQ Rules applied, so I don't want to exit the procedure.
			-- (same for the other rollback below.)
			print 'Can''t create "'+@Crit_nm+'" for survey '+convert(varchar,@survey_id)+' because a required table and/or field doesn''t exist. skipping...'
			rollback tran
		end
		else 
		begin
			insert into CriteriaClause (CriteriaPhrase_id, CriteriaStmt_id, Table_id, Field_id, intOperator, strLowValue, strHighValue)
			select CriteriaPhrase_id, @CriteriaStmt_id, Table_id, Field_id, intOperator, strLowValue, strHighValue
			from #DefaultCriteriaClause
			
			/* get the CriteriaClause_id(s) we just inserted */
			update dcc
			set CriteriaClause_id=cc.CriteriaClause_id
			from #DefaultCriteriaClause dcc
			inner join CriteriaClause cc on dcc.table_id=cc.table_id 
											and dcc.field_id=cc.field_id 
											and dcc.intOperator=cc.intOperator 
											and dcc.CriteriaPhrase_id=cc.CriteriaPhrase_id
											and isnull(dcc.strLowValue,'') = isnull(cc.strLowValue,'')
											and isnull(dcc.strHighValue,'') = isnull(cc.strHighValue,'')
			where CriteriaStmt_id=@CriteriaStmt_id
			
			/* abort if something doesn't match up and we can't get one of the CriteriaClause_id(s) we just inserted */
			if exists (select * from #DefaultCriteriaClause where CriteriaClause_id is null)
			begin
				-- (see raise error/rollback note above)
				print 'Can''t create "'+@Crit_nm+'" for survey '+convert(varchar,@survey_id)+' because something went wrong while inserting into CriteriaClause. skipping...'
				rollback tran
			end
			else
			begin
				insert into CriteriaInList (CriteriaClause_id, strListValue)
				select dcc.CriteriaClause_id, dci.strListValue
				from #DefaultCriteriaClause dcc
				inner join dbo.DefaultCriteriaInList dci on dcc.DefaultCriteriaClause_id=dci.DefaultCriteriaClause_id

				print 'Created "'+@Crit_nm+'" for survey '+convert(varchar,@survey_id)+'.'				
				commit tran
			end
		end	
	end
	delete from #DefaultCriteriaClause 
	delete from #DefaultCriteriaStmt where DefaultCriteriaStmt_id=@DefaultDQ_id
	select top 1 @DefaultDQ_id=DefaultCriteriaStmt_id, @Crit_nm=strCriteriaStmt_nm from #DefaultCriteriaStmt 
end

drop table #DefaultCriteriaClause 
drop table #DefaultCriteriaStmt

set nocount off
go
