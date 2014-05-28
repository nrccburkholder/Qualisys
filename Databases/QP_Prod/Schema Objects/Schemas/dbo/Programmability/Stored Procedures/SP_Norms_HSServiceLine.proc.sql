create procedure SP_Norms_HSServiceLine
@SampListName varchar(20), @TableName varchar(20), @NRCNormTable varchar(20)
as
declare @SQL varchar(8000),@SampUnitList Varchar(8000)
--declare @SampListName varchar(20), @TableName varchar(20), @NRCNormTable varchar(20)
--set @SampListName = 'OPSrg'
--set @TableName = 'JC_test'
--set @NRCNormTable = 'nrcnorms12312001'

--Set SampUnitList variable--------------------------------
set @SampUnitList = case 
	when @SampListName = 'OPSrg' then '17600,20907,11375,11376,18039,18431,18556,21556,21555,1598,21924,20995,5096,838,155,9834,
		8488,8616,902,913,9651,961,984,979,984,9860,857,15507,15504,15558,15557,15560,15570,15567,15568,15563,15569,15565,
		3094,11120,11242,11339,11337,11542,11543,11521,20888,10239,4729,4737,11879,19167,9295,16927,11098,11096,10667,9061,
		11560,11561,11531,11529,11530,9083,9084,9085,698,10597,10611,18059,800,11437,21728,11409,11410,11461,11502,11482,
		10048,9805,19755,5179,13741,2265,10150,10299,10112,9982,1,17570,5325,5326,5327,9410,19439,19461,19489,18603,19419,
		5146,9449,10105,10108,19094,18530'
	when @SampListName = 'IPRehab' then '8727,18674,19807,21983,82,697,855,901,5112,5126,5209,22236,9519,9828,10035,
		10177,10351,10352,10358,10359,10365,10366,10372,10373,10379,10380,10386,10387,10393,10394,10400,10401,10409,10410,
		10417,10418,10628,10666,22742,19981,20672,20684,19975,20687,19978,13597,13647,13704,23062,16894,16910,16951,20883,
		18055,18426,18507,19251,19256,19566,19977,19979,19980,19983,20676,20677,20685,20688,20905,20994,22326,22349,22427,
		22477,22533,22623,23102,23220,23271,23820,23823,24499,24587'
	when @SampListName = 'OPDiag' then '175,978,16788,2267,5122,5142,5178,17560,17562,17573,9766,10135,9987,10104,
		10120,10155,10304,10462,10634,10643,10673,11407,11434,11456,11476,11500,11656,11675,11688,13610,17888,18446,18539,
		18563,18584,18617,19205,19208,21762,22241,22332,22441,22460,22464,22471,22495,22499,22504,23113,23311,23617,23844,
		24421,25272,8490,181,23028,981,16789,2266,5137,5143,5181,9213,9451,9454,9769,9770,9808,
		9986,10103,10119,10154,10303,10461,10633,10641,10674,11369,11381,11404,11416,11435,11438,11454,11462,11475,11483,
		11499,11506,11658,11677,11690,13606,13611,13742,16963,16978,17010,17889,18450,18541,18564,18602,18765,19206,19207,
		20997,21568,21569,21570,21761,21925,22242,22333,22385,22443,22463,22465,22473,22507,23310,23588,23594,23640,23647,
		23616,23749,23773,23789,23805,23841,24422,24580,24581,24582,24591'
	when @SampListName = 'OPRehab' then '8913,172,176,8617,10311,9862,4893,4905,5071,5132,5134,5144,5149,5150,5151,
		5176,5180,5322,17571,17567,17576,6692,6693,6696,8162,8170,8206,8224,8225,8236,8252,8726,17606,9806,9811,9835,9838,
		9894,9928,9990,10102,10125,10129,21897,21898,10312,10313,10314,10315,10316,10317,10467,10468,10574,10577,10631,
		10639,16782,16976,17891,18430,18437,18440,18441,18443,18517,18524,18518,18520,18523,18542,18543,18545,18562,18573,
		18575,21563,18585,18600,19101,19440,19456,19495,21106,21107,21111,21267,21275,21291,21316,21317,21328,21360,21210,
		21248,21260,21726,21745,21763,21764,21765,21768,22243,22291,22381,22384,22444,22576,24007,22541,23204,23205,23207,
		23208,23209,23210,23224,23225,23226,23275,23276,23277,23548,23845,24112,24113,24114,24115,24116,24117,24118,24119,
		24120,24121,24191,24192,24193,24194,24195,24196,24197,24198,24199,24200,24236,24254,24394,24395,24396,24397,24398,
		24399,24400,24401,24402,24324,24325,24326,24327,24328,24329,24330,24331,24332,25273'
	else null
end

