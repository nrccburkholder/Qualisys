/*
CJB 2/24/2015

Modify Skip Language	

Analyze the method and time needed for various options. 	

Spanish as well. Probably less than 20 hours to put a flag in SurveyType table. Double check to see how the text wrap works. 

18.1	Code Change in shared code. Add field to SurveyType Table. Create Read proc. 

*/

/*
select * from surveytype

sp_helptext QCL_selectallsurveytypes

sp_helptext QCL_selectsurveytype

*/
use [QP_Prod]

begin tran

update QualPro_Params set strparam_value = '3.28' where STRPARAM_NM = 'FormLayoutVersion'
					 and strparam_value <> '3.28'
--update QualPro_Params set strparam_value = '3.0' 
--select * from Qualpro_params where STRPARAM_NM = 'FormLayoutVersion'

IF NOT EXISTS (
            SELECT 1
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = 'SurveyType'
              AND COLUMN_NAME = 'SkipRepeatsScaleText'
)
ALTER TABLE SurveyType 
ADD SkipRepeatsScaleText bit NOT NULL
DEFAULT 0

GO

update SurveyType set SkipRepeatsScaleText = 1 where SurveyType_dsc = 'Hospice CAHPS' and SkipRepeatsScaleText = 0

GO

ALTER PROCEDURE [dbo].[QCL_SelectAllSurveyTypes]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT SurveyType_ID, SurveyType_dsc, CAHPSType_id, SeedMailings, SeedSurveyPercent, SeedUnitField, SkipRepeatsScaleText
FROM [dbo].SurveyType

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

ALTER PROCEDURE [dbo].[QCL_SelectSurveyType]
    @SurveyType_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT SurveyType_ID, SurveyType_dsc, CAHPSType_id, SeedMailings, SeedSurveyPercent, SeedUnitField, SkipRepeatsScaleText
FROM [dbo].SurveyType
WHERE SurveyType_ID = @SurveyType_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

commit tran

GO