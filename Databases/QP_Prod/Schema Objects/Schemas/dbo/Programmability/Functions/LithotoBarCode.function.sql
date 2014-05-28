/****** Object:  User Defined Function dbo.LithotoBarCode    Script Date: 12/6/2004 10:29:54 AM ******/
CREATE FUNCTION dbo.LithotoBarCode (@Litho VARCHAR(20), @Page INT=1)
RETURNS VARCHAR(10)
AS
BEGIN
DECLARE @String VARCHAR(40), @BarCode VARCHAR(10), @TempValue INT, @TempValue2 INT, @Loop INT

SELECT @String='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'

SELECT @TempValue=CONVERT(INT,@Litho), @Loop=5

SELECT @BarCode=''

WHILE @LOOP>-1
BEGIN

SELECT @TempValue2=FLOOR(@TempValue/POWER(LEN(@String),@Loop))
SELECT @TempValue=@TempValue-(@TempValue2*(POWER(LEN(@String),@Loop)))
SELECT @BarCode=@BarCode+SUBSTRING(@String,@TempValue2+1,1)

SELECT @Loop=@Loop-1

END

RETURN @BarCode+CONVERT(VARCHAR,@Page)+dbo.BarCodeCheckDigit(@BarCode+CONVERT(VARCHAR,@Page))
END


