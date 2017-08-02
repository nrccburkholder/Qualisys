/*
	RTP-3994 add QuestionPodID metafield to Qualisys.sql

	Chris Burkholder

	8/2/2017

	select * from metafield mf inner join METAFIELDGROUPDEF mfgd on mf.fieldgroup_id = mfgd.fieldgroup_id
	where mf.fieldgroup_id in (31,32,33,34,35)

*/

Use [QP_Prod]
GO

IF NOT EXISTS(select 1 from [dbo].[METAFIELD] where [STRFIELD_NM] = 'QuestionPodID')
INSERT INTO [dbo].[METAFIELD]
           ([STRFIELD_NM]
           ,[STRFIELD_DSC]
           ,[FIELDGROUP_ID]
           ,[STRFIELDDATATYPE]
           ,[INTFIELDLENGTH]
           ,[STRFIELDEDITMASK]
           ,[INTSPECIALFIELD_CD]
           ,[STRFIELDSHORT_NM]
           ,[BITSYSKEY]
           ,[bitPhase1Field]
           ,[intAddrCleanCode]
           ,[intAddrCleanGroup]
           ,[bitPII])
	SELECT 'QuestionPodID'
		  ,'QuestionPodID AKA QuestionModuleID from RTPhoenix'
		  ,31
		  ,'I'
		  ,NULL
		  ,NULL
		  ,NULL
		  ,'QPODID'
		  ,0
		  ,0
		  ,NULL
		  ,NULL
		  ,0

GO

