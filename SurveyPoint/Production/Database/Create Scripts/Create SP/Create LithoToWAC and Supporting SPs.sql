

 CREATE FUNCTION dbo.Crunch (@Litho VARCHAR(10), @LookUpTable VARCHAR(30))    
RETURNS VARCHAR(20)    
AS    
BEGIN    
    
DECLARE @numDigits INT, @tmpstr VARCHAR(20), @d INT    
    
SELECT @numDigits=8, @tmpstr=''    
    
WHILE @numDigits>0    
BEGIN    
    
SELECT @numDigits=@numDigits-1    
SELECT @d=@Litho/POWER(LEN(@LookUpTable),@numDigits)    
SELECT @tmpstr=@tmpstr+SUBSTRING(@LookUpTable,@d+1,1)    
SELECT @litho=@litho-(@d*POWER(LEN(@LookUpTable),@numDigits))    
    
END    
    
RETURN @tmpstr    
END    
    


--================

 CREATE FUNCTION dbo.UnCrunch (@WAC VARCHAR(20), @LookUpTable VARCHAR(30))    
RETURNS VARCHAR(10)    
AS    
BEGIN    
    
SELECT @WAC=REPLACE(@WAC,'-','')    
    
RETURN (CONVERT(VARCHAR,(POWER(LEN(@LookUpTable),7)*(PATINDEX('%'+SUBSTRING(@WAC,1,1)+'%',@LookUpTable)-1))+    
 (POWER(LEN(@LookUpTable),6)*(PATINDEX('%'+SUBSTRING(@WAC,2,1)+'%',@LookUpTable)-1))+    
 (POWER(LEN(@LookUpTable),5)*(PATINDEX('%'+SUBSTRING(@WAC,3,1)+'%',@LookUpTable)-1))+    
 (POWER(LEN(@LookUpTable),4)*(PATINDEX('%'+SUBSTRING(@WAC,4,1)+'%',@LookUpTable)-1))+    
 (POWER(LEN(@LookUpTable),3)*(PATINDEX('%'+SUBSTRING(@WAC,5,1)+'%',@LookUpTable)-1))+    
 (POWER(LEN(@LookUpTable),2)*(PATINDEX('%'+SUBSTRING(@WAC,6,1)+'%',@LookUpTable)-1))+    
 (POWER(LEN(@LookUpTable),1)*(PATINDEX('%'+SUBSTRING(@WAC,7,1)+'%',@LookUpTable)-1))+    
 (POWER(LEN(@LookUpTable),0)*(PATINDEX('%'+SUBSTRING(@WAC,8,1)+'%',@LookUpTable)-1))))    
    
END    
    

--===============

 CREATE FUNCTION dbo.ComputeCheckDigit (@CrunchedLitho VARCHAR(20), @LookUpTable VARCHAR(30))    
RETURNS CHAR(2)    
AS    
BEGIN    
    
DECLARE @Digits INT, @Sum INT, @d INT, @base INT    
    
SELECT @Sum=0, @Digits=LEN(@CrunchedLitho)    
SELECT @base=LEN(@LookUpTable)    
    
WHILE @Digits>0    
BEGIN    
    
SELECT @d=PATINDEX('%'+SUBSTRING(@CrunchedLitho,@Digits,1)+'%',@LookUpTable)    
SELECT @Sum=@Sum+(@d*PrimeNumber) FROM PrimeNumbers WHERE Prime_id=(LEN(@CrunchedLitho)-@Digits)    
SELECT @Digits=@Digits-1    
    
END    
    
SELECT @Sum=@Sum%(@Base*@Base)    
    
RETURN RIGHT(dbo.Crunch(@Sum, @LookUpTable),2)    
    
END    
    

--============

--Create PrimeNumbers Table and load it with values

USE [qms]
GO
/****** Object:  Table [dbo].[PrimeNumbers]    Script Date: 11/05/2007 08:24:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PrimeNumbers](
	[Prime_id] [int] NULL,
	[PrimeNumber] [int] NULL
) ON [PRIMARY]


Insert into PrimeNumbers Select 0, 3
Insert into PrimeNumbers Select 1, 5
Insert into PrimeNumbers Select 2, 7
Insert into PrimeNumbers Select 3, 11
Insert into PrimeNumbers Select 4, 13
Insert into PrimeNumbers Select 5, 17
Insert into PrimeNumbers Select 6, 19
Insert into PrimeNumbers Select 7, 23
Insert into PrimeNumbers Select 8, 29
Insert into PrimeNumbers Select 9, 31
Insert into PrimeNumbers Select 10, 37
Insert into PrimeNumbers Select 11, 41
Insert into PrimeNumbers Select 12, 43
Insert into PrimeNumbers Select 13, 47
Insert into PrimeNumbers Select 14, 53
Insert into PrimeNumbers Select 15, 59
Insert into PrimeNumbers Select 16, 61
Insert into PrimeNumbers Select 17, 67
Insert into PrimeNumbers Select 18, 71
Insert into PrimeNumbers Select 19, 73
Insert into PrimeNumbers Select 20, 79
Insert into PrimeNumbers Select 21, 83
Insert into PrimeNumbers Select 22, 89
Insert into PrimeNumbers Select 23, 97


--==================

/*
Converts a litho code to a unique WAC - Web Access Code
*/
CREATE FUNCTION dbo.LithoToWAC (@Litho VARCHAR(10))    
RETURNS VARCHAR(12)    
AS    
BEGIN    
    
DECLARE @WAC VARCHAR(12), @LookUpTable VARCHAR(30)    
    
SELECT @LookUpTable='ACDEFGHJKLMNPQRTUVWXY'    
    
SELECT @WAC=dbo.Crunch(@Litho,@LookUpTable)    
SELECT @WAC=@WAC+dbo.ComputeCheckDigit(@WAC,@LookUpTable)    
    
SELECT @WAC=SUBSTRING(@WAC,1,3)+'-'+SUBSTRING(@WAC,4,4)+'-'+SUBSTRING(@WAC,8,3)    
    
IF @Litho<>dbo.UnCrunch(@WAC,@LookUpTable)    
 SELECT @WAC=-1    
    
RETURN @WAC    
    
END    
    

--==================
