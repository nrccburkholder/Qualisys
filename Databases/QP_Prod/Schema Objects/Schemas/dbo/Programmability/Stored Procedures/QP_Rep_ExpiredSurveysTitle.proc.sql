CREATE procedure QP_Rep_ExpiredSurveysTitle
@Associate varchar(40), @Client varchar(40), @BeginDate datetime, @EndDate datetime
as

declare @client_id int

select @client_id = client_id
from client where strclient_nm = @client

select 'From ' + convert(char(10),@begindate,120) + ' to ' + convert(char(10),@enddate, 120) as 'Date Range'


