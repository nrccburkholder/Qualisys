﻿CREATE  FUNCTION [YearQtr] (@date DATETIME)    
RETURNS VARCHAR(10) AS    
BEGIN   
RETURN(ISNULL((CONVERT(VARCHAR,YEAR(@date)) + '_' + CONVERT(VARCHAR,DATEPART(QUARTER,(@date)))),'NULL'))   
END


