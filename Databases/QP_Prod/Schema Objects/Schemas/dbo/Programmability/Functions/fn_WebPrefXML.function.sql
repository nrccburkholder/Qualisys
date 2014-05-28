CREATE FUNCTION dbo.fn_WebPrefXML (@BarCode VARCHAR(20))
RETURNS VARCHAR(7000)
AS
BEGIN

DECLARE @sql VARCHAR(7000)
SELECT @sql='<UserMethods>'

SELECT @sql=@sql+'<Method Name="'+MethodName+'" Value="'+ISNULL(MethodValue,'NULL')+'" />'
FROM WebSurveyValues
WHERE BarCode=@BarCode

SELECT @sql=@sql+'</UserMethods>'

RETURN (SELECT @sql)

END


