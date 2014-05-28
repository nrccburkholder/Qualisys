CREATE Function GetDBAEmailGroup ()
RETURNS Varchar(255)
AS
BEGIN
	DECLARE @ret varchar(255)
	SELECT @ret = strParam_value from Qualpro_params where strParam_nm = 'DBAEmailGroup'
	return ISNULL(@ret, '')
END


