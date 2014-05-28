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


