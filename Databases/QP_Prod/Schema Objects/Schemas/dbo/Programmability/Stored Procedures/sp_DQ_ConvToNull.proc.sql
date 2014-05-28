/****** Object:  Stored Procedure dbo.sp_DQ_ConvToNull    Script Date: 6/9/99 4:36:39 PM ******/
CREATE PROCEDURE sp_DQ_ConvToNull
 @Study_id int,
 @Field varchar(20)
AS
 DECLARE @Owner varchar(5)
 DECLARE @SQL varchar(255)
 SELECT @Owner = 's' + convert(varchar(4), @Study_id)
 SELECT @SQL = 'UPDATE ' + @Owner + '.Population ' +
               'SET ' + @Field + '= NULL ' +
        'WHERE LEN(RTRIM(CONVERT(VARCHAR, ' + @Field + '))) IS NULL'
 EXEC (@SQL)


