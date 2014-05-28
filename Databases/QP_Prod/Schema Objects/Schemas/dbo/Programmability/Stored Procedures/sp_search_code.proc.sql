CREATE PROC sp_search_code
(
@SearchStr 	varchar(100),
@RowsReturned	int = NULL	OUT
)
AS
/*************************************************************************************************
		Copyright © 1997 - 2002 Narayana Vyas Kondreddi. All rights reserved.
                                          
Purpose:	To search the stored proceudre, UDF, trigger code for a given keyword.

Written by:	Narayana Vyas Kondreddi
		http://vyaskn.tripod.com

Tested on: 	SQL Server 7.0, SQL Server 2000

Date created:	January-22-2002 21:37 GMT

Date modified:	February-17-2002 19:31 GMT

Email: 		vyaskn@hotmail.com

Examples:

To search your database code for the keyword 'unauthorized':
EXEC sp_search_code 'unauthorized'

To search your database code for the keyword 'FlowerOrders' and also find out the number of hits:
DECLARE @Hits int
EXEC sp_search_code 'FlowerOrders', @Hits OUT
SELECT 'Found ' + LTRIM(STR(@Hits)) + ' object(s) containing this keyword' AS Result
*************************************************************************************************/
BEGIN
	SET NOCOUNT ON

	SELECT	DISTINCT USER_NAME(o.uid) + '.' + OBJECT_NAME(c.id) AS 'Object name',
		CASE 
 			WHEN OBJECTPROPERTY(c.id, 'IsReplProc') = 1 
				THEN 'Replication stored procedure'
 			WHEN OBJECTPROPERTY(c.id, 'IsExtendedProc') = 1 
				THEN 'Extended stored procedure'				
			WHEN OBJECTPROPERTY(c.id, 'IsProcedure') = 1 
				THEN 'Stored Procedure' 
			WHEN OBJECTPROPERTY(c.id, 'IsTrigger') = 1 
				THEN 'Trigger' 
			WHEN OBJECTPROPERTY(c.id, 'IsTableFunction') = 1 
				THEN 'Table-valued function' 
			WHEN OBJECTPROPERTY(c.id, 'IsScalarFunction') = 1 
				THEN 'Scalar-valued function'
 			WHEN OBJECTPROPERTY(c.id, 'IsInlineFunction') = 1 
				THEN 'Inline function'	
		END AS 'Object type',
		'EXEC sp_helptext ''' + USER_NAME(o.uid) + '.' + OBJECT_NAME(c.id) + '''' AS 'Run this command to see the object text'
	FROM	syscomments c
		INNER JOIN
		sysobjects o
		ON c.id = o.id
	WHERE	c.text LIKE '%' + @SearchStr + '%'	AND
		encrypted = 0				AND
		(
		OBJECTPROPERTY(c.id, 'IsReplProc') = 1		OR
		OBJECTPROPERTY(c.id, 'IsExtendedProc') = 1	OR
		OBJECTPROPERTY(c.id, 'IsProcedure') = 1		OR
		OBJECTPROPERTY(c.id, 'IsTrigger') = 1		OR
		OBJECTPROPERTY(c.id, 'IsTableFunction') = 1	OR
		OBJECTPROPERTY(c.id, 'IsScalarFunction') = 1	OR
		OBJECTPROPERTY(c.id, 'IsInlineFunction') = 1	
		)

	ORDER BY	'Object type', 'Object name'

	SET @RowsReturned = @@ROWCOUNT
END


