/*
S46 US16 Delete Groups & Sites - Rollback.sql

As the Compliance PM, I would like to be able to delete CG-CAHPS groups & sites via the interface, 
so that we can remove incorrect entries

Limited by NRCAuth permission

Chris Burkholder

Task 2 - Hook up delete button, include checks if group/site assigned to facility
*/

Use [QP_Prod]
go

begin tran

/****** Object:  StoredProcedure [dbo].[QCL_PracticeSiteDelete]    Script Date: 4/6/2016 10:20:33 AM ******/
if exists (select * from sys.procedures where name = 'QCL_PracticeSiteDelete' and schema_id = SCHEMA_ID('dbo'))
	DROP PROCEDURE [dbo].[QCL_PracticeSiteDelete]
GO


/****** Object:  StoredProcedure [dbo].[QCL_SiteGroupDelete]    Script Date: 4/6/2016 10:20:33 AM ******/
if exists (select * from sys.procedures where name = 'QCL_SiteGroupDelete' and schema_id = SCHEMA_ID('dbo'))
	DROP PROCEDURE [dbo].[QCL_SiteGroupDelete]
GO


/****** Object:  StoredProcedure [dbo].[QCL_SiteAllowDelete]    Script Date: 4/6/2016 10:20:33 AM ******/
if exists (select * from sys.procedures where name = 'QCL_SiteAllowDelete' and schema_id = SCHEMA_ID('dbo'))
	DROP PROCEDURE [dbo].[QCL_SiteAllowDelete]
GO


--rollback tran

commit tran