--Run Norm-----------------------------
if @SampUnitList is null 
 begin
 print 'Invalid Sample unit list'
 return
end

create table #NRCNorms (SampleUnit_id int, QstnCore int, intResponseVal float, NU float, NW float)
set @SQL = '
insert into #nrcnorms
select sampleunit_id, qstncore, intresponseval, NSize, NSize
from '+@NRCNormTable+' where sampleunit_id in ('+@SampUnitList+')
and bitmissing = 0
and datreturned between ''1/1/01'' and ''12/31/01'''
exec(@SQL)

select distinct n.sampleunit_id, n.qstncore
into #HSData
from nrcnorms12312001 n, sampleunit su, sampleplan sp, survey_def sd, study s
where n.sampleunit_id = su.sampleunit_id
and su.sampleplan_id = sp.sampleplan_id
and sp.survey_id = sd.survey_id
and sd.study_id = s.study_id
and s.client_id = 113
and n.bitmissing = 0
and datreturned between '1/1/01' and '12/31/01'

create table #UnitCores (SampleUnit_id int, QstnCore int, Client_id int)

insert into #UnitCores (sampleunit_id, qstncore)
select distinct SampleUnit_id, QstnCore
from #nrcnorms

update u
set u.client_id = s.client_id
from #unitcores u, sampleunit su, sampleplan sp, survey_def sd, study s
where u.sampleunit_id = su.sampleunit_id
and su.sampleplan_id = sp.sampleplan_id
and sp.survey_id = sd.survey_id
and sd.study_id = s.study_id

select distinct client_id, qstncore
into #clientcores
from #unitcores

delete #NRCNorms
where qstncore not in (
select qstncore
from #clientcores
group by qstncore
having count(*) > 1
)

delete #NRCNorms where qstncore not in (select distinct qstncore from #HSData)

delete #NRCNorms
from #NRCNorms n, #HSData hs
where n.sampleunit_id = hs.sampleunit_id

create table #NRCNormsSum (QstnCore int, NU float, NW float, SM float, SS float)

insert into #NRCNormsSum
select qstncore, sum(NU), sum(NW), sum(NU*intresponseval), sum(NU*intresponseval*intresponseval)
from #NRCNorms
group by qstncore
order by qstncore

declare cores cursor for select distinct qstncore from #NRCNormsSum order by qstncore
declare @Fields varchar(2000), @Core int

set @fields = ''
open cores
fetch next from cores into @core
while @@fetch_status = 0
begin
 set @fields = @fields +', '+ case when @core < 1000 then 'Q000' + convert(varchar,@core) else 'Q00' + convert(varchar,@core) end +' float'
 fetch next from Cores into @Core
end
close Cores
set nocount on
exec('Create table '+@TableName+' (StatType varchar(2)'+@Fields+')')
exec('insert into '+@TableName+' (Stattype) values (''NU'')')
exec('insert into '+@TableName+' (Stattype) values (''NW'')')
exec('insert into '+@TableName+' (Stattype) values (''SM'')')
exec('insert into '+@TableName+' (Stattype) values (''SS'')')
open cores
fetch next from cores into @core
while @@fetch_status = 0
begin
 set @SQL = 'update '+@TableName+' set '+ case when @core < 1000 then 'Q000' + convert(varchar,@core) else 'Q00' + convert(varchar,@core) end + '= ISNULL((select NU from #NRCNormsSum where qstncore = '+ convert(varchar,@core)+'),0) where stattype = ''NU''
'
 exec(@SQL)
 set @SQL = 'update '+@TableName+' set '+ case when @core < 1000 then 'Q000' + convert(varchar,@core) else 'Q00' + convert(varchar,@core) end + '= ISNULL((select NW from #NRCNormsSum where qstncore = '+ convert(varchar,@core)+'),0) where stattype = ''NW''
'
 exec(@SQL)
 set @SQL = 'update '+@TableName+' set '+ case when @core < 1000 then 'Q000' + convert(varchar,@core) else 'Q00' + convert(varchar,@core) end + '= ISNULL((select SM from #NRCNormsSum where qstncore = '+ convert(varchar,@core)+'),0) where stattype = ''SM''
'
 exec(@SQL)
 set @SQL = 'update '+@TableName+' set '+ case when @core < 1000 then 'Q000' + convert(varchar,@core) else 'Q00' + convert(varchar,@core) end + '= ISNULL((select SS from #NRCNormsSum where qstncore = '+ convert(varchar,@core)+'),0) where stattype = ''SS''
'
 exec(@SQL)
 fetch next from cores into @core
end

close cores
deallocate cores
set nocount off

drop table #NRCNorms
drop table #unitcores
drop table #clientcores
drop table #HSData
drop table #NRCNormsSum


