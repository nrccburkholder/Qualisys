CREATE FUNCTION USPS_ACS_FormatUSPSAddress1 
(
	@PrimaryNumber varchar(10),
	@PreDirectional varchar(2),
	@StreetName varchar(28),
	@StreetSuffix varchar(4),
	@PostDirectional varchar(2)
)
RETURNS VARCHAR(66)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar VARCHAR(66)

	SET @ResultVar = ''

	IF LEN(LTRIM(RTRIM(@PrimaryNumber))) > 0
		SET @ResultVar = @ResultVar + @PrimaryNumber + ' '

	IF LEN(LTRIM(RTRIM(@PreDirectional))) > 0
	SET @ResultVar = @ResultVar + @PreDirectional + ' '

	IF LEN(LTRIM(RTRIM(@StreetName))) > 0
	SET @ResultVar = @ResultVar + @StreetName + ' '

	IF LEN(LTRIM(RTRIM(@StreetSuffix))) > 0
	SET @ResultVar = @ResultVar + @StreetSuffix + ' '

	IF LEN(LTRIM(RTRIM(@PostDirectional))) > 0
	SET @ResultVar = @ResultVar + @PostDirectional

	-- Return the result of the function
	RETURN @ResultVar

END