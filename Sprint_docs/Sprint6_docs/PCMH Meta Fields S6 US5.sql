use [qp_prod]

--select * from metafieldgroupdef
--select * from metafield

if not exists(select 1 from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'PCMH')
insert into METAFIELDGROUPDEF (STRFIELDGROUP_NM, strAddrCleanType,  bitAddrCleanDefault)
values ('PCMH','N',0)

declare @PCMHid int
select @PCMHid = FieldGroup_ID from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'PCMH'

if not exists(select 1 from METAFIELD where strField_nm = 'PCMH_PracName')
insert into METAFIELD (strField_nm,	strField_dsc, fieldGroup_id, strFieldDataType, intFieldLength, strFieldEditMask, intSpecialField_cd, strFieldShort_nm, bitSysKey, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('PCMH_PracName','PCMH Practice Name', @PCMHid,'S',60,NULL,NULL,'PCMHPrac',0,0,NULL,NULL,0)

if not exists(select 1 from METAFIELD where strField_nm = 'MosRecVisDate')
insert into METAFIELD (strField_nm,	strField_dsc, fieldGroup_id, strFieldDataType, strFieldEditMask, intSpecialField_cd, strFieldShort_nm, bitSysKey, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('MosRecVisDate','Date of most recent visit',NULL,'D',NULL,NULL,'MRVisDt',0,0,NULL,NULL,0)

if not exists(select 1 from METAFIELD where strField_nm = 'PCMH_VisCnt')
insert into METAFIELD (strField_nm,	strField_dsc, fieldGroup_id, strFieldDataType, strFieldEditMask, intSpecialField_cd, strFieldShort_nm, bitSysKey, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('PCMH_VisCnt','PCMH count of visits in past 12 months',@PCMHid,'I',NULL,NULL,'PCMHVCnt',0,0,NULL,NULL,0)

if not exists(select 1 from METAFIELD where strField_nm = 'PCMH_FileDate')
insert into METAFIELD (strField_nm,	strField_dsc, fieldGroup_id, strFieldDataType, strFieldEditMask, intSpecialField_cd, strFieldShort_nm, bitSysKey, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('PCMH_FileDate','Date practice created PCMH file',@PCMHid,'D',NULL,NULL,'PCMHFiDt',0,0,NULL,NULL,0)

if not exists(select 1 from METAFIELD where strField_nm = 'PCMH_Age')
insert into METAFIELD (strField_nm,	strField_dsc, fieldGroup_id, strFieldDataType, strFieldEditMask, intSpecialField_cd, strFieldShort_nm, bitSysKey, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('PCMH_Age','Patient age on last day of measurement period',@PCMHid,'I',NULL,NULL,'PCMHAge',0,0,NULL,NULL,0)

if not exists(select 1 from QUALPRO_PARAMS where STRPARAM_NM = 'SurveyRule: ResurveyExclusionPeriodsNumericDefault - PCMH')
insert into QUALPRO_PARAMS (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
values ('SurveyRule: ResurveyExclusionPeriodsNumericDefault - PCMH', 'N', 'SurveyRules', NULL, 365, NULL, 'PCMH Resurvey Exclusion Days default for Config Man')

if not exists(select 1 from QUALPRO_PARAMS where STRPARAM_NM = 'SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - PCMH')
insert into QUALPRO_PARAMS (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
values ('SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - PCMH', 'S', 'SurveyRules', 1, NULL, NULL, 'PCMH Resurvey Exclusion Days disabled for Config Man')

if not exists(select 1 from QUALPRO_PARAMS where STRPARAM_NM = 'SurveyRule: SamplingMethodDefault - PCMH')
insert into QUALPRO_PARAMS (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
values ('SurveyRule: SamplingMethodDefault - PCMH', 'S', 'SurveyRules', 'Specify Outgo', NULL, NULL, 'Rule to set default sampling method for Config Man')

if not exists(select 1 from QUALPRO_PARAMS where STRPARAM_NM = 'SurveyRule: IsSamplingMethodDisabled - PCMH')
insert into QUALPRO_PARAMS (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
values ('SurveyRule: IsSamplingMethodDisabled - PCMH', 'S', 'SurveyRules', '1', NULL, NULL, 'Rule to determine if sampling method is enabled for Config Man')

if not exists(select 1 from QUALPRO_PARAMS where STRPARAM_NM = 'SurveyRule: SkipEnforcementRequired - PCMH')
insert into QUALPRO_PARAMS (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
values ('SurveyRule: SkipEnforcementRequired - PCMH', 'S', 'SurveyRules', '1', NULL, NULL, 'Skip Enforcement is required and controls are not enabled in Config Man')

/*
--select * from qualpro_params where strparam_grp = 'SurveyRules' and STRPARAM_NM like '%Enforce%'
--select * from surveytype

-- overall default -> Sampling Algorithm	Static Plus 
-- CGCAHPS default -> Enforce Skip Patterns	TRUE
-- overall default -> Response Rate Recalc	14
-- overall default -> Resurvey Method	Days
Resurvey Days	365 --overall default 90...CGCAHPS has no overriding default
Sampling Method	Specify Outgo --overall default Specify Targets...CGCAHPS has no overriding default
*/

update qualpro_params set numparam_value = 1 
--select * from qualpro_params
where strparam_grp = 'SurveyRules' and strparam_value = 'Specify Targets'

update qualpro_params set numparam_value = 2 
--select * from qualpro_params 
where strparam_grp = 'SurveyRules' and strparam_value = 'Specify Outgo'

update qualpro_params set numparam_value = 3 
--select * from qualpro_params
where strparam_grp = 'SurveyRules' and strparam_value = 'Census'

update qualpro_params set numparam_value = 1 
--select * from qualpro_params
where strparam_grp = 'SurveyRules' and strparam_value = 'NumberOfDays'

update qualpro_params set numparam_value = 2 
--select * from qualpro_params
where strparam_grp = 'SurveyRules' and strparam_value = 'CalendarMonths'

update qualpro_params set numparam_value = 3 
--select * from qualpro_params
where strparam_grp = 'SurveyRules' and strparam_value = 'StaticPlus'

GO
--UPDATED SURVEYPROPERTY FUNCTION to handle PCMH surveysubtype for accessing survey properties

-- =============================================
-- Author:		Burkholder, Chris
-- Create date: 7/10/2014
-- Description:	Simple Rule Reader by Survey Type 
-- =============================================
CREATE 
--ALTER
FUNCTION [dbo].[SurveyProperty] 
(
	@PropertyName varchar(50),
	@SurveyType_id int = null,
	@Survey_id int = null
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar varchar(50)
	Declare @StrParam varchar(50)
	Declare @NumParam int
	Declare @DatParam datetime
	DECLARE @SurveyType varchar(20)
	
	Declare @Override varchar(50) = null
	if @Survey_id is not null
		select top 1 @Override = st.Subtype_nm  
		from surveysubtype sst 
		inner join subtype st on sst.Subtype_id = st.Subtype_id 
		where survey_id = @Survey_id and st.bitRuleOverride = 1

	if @surveytype_id is not null
	select @surveyType = SurveyType_dsc from SurveyType where surveytype_id = @SurveyType_id
	else
	if @survey_id is not null
	select @surveyType = SurveyType_dsc from SurveyType st inner join Survey_DEF sd on st.surveyType_id = sd.SurveyType_id and sd.survey_id = @survey_id
	else
	select @surveyType = ''

	if exists (Select 1 from qualpro_params where STRPARAM_NM = 'SurveyRule: ' + @PropertyName + ' - ' + @Override)
	Select @StrParam = STRPARAM_VALUE, @NumParam = NUMPARAM_VALUE, @DatParam = DATPARAM_VALUE from qualpro_params where STRPARAM_NM = 'SurveyRule: ' + @PropertyName + ' - ' + @Override
	else
	if exists (Select 1 from qualpro_params where STRPARAM_NM = 'SurveyRule: ' + @PropertyName + ' - ' + @SurveyType)
	Select @StrParam = STRPARAM_VALUE, @NumParam = NUMPARAM_VALUE, @DatParam = DATPARAM_VALUE from qualpro_params where STRPARAM_NM = 'SurveyRule: ' + @PropertyName + ' - ' + @SurveyType
	else
	if exists (select 1 from qualpro_params where STRPARAM_NM = 'SurveyRule: ' + @PropertyName)
	Select @StrParam = STRPARAM_VALUE, @NumParam = NUMPARAM_VALUE, @DatParam = DATPARAM_VALUE from qualpro_params where STRPARAM_NM = 'SurveyRule: ' + @PropertyName 
	else
	Select @StrParam = '', @NumParam = null, @DatParam = null

	if @DatParam is not null
	set @Resultvar = convert(varchar, @DatParam)
	else 
	if @NumParam is not null
	set @Resultvar = convert(varchar, @NumParam)
	else
	set @Resultvar = @StrParam

	if @ResultVar = 'QMFolderColorByPriority' and @Survey_id is not null
	begin
		IF EXISTS ( SELECT  1
            FROM    Information_schema.Routines
            WHERE   Specific_schema = 'dbo'
                    AND specific_name = 'QMFolderColorByPriority'
                    AND Routine_Type = 'FUNCTION' ) 		
			begin
				set @ResultVar = dbo.QMFolderColorByPriority(@Survey_id)
			end
	end

	Return @Resultvar
END

GO

/*
select dbo.SurveyProperty('ResurveyExclusionPeriodsNumericDefault', null, 15717) _15717,
dbo.SurveyProperty('ResurveyExclusionPeriodsNumericDefault', null, 15741) _15741

select dbo.SurveyProperty('FolderColor', 8, null) ICH_CAHPS,
dbo.SurveyProperty('FolderColor', 10, null) ACO_CAHPS,
dbo.SurveyProperty('FolderColor', 4, null) CGCAHPS,
dbo.SurveyProperty('FolderColor', 7, null) Canada,
dbo.SurveyProperty('FolderColor', 2, null) HCAHPS,
dbo.SurveyProperty('FolderColor', 3, null) HHCAHPS,
dbo.SurveyProperty('FolderColor', null, 11800) _11800,
dbo.SurveyProperty('FolderColor', null, 11392) _11392,
dbo.SurveyProperty('FolderColor', null, 11806) _11806,
dbo.QMFolderColorByPriority(11392)

*/

delete 
--select *
from qualpro_params where StrParam_GRP = 'SurveyRules' and StrParam_NM like '%FolderColor%'
