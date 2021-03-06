
/*

ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

ATL-1284
Consolidate Address cleaning calls from Name & Address to a single call

CREATE PROCEDURE [dbo].[AC_GetCounts]
CREATE PROCEDURE [dbo].[AC_GetAllRecords]

*/

USE [QP_DataLoad]
GO
/****** Object:  StoredProcedure [dbo].[AC_GetCounts]    Script Date: 12/27/2016 2:56:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[AC_GetCounts]
    @intDataFile_id INT
   ,@strStatusFieldName VARCHAR(20)
   ,@strErrorFieldName VARCHAR(20)
   ,@strTableName VARCHAR(50)
   ,@bitIsAddress BIT
AS --Setup the environment
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 
--Declare the required variables
    DECLARE @strSql VARCHAR(1000)
 
--Build the SQL string
    IF @bitIsAddress = 1 
        BEGIN
    --Get the counts for this address group
    --SET @strSql = 'SELECT Count(*) AS intQtyTotal, ' +
    --              '       IsNull(Sum(Case When ' + @strStatusFieldName + ' IS NOT NULL AND ' + @strErrorFieldName + ' IS NULL Then 1 Else 0 End), 0) AS intQtyUpdated, ' +
    --              '       IsNull(Sum(Case When ' + @strStatusFieldName + ' IS NOT NULL AND ' + @strErrorFieldName + ' IS NOT NULL Then 1 Else 0 End), 0) AS intQtyErrors, ' +
    --              '       IsNull(Sum(Case When ' + @strStatusFieldName + ' IS NULL AND ' + @strErrorFieldName + ' IS NULL Then 1 Else 0 End), 0) AS intQtyRemaining ' +
    --              'FROM ' + @strTableName + ' ' +
    --              'WHERE DataFile_id = ' + Convert(varchar, @intDataFile_id)
            SET @strSql = 'SELECT Count(*) AS intQtyTotal, '
                + '       IsNull(Sum(Case When ' + @strStatusFieldName
                + ' IS NOT NULL AND ' + @strErrorFieldName
                + ' NOT IN (''TL'',''NC'') Then 1 Else 0 End), 0) AS intQtyUpdated, '
                + '       IsNull(Sum(Case When ' + @strStatusFieldName
                + ' IS NOT NULL AND ' + @strErrorFieldName
                + ' NOT IN (''R5'',''R9'') Then 1 Else 0 End), 0) AS intQtyErrors, '
                + '       IsNull(Sum(Case When ' + @strStatusFieldName
                + ' IS NULL AND ' + @strErrorFieldName
                + ' IS NULL Then 1 Else 0 End), 0) AS intQtyRemaining '
                + 'FROM ' + @strTableName + ' ' + 'WHERE DataFile_id = '
                + CONVERT(VARCHAR, @intDataFile_id)
        END
    ELSE 
        BEGIN
    --Get the counts for this name group
            SET @strSql = 'SELECT Count(*) AS intQtyTotal, '
                + '       IsNull(Sum(Case When ' + @strStatusFieldName
                + ' = ''CLEANED'' Then 1 Else 0 End), 0) AS intQtyUpdated, '
                + '       IsNull(Sum(Case When Left(' + @strStatusFieldName
                + ', 5) = ''ERROR'' Then 1 Else 0 End), 0) AS intQtyErrors, '
                + '       IsNull(Sum(Case When ' + @strStatusFieldName
                + ' IS NULL Then 1 Else 0 End), 0) AS intQtyRemaining '
                + 'FROM ' + @strTableName + ' ' + 'WHERE DataFile_id = '
                + CONVERT(VARCHAR, @intDataFile_id)
        END
 
--Execute the statement
    EXEC (@strSql)
 
--Reset the environment
    SET NOCOUNT OFF
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED
 
GO

USE [QP_DataLoad]
GO

IF EXISTS (SELECT * FROM sysobjects 
            WHERE Name = 'AC_GetAllRecords'
            AND type = 'P')
	drop procedure dbo.AC_GetAllRecords

GO