CREATE PROCEDURE sp_IDEAS_PopCounts AS
declare @study_id int, @strsql varchar(1000), @studyid varchar(5), @survey_id int, @strAgeRangeCase varchar(1000)
declare survey_ids cursor for
   select distinct study_id, sd.survey_id
   from questionform qf, survey_def sd
   where datreturned is not null
   and qf.survey_id = sd.survey_id

create table #popcounts (survey_id int, sampleset_id int, sampleunit_id int, agegrp int, sex char(1), total int)
open survey_ids
fetch next from survey_ids into @study_id, @survey_id
while @@fetch_status = 0
begin

   set @strAgeRangeCase = isnull((select strAgeRangeCase from nrc14.ideas_v1.dbo.phase1_AgeRange where survey_id=@survey_id),
          'case when bt.age < 18 then 1 '+
                 'when bt.age between 18 and 34 then 2 '+
                 'when bt.age between 35 and 44 then 3 '+
                 'when bt.age between 45 and 54 then 4 '+
                 'when bt.age between 55 and 64 then 5 '+
                 'when bt.age >= 65 then 6 '+
                 'else 0 end as AgeGrp')

   set @strsql = 'insert #popcounts ' +
      'select survey_id, ss.sampleset_id, sampleunit_id, ' + 
      @strAgeRangeCase + ', ' +
      'sex, count(*) as total ' +
      'from selectedsample ss, sampleset sset, s'+ltrim(rtrim(convert(varchar(5),@study_id)))+'.population bt ' +
      'where sset.survey_id = '+convert(char(5),@survey_id)+
      '  and ss.sampleset_id = sset.sampleset_id ' +
      '  and ss.pop_id = bt.pop_id ' +
      '  and ss.strunitselecttype = "D" ' +
      'group by survey_id, ss.sampleset_id, sampleunit_id, age, sex ' +
      'order by survey_id, ss.sampleset_id, sampleunit_id, age, sex'
   exec (@strsql)
   fetch next from survey_ids into @study_id, @survey_id
end
close survey_ids
deallocate survey_ids

if exists(select * from sysobjects where name = 'IDEAS_PopCounts' and type = 'U')
   drop table IDEAS_PopCounts

create table ideas_PopCounts (survey_id int, sampleset_id int, sampleunit_id int, agegrp int, sex char(1), total int)

insert ideas_PopCounts
select survey_id, sampleset_id, sampleunit_id, agegrp, sex, sum(total) as total
from #popcounts 
group by survey_id, sampleset_id, sampleunit_id, agegrp, sex
order by survey_id, sampleset_id, sampleunit_id, agegrp, sex

drop table #popcounts


