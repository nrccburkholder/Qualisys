
/*
Inserts new SurveyValidationProcs records 
and the SurveyValidationProcsBySurveyType mappings 

*/

declare @svpid int
declare @intOrder int
--declare @PCMHSubTypeId int

declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8


--SELECT @PCMHSubTypeId = [Subtype_id]
--FROM [dbo].[Subtype]
--where [Subtype_nm] = 'PCMH'



begin tran



Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs



SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_DQRules'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_DQRules','Check DQ Rules',@intOrder)
	set @svpid=scope_identity()	
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HHCAHPS)
--INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@CGCAHPS)
--INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ICHCAHPS)
--INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ACOCAHPS)
--INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID],[SubType_Id])VALUES(@svpid,@CGCAHPS,@PCMHSubTypeId)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs


update [dbo].[SurveyValidationProcs]
	set Active = 0
where ProcedureName in (
'SV_CAHPS_HH_CAHPS_DQRules'
,'SV_CAHPS_H_CAHPS_DQRules'
,'SV_CAHPS_PCMH_CAHPS_DQRules'
)

select *
from SurveyValidationProcs_view

GO

commit tran

GO
