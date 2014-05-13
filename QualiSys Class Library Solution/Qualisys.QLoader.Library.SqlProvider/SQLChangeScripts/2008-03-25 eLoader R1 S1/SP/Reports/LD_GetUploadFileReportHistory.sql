USE [QP_Load]
GO
/****** Object:  StoredProcedure [dbo].[LD_GetUploadFileReportHistory]    Script Date: 04/28/2008 11:37:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[LD_GetUploadFileReportHistory]
	@uploadfile_id int
as
select a.uploadfile_id , a.datOccurred, b.uploadstate_nm
from uploadfilestate a inner join uploadstates b
 on a.uploadstate_id = b.uploadstate_id
where a.uploadfile_id = @uploadfile_id
union
select a.uploadfile_id , a.datOccurred, b.uploadstate_nm
from uploadfilestate_history a inner join uploadstates b
 on a.uploadstate_id = b.uploadstate_id
where a.uploadfile_id = @uploadfile_id



