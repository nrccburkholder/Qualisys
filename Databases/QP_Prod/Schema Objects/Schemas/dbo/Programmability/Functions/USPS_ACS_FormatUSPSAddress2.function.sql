CREATE FUNCTION USPS_ACS_FormatUSPSAddress2 
(
	@UnitDesignator varchar(4),
	@SecondaryNumber varchar(10)
)
RETURNS VARCHAR(14)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar VARCHAR(66)

	SET @ResultVar = ''

	IF LEN(LTRIM(RTRIM(@UnitDesignator))) > 0
		SET @ResultVar = @ResultVar + @UnitDesignator + ' '

	IF LEN(LTRIM(RTRIM(@SecondaryNumber))) > 0
	SET @ResultVar = @ResultVar + @SecondaryNumber

	-- Return the result of the function
	RETURN @ResultVar

END
GO