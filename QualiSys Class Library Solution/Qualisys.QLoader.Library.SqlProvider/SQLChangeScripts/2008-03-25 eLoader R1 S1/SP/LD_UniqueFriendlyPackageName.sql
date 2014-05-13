CREATE PROCEDURE LD_UniqueFriendlyPackageName
	@Client_ID int,
	@strPackageFriendly_nm varchar(100)
AS

DECLARE @total int

/* 
Created 4/3/2008 by DRM

Checks to see if the passed in client_id and strPackageFriendly_nm exist in the Package table.  If they *do* exist, 
then the proposed strPackageFriendly_nm isn't unique for this client and can *not* be used.

Returns:
0 - False.  The value for the @strPackageFriendly_nm can *not* be used for a new package.
1 - True.  The value for @strPackageFriendly_nm can be used.
*/

SELECT	@total = count(*) 
FROM	Package 
WHERE	Client_ID = @Client_ID
 AND	strPackageFriendly_nm = @strPackageFriendly_nm

IF @total > 0
	--If a record exists, return 0.  0 = the passed in client_id + strPackageFriendly_nm already exist in table.
	SELECT 0 
ELSE
	--If no record is found, return 1.  1 = the passed in client_id + strPackageFriendly_nm *don't* exist in table and
	--	can be safely inserted.
	SELECT 1