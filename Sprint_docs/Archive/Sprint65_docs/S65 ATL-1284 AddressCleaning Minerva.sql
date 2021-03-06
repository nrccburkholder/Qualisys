/*

ATL-1284
Consolidate Address cleaning calls from Name & Address to a single call

CREATE PROCEDURE [dbo].[AC_GetCounts]
CREATE PROCEDURE [dbo].[AC_GetAllRecords]

*/
USE [QP_DataLoad]
GO

IF EXISTS (SELECT * FROM sysobjects 
            WHERE Name = 'AC_GetCounts'
            AND type = 'P')
	drop procedure dbo.AC_GetCounts


GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AC_GetCounts]
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
    SET @strSql = 'SELECT Count(*) AS intQtyTotal, '
        + '       IsNull(Sum(Case When ' + @strStatusFieldName
        + ' IS NOT NULL AND ' + @strErrorFieldName
        + ' NOT IN (''TL'',''NC'',''NU'',''FO'') Then 1 Else 0 End), 0) AS intQtyUpdated, '
        + '       IsNull(Sum(Case When ' + @strStatusFieldName
        + ' IS NOT NULL AND ' + @strErrorFieldName
        + ' NOT IN (''AS'',''AC'') Then 1 Else 0 End), 0) AS intQtyErrors, '
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
        + '       IsNull(Sum(Case When ' + @strStatusFieldName + ' IS NOT NULL AND ' + @strStatusFieldName + ' NOT IN (''ERROR'') AND ' + @strStatusFieldName + ' NOT LIKE ''%NE%'' Then 1 Else 0 End), 0) AS intQtyUpdated, '
        + '       IsNull(Sum(Case When Left(' + @strStatusFieldName + ', 5) = ''ERROR'' OR ' + @strStatusFieldName + ' LIKE ''%NE%'' Then 1 Else 0 End), 0) AS intQtyErrors, '
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
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[AC_GetAllRecords]
    @BatchSize       int, 
    @SelectFieldList varchar(1500), 
    @KeyFieldName    varchar(20), 
    @SQLTableName    varchar(50), 
    @AddressStatusFieldName varchar(20), 
	@NameStatusFieldName varchar(20),
    @FileID          int

AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare required variables
DECLARE @Sql varchar(2000)

--Build the SQL string to be executed
SET @Sql = 'SELECT TOP ' + Convert(varchar, @BatchSize) + ' ' + @SelectFieldList + ', ' + @KeyFieldName + ' AS DBKey ' + 
           'FROM ' + @SQLTableName + ' '

		   IF LEN(@NameStatusFieldName) > 0 
		   BEGIN
			 SET @Sql = @Sql + 'WHERE (' + @AddressStatusFieldName + ' IS NULL OR  ' +  @NameStatusFieldName + ' IS NULL)' 
		   END
		   ELSE
		   BEGIN
			  SET @Sql = @Sql + 'WHERE ' + @AddressStatusFieldName + ' IS NULL'
		   END



           SET @Sql = @Sql +  ' AND DataFile_ID = ' + Convert(varchar, @FileID) + ' ' +
           'ORDER BY DF_id'

--Get the result set
EXEC (@Sql)

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
go