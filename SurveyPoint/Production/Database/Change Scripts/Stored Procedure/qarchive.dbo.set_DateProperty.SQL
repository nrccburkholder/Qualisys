/****** Object:  StoredProcedure [dbo].[set_DateProperty]    Script Date: 08/10/2006 10:08:14 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[set_DateProperty]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[set_DateProperty]
GO
/****** Object:  StoredProcedure [dbo].[set_DateProperty]    Script Date: 08/10/2006 10:08:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[set_DateProperty]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[set_DateProperty] 
(
	@RespondentID int,
	@PropertyName varchar(100),
	@DateValue datetime
)
AS
BEGIN
    DECLARE @PropertyValue varchar(10)
    SET @PropertyValue = SUBSTRING(ISNULL(CONVERT(varchar(8), @DateValue, 112), ''''), 5, 4) + SUBSTRING(ISNULL(CONVERT(varchar(8), @DateValue, 112), ''''), 1, 4) 
    EXEC dbo.spSetRespondentProperty @RespondentID, @PropertyName, @PropertyValue 
END
' 
END
GO
