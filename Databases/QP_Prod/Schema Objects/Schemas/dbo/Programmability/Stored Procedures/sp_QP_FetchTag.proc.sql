/****** Object:  Stored Procedure dbo.sp_QP_FetchTag    Script Date: 6/9/99 4:36:38 PM ******/
/****** Object:  Stored Procedure dbo.sp_QP_FetchTag    Script Date: 3/12/99 4:16:09 PM ******/
/****** Object:  Stored Procedure dbo.sp_QP_FetchTag    Script Date: 12/7/98 2:34:55 PM ******/
CREATE PROCEDURE sp_QP_FetchTag
@mstrTag varchar(20)
AS
SELECT * FROM Tag WHERE Tag = @mstrTag


