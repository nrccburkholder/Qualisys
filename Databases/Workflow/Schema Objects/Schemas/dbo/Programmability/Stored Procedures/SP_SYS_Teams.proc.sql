﻿CREATE PROCEDURE SP_SYS_Teams 
AS

SELECT Team_id, TeamName
FROM Team
WHERE Team_id<>999


