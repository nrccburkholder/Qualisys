/*
S46 US16 Delete Groups & Sites.sql

As the Compliance PM, I would like to be able to delete CG-CAHPS groups & sites via the interface, 
so that we can remove incorrect entries

Limited by NRCAuth permission

Chris Burkholder

Task 2 - Hook up delete button, include checks if group/site assigned to facility
*/

Use [QP_Prod]
go

begin tran

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_PracticeSiteDelete]    Script Date: 4/6/2016 10:20:33 AM ******/
if exists (select * from sys.procedures where name = 'QCL_PracticeSiteDelete' and schema_id = SCHEMA_ID('dbo'))
	DROP PROCEDURE [dbo].[QCL_PracticeSiteDelete]
GO

/****** Object:  StoredProcedure [dbo].[QCL_PracticeSiteDelete]    Script Date: 4/6/2016 10:20:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[QCL_PracticeSiteDelete]
	@PracticeSite_id int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE
	  FROM [dbo].[PracticeSite]
	  where (PracticeSite_ID = @PracticeSite_id)

END

GO

/****** Object:  StoredProcedure [dbo].[QCL_SiteGroupDelete]    Script Date: 4/6/2016 10:20:33 AM ******/
if exists (select * from sys.procedures where name = 'QCL_SiteGroupDelete' and schema_id = SCHEMA_ID('dbo'))
	DROP PROCEDURE [dbo].[QCL_SiteGroupDelete]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SiteGroupDelete]    Script Date: 4/6/2016 10:20:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[QCL_SiteGroupDelete]
	@SiteGroup_id int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE
	  FROM [dbo].[SiteGroup]
	  where (SiteGroup_ID = @SiteGroup_id)

END

GO

--rollback tran

commit tran