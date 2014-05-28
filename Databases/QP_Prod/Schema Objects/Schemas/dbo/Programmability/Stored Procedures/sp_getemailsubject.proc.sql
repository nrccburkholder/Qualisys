CREATE PROCEDURE [dbo].[sp_getemailsubject]
	@isubject NVARCHAR(255),
	@icountry NVARCHAR(255),
	@ienvironment NVARCHAR(255),
	@iserver NVARCHAR(255),
	@osubject NVARCHAR(255) OUTPUT
AS

SET @osubject = @isubject+' '+@icountry+' '+@ienvironment+' '+@iserver


