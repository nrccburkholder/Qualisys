CREATE PROCEDURE sp_clientcontact_replacequotes 
AS

declare @strsql varchar(8000)
declare @dq char(1), @sq char(1)
set @dq = '"'
set @sq = "'"

begin
   set @strsql = 'update client_contact set strcontactemail = replace(strcontactemail, "' + @sq + '", "`")'
   exec(@strsql)
end


