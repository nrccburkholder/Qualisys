create procedure QP_Rep_ImagesProcessedTitle
@Associate varchar(50),
@StartDate datetime,
@EndDate datetime
as
select convert(varchar(11),@startdate, 109)+' to '+convert(varchar(11),@enddate,109) as 'Surveys received from:'


