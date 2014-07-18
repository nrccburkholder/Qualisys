USE [QP_Prod]
GO

/****** Object:  UserDefinedFunction [dbo].[SurveyProperty]    Script Date: 7/11/2014 10:31:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

	if @surveytype_id is not null
	select @surveyType = SurveyType_dsc from SurveyType where surveytype_id = @SurveyType_id
	else
	if @survey_id is not null
	select @surveyType = SurveyType_dsc from SurveyType st inner join Survey_DEF sd on st.surveyType_id = sd.SurveyType_id and sd.survey_id = @survey_id
	else
	select @surveyType = ''

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
from qualpro_params where StrParam_GRP = 'QueueManagerRules'

/* QueueManager STRParam_NM values
QueueManager
Bundling
Printing
MailedDaysInQ
QueueServer
QueueDatabase
ShowGroupedPrint
SplitThreshold
QManSamplePath

*/

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: FolderColor - HCAHPS IP','S','QueueManagerRules','Cyan','Rule to assign icon color for survey type from pre-defined icon sets')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: FolderColor - Home Health CAHPS','S','QueueManagerRules','Purple','Rule to assign icon color for survey type from pre-defined icon sets')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: FolderColor - ACOCAHPS','S','QueueManagerRules','Orange','Rule to assign icon color for survey type from pre-defined icon sets')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: FolderColor - ICHCAHPS','S','QueueManagerRules','Orange','Rule to assign icon color for survey type from pre-defined icon sets')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: FolderColor','S','QueueManagerRules','Manila','Rule to assign icon color for survey type from pre-defined icon sets')

/*
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: FolderColor - CGCAHPS','S','QueueManagerRules','Red','Rule to assign icon color for survey type from pre-defined icon sets')

update qualpro_params set strparam_value='Manila' where strparam_nm = 'SurveyRule: FolderColor - CGCAHPS'
update qualpro_params set strparam_value='Orange' where strparam_nm = 'SurveyRule: FolderColor - CGCAHPS'
*/
update qualpro_params set strparam_value = 'QMFolderColorByPriority' where strparam_nm = 'SurveyRule: FolderColor - HCAHPS IP'
GO
CREATE 
--ALTER
FUNCTION [dbo].[QMFolderColorByPriority] 
(
	@Survey_id int = null
)
RETURNS varchar(50)
AS
BEGIN
	if exists (select 1 from survey_def sd where surveytype_id = 2 and survey_id = @survey_id)
	begin
		if exists (select 1 from sampleset where survey_id = @survey_id and DateDiff(DAY, sampleset.datDateRange_FromDate, GetDate()) > 35 and datLastMailed is null)
			Return 'Red'
		else
			Return 'Cyan'
	end

	Return 'Manila'
END
GO
-------------------
/*
update qualpro_params set strparam_value = 'Cyan' where strparam_nm = 'SurveyRule: FolderColor - HCAHPS IP'
GO
DROP FUNCTION [dbo].[QMFolderColorByPriority]
GO
*/