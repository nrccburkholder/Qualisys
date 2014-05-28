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


