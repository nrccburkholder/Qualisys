CREATE procedure QP_Rep_TargetInfoPercents
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @FirstPeriod datetime,
 @LastPeriod datetime
as 
set transaction isolation level read uncommitted
set nocount on
Declare @intSurvey_id int
select @intSurvey_id=sd.survey_id 
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

declare @equal int, @more int, @less int, @perequal decimal(5,2), @permore decimal(5,2), @perless decimal(5,2), @total int

create table #display (Unit_Status varchar(42), Percentage decimal(5,2))

if (select count(*) from targetinfo 
    where survey_id = @intsurvey_id
    and convert(char(19),perioddate,120) >= convert(char(19),@firstperiod, 120) 
    and convert(char(19),perioddate,120) <= convert(char(19),@lastperiod, 120)) < 1
begin
 insert into #display (Unit_Status) select 'No Mailing this Period'
 select * from #display
end
else
begin
 set @total = (select count(*) from targetinfo 
               where survey_id = @intsurvey_id
               and convert(char(19),perioddate,120) >= convert(char(19),@firstperiod, 120) 
               and convert(char(19),perioddate,120) <= convert(char(19),@lastperiod, 120))
 set @equal = (select count(*) from targetinfo 
               where survey_id = @intsurvey_id
               and convert(char(19),perioddate,120) >= convert(char(19),@firstperiod, 120) 
               and convert(char(19),perioddate,120) <= convert(char(19),@lastperiod, 120)
               and target = returns)
 set @perequal = (@equal / (@total * 1.00)) * 100
 set @more = (select count(*) from targetinfo 
              where survey_id = @intsurvey_id
              and convert(char(19),perioddate,120) >= convert(char(19),@firstperiod, 120) 
              and convert(char(19),perioddate,120) <= convert(char(19),@lastperiod, 120)
              and target < returns)
 set @permore = (@more / (@total * 1.00)) * 100
 set @less = (select count(*) from targetinfo 
              where survey_id = @intsurvey_id
              and convert(char(19),perioddate,120) >= convert(char(19),@firstperiod, 120) 
              and convert(char(19),perioddate,120) <= convert(char(19),@lastperiod, 120)
              and target > returns)
 set @perless = (@less / (@total * 1.00)) * 100
 insert into #display select 'Returns Equal Target', @perequal
 insert into #display select 'More Returns than Target', @permore
 insert into #display select 'Less Returns than Target', @perless

 select * from #display
end 
	
drop table #display

set transaction isolation level read committed


