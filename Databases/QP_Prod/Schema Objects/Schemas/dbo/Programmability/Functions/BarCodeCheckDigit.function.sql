CREATE FUNCTION dbo.BarCodeCheckDigit (@BarCode VARCHAR(10))
RETURNS CHAR(1)
AS
BEGIN

DECLARE @Mod INT, @String VARCHAR(50)

SELECT @String='123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-.!$/+%'

SELECT @BarCode=REPLACE(@BarCode,' ','!')

SELECT @Mod=(((PATINDEX('%'+SUBSTRING(@BarCode,1,1)+'%',@String))+
	(PATINDEX('%'+SUBSTRING(@BarCode,2,1)+'%',@String))+
	(PATINDEX('%'+SUBSTRING(@BarCode,3,1)+'%',@String))+
	(PATINDEX('%'+SUBSTRING(@BarCode,4,1)+'%',@String))+
	(PATINDEX('%'+SUBSTRING(@BarCode,5,1)+'%',@String))+
	(PATINDEX('%'+SUBSTRING(@BarCode,6,1)+'%',@String))+
	(PATINDEX('%'+SUBSTRING(@BarCode,7,1)+'%',@String)))%43)

IF @Mod=0
RETURN (0)

RETURN (SELECT SUBSTRING(@STRING,@Mod,1))

END


