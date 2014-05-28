CREATE FUNCTION [dbo].[fn_LanguageKey](@LANGUAGE int) RETURNS varchar(10)
AS	
begin
	if @LANGUAGE in (2, 5, 7, 8, 9, 18, 19, 20) 
		return 'es'
	else if @LANGUAGE in (22, 6) 
		return 'fr'

	return 'en'
end


