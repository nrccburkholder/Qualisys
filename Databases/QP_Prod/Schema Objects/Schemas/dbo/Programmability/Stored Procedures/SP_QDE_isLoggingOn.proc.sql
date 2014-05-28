CREATE PROCEDURE [dbo].[SP_QDE_isLoggingOn]    
AS    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
SET NOCOUNT ON        
    
Select cast(numparam_value as varchar) from qualpro_params where strparam_nm = 'QDELogging'


