
/*


*/

USE [QP_Prod]
GO


if exists (select * from sys.procedures where schema_id=1 and name = 'AC_GetMetadata')
	drop procedure dbo.AC_GetMetadata

GO

delete from dbo.QUALPRO_PARAMS
where STRPARAM_NM = 'AddressCleaningActions'

delete from dbo.QUALPRO_PARAMS
where STRPARAM_NM = 'AddressCleaningOptions'

delete from dbo.QUALPRO_PARAMS
where STRPARAM_NM = 'AddressCleaningColumns'

DECLARE @Param_ID int
SELECT @Param_ID = max(Param_ID) FROM [dbo].[QUALPRO_PARAMS]

DBCC CHECKIDENT ('[dbo].[QualPro_Params]', RESEED, @Param_id)

GO
