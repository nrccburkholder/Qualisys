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


