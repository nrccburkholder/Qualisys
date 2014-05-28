create function [dbo].[FormatDatetoString] (@datDate datetime)
returns varchar(30)
as
begin
return convert(varchar,datepart(mm,@datDate))+'/'+convert(varchar,datepart(dd,@datDate))+'/'+convert(varchar,datepart(yy,@datDate)) 
end


