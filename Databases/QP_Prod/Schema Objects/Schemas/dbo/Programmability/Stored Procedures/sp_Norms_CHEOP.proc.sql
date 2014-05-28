create procedure sp_Norms_CHEOP
@NRCNormTable varchar(20),
@CHENormTable varchar(20),
@BeginDate datetime,
@EndDate datetime
as
set nocount on
declare @SQL varchar(8000)
set @SQL = 'create table ' + @CHENormTable + ' (qstncore int, intresponseval int, uwnsize int) '
exec(@SQL)
create table #CHECoreNorms (qstncore int, intresponseval int, uwnsize int) 
create table #CHECores (qstncore int, client_id int) 

set @SQL = 'insert into #CHECoreNorms' + char(10)+
  'select qstncore, intresponseval, sum(NSize)' +char(10)+
  'from ' + @NRCNormTable + char(10)+
  'where datreturned between ''' + convert(varchar(10),@BeginDate,120) + ''' and ''' + convert(varchar(10),@EndDate,120) + '''' +char(10)+
  'and bitMissing = 0' + char(10)+
  'and sampleunit_id not in (17600,177,18431,18556,18603,18530,18357,19528,20895,19551,19596,5096,841,155,857,8488,902,' + char(10)+
  '917,9834,9651,961,8616,979,984,9860,19795,18039,15557,15558,15559,15560,15561,15562,15563,15564,15565,15566,15567,' + char(10)+
  '15568,15569,15570,15507,11120,11242,11339,11337,11542,11521,11560,11098,11529,11531,9534,9502,9508,9494,9497,9654,' + char(10)+
  '9655,9656,18121,8725,20888,5179,5323,17570,17577,5135,5146,1862,1881,1882,1883,1885,1886,1918,1919,1920,1921,1922,' + char(10)+
  '1952,1953,1954,1955,1956,1957,1958,1959,1960,1961,1962,1967,1968,1969,1970,1971,1996,1997,1998,1999,2000,2001,2002,' + char(10)+
  '2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2029,2030,2031,2032,2033,2034,2035,2036,2037,2038,2039,2040,' + char(10)+
  '2041,2043,2044,2833,2834,2835,2869,2870,2871,2872,2873,2874,2875,2876,2877,2878,2879,8329,9217,9218,9219,9220,9221,' + char(10)+
  '9222,9223,9224,9228,9229,9230,9231,9232,9233,9234,9235,9236,9237,9238,9239,9240,9241,9245,9246,9247,9248,9250,9251,' + char(10)+
  '9252,9253,9254,9255,9256,9257,9258,9259,9260,9272,9273,9274,9275,9276,9277,9278,9280,9281,9282,9283,9284,9286,9296,' + char(10)+
  '9297,9298,9299,9300,9301,9302,9303,9304,9305,9306,9307,9308,9309,9310,9311,9312,9313,9314,9315,9316,9317,9318,9319,' + char(10)+
  '9320,9321,9323,9334,9335,9336,9337,9338,9339,9340,9341,9342,9343,9344,9345,9346,9347,9348,9349,9350,9351,9352,9353,' + char(10)+
  '9354,9355,9356,9357,9358,9360,9361,9362,9363,9364,9365,9366,9367,9368,9369,9370,9371,9372,9385,9386,9387,9388,9389,' + char(10)+
  '9390,9391,9392,9393,9394,9395,9396,9397,9398,9399,9400,9401,9402,9403,9404,9412,9413,9414,9415,9416,9417,9418,9419,' + char(10)+
  '9420,9421,9422,9423,9424,9425,9426,9427,9428,9429,9430,9431,9432,9433,9434,9435,9436,9438,10713,10714,11712,18788,' + char(10)+
  '19335,19504,16927,1590,3094,10239,4729,4737,10214,10667,10671,10672,9061,11879,9083,9084,9085,9081,10597,10611,9805,' + char(10)+
  '10048,1598,698,18784,18785,18746,18761,18773,18781,18059,800,19167,11375,11376,11437,11409,11410,11461,11502,11482,' + char(10)+
  '13741,10437,10438,10439,10440,10441,2265,9863,10150,10299,10112,9982,19538,19561,19562,19563,19564,19878,440,9410,9927,' + char(10)+
  '9907,19439,19461,19489,19419,9449,10108,19094,16877,16934,16971)' + char(10)+
  'group by qstncore, intresponseval'
exec(@SQL)

set @SQL = 'insert into #CHECores' +char(10)+
  'select distinct qstncore, s.client_id' +char(10)+
  'from study s, survey_def sd, sampleplan sp, sampleunit su, ' + @NRCNormTable + ' n' +char(10)+ 
  'where datreturned between ''' + convert(varchar(10),@BeginDate,120) + ''' and ''' + convert(varchar(10),@EndDate,120) + '''' +char(10)+
  'and bitMissing = 0' +char(10)+
  'and n.sampleunit_id = su.sampleunit_id' +char(10)+
  'and su.sampleplan_id = sp.sampleplan_id' +char(10)+
  'and sp.survey_id = sd.survey_id' +char(10)+
  'and sd.study_id = s.study_id'
exec(@SQL)

delete u1 
from #CHECores u1 left outer join (select qstncore from #CHECores where client_id = 63) u2 
on u1.qstncore=u2.qstncore
where u2.qstncore is null

declare @Qstncore int
declare RCursor cursor for 
select distinct qstncore from JC_CHE_Recodes
open RCursor
fetch next from RCursor into @Qstncore
while @@fetch_status = 0
begin
if (select count(*) from #CHECores where qstncore in (select qstncore from JC_CHE_Recodes where recode_id = (select recode_id from JC_CHE_Recodes where qstncore = @qstncore)) and client_id <>63) >0
begin  
  set @SQL = 'insert into ' + @CHENormTable + ' select ' + convert(varchar(10),@qstncore)+', intresponseval, sum(uwnsize) from #CHECoreNorms where qstncore in (select qstncore from JC_CHE_Recodes where recode_id = (select recode_id from JC_CHE_Recodes where qstncore = '+convert(varchar(10),@qstncore)+')) group by intresponseval'
  exec(@SQL)
end
fetch next from RCursor into @Qstncore
end
close RCursor
deallocate RCursor

delete t1
from #CHECoreNorms t1 left outer join (select qstncore from #CHECores group by qstncore having count(*) > 1) t2
on t1.qstncore = t2.qstncore
where t2.qstncore is null

set @SQL = 'insert into ' + @CHENormTable + char(10)+
  'select * ' +char(10)+
  'from #CHECoreNorms' +char(10)+
  'where qstncore not in (select qstncore from ' + @CHENormTable + ')'
exec(@SQL)

drop table #CHECores
drop table #CHECoreNorms
set nocount off
set @SQL = 'select count(*) from '+@CHENormTable
exec(@SQL)


