CREATE FUNCTION TagDesc (@Code INT)
RETURNS VARCHAR(1000) AS  
BEGIN 
RETURN (COALESCE((SELECT TOP 1 Tag_dsc+CASE WHEN QPC_Text LIKE '%¯_s%' THEN '`s' ELSE '' END
FROM CodesText ct, CodeTextTag ctt, Tag t
WHERE ct.Code = @Code
AND ct.CodeText_id = ctt.CodeText_id
AND ctt.Tag_id = t.Tag_id),
(SELECT TOP 1 QPC_Text FROM CodesText WHERE Code = @Code AND Age = 'A'),
(SELECT TOP 1 QPC_Text FROM CodesText WHERE Code = @Code AND Sex = 'M'),
(SELECT TOP 1 QPC_Text FROM CodesText WHERE Code = @Code AND Doctor = 'G'),
''))
END


