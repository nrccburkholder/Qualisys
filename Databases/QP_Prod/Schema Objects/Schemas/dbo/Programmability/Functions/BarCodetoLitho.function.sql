/****** Object:  User Defined Function dbo.BarCodetoLitho    Script Date: 12/6/2004 10:32:27 AM ******/
CREATE FUNCTION dbo.BarCodetoLitho (@BarCode VARCHAR(8), @ValidateCheckDigit BIT)
RETURNS VARCHAR(10)
AS
BEGIN

DECLARE @String VARCHAR(40), @CheckDigit CHAR(1)

SELECT @CheckDigit=RIGHT(@BarCode,1)

IF @ValidateCheckDigit=1
BEGIN

	--Stop the procedure if the supplied barcode is not 8 characters long.
	IF LEN(@BarCode)<>8
	RETURN -1
	
	--Validate the checkdigit.
	IF @CheckDigit<>dbo.BarCodeCheckDigit(LEFT(@BarCode,7))
	RETURN -1

END

SELECT @String='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'

RETURN (CONVERT(VARCHAR,(POWER(36,5)*(PATINDEX('%'+SUBSTRING(@BarCode,1,1)+'%',@String)-1))+
	(POWER(36,4)*(PATINDEX('%'+SUBSTRING(@BarCode,2,1)+'%',@String)-1))+
	(POWER(36,3)*(PATINDEX('%'+SUBSTRING(@BarCode,3,1)+'%',@String)-1))+
	(POWER(36,2)*(PATINDEX('%'+SUBSTRING(@BarCode,4,1)+'%',@String)-1))+
	(POWER(36,1)*(PATINDEX('%'+SUBSTRING(@BarCode,5,1)+'%',@String)-1))+
	(POWER(36,0)*(PATINDEX('%'+SUBSTRING(@BarCode,6,1)+'%',@String)-1))))

END


