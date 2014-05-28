CREATE FUNCTION AddComma (@val VARCHAR(100))
RETURNS varchar(120)
AS
BEGIN

	DECLARE @len INT
	SET @len=LEN(@val)

	IF @len<4
	RETURN @val
	
	WHILE @len/3>0
	BEGIN
	
		SET @val=SUBSTRING(@val,1,@len-3)+','+SUBSTRING(@val,@len-2,8000)
	
		SET @len=@len-3
	
	END

RETURN @val

END


