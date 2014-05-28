/****** Object:  Stored Procedure dbo.sp_DQ_Clean    Script Date: 6/9/99 4:36:39 PM ******/
CREATE PROCEDURE sp_DQ_Clean 
 @Study_id int
AS
 /*Converts empty strings to nulls*/
 EXEC dbo.sp_DQ_ConvToNull @Study_id, 'LNAME'
 EXEC dbo.sp_DQ_ConvToNull @Study_id, 'FNAME'
 EXEC dbo.sp_DQ_ConvToNull @Study_id, 'ADDR'
 EXEC dbo.sp_DQ_ConvToNull @Study_id, 'CITY'
 EXEC dbo.sp_DQ_ConvToNull @Study_id, 'ST'
 EXEC dbo.sp_DQ_ConvToNull @Study_id, 'ZIP5'
 EXEC dbo.sp_DQ_ConvToNull @Study_id, 'DOB'
 EXEC dbo.sp_DQ_ConvToNull @Study_id, 'AGE'


