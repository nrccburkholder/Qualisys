/*
	RTP-3994 add QuestionPodID metafield to Qualisys - Rollback.sql

	Chris Burkholder

	8/2/2017

	select * from metafield mf inner join METAFIELDGROUPDEF mfgd on mf.fieldgroup_id = mfgd.fieldgroup_id
	where mf.fieldgroup_id in (31,32,33,34,35)

*/

Use [QP_Prod]
GO

DELETE from [dbo].[METAFIELD] where [STRFIELD_NM] = 'QuestionPodID'

declare @maxseed int

select @maxseed=max(FIELD_ID) from METAFIELD
DBCC CHECKIDENT ('dbo.METAFIELD', RESEED, @maxseed);  


GO

