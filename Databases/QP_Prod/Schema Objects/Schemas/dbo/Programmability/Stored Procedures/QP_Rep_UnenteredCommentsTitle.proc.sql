create procedure QP_Rep_UnenteredCommentsTitle
@BeginDate datetime,
@EndDate datetime
as

select convert(char(10),@BeginDate,101)+' to '+convert(char(10),@EndDate,101) as 'Surveys Received From:'


