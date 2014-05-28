﻿CREATE PROCEDURE [dbo].[sp_getcountryenvironment]
	@ocountry NVARCHAR(255) OUTPUT,
	@oenvironment NVARCHAR(255) OUTPUT
AS

SELECT @ocountry=STRPARAM_VALUE FROM dbo.QUALPRO_PARAMS WHERE STRPARAM_NM = 'Country' AND STRPARAM_GRP = 'Environment'
SELECT @oenvironment=STRPARAM_VALUE FROM dbo.QUALPRO_PARAMS WHERE STRPARAM_NM = 'EnvName' AND STRPARAM_GRP = 'Environment'


