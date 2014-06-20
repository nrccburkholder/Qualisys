﻿create procedure SP_Norms_TrinityPercentile
@SampListName varchar(20), @TableName varchar(20), @NRCNormTable varchar(20), @EndDate datetime
as
declare @SQL varchar(8000),@SampUnitList Varchar(8000)

--Set SampUnitList variable--------------------------------
set @SampUnitList = case 
	when @SampListName = 'OPSrg' then '17600,20907,11375,11376,18039,18431,18556,21556,21555,1598,21924,20995,5096,838,155,9834,
		8488,8616,902,913,9651,961,984,979,984,9860,857,15507,15504,15558,15557,15560,15570,15567,15568,15563,15569,15565,
		3094,11120,11242,11339,11337,11542,11543,11521,20888,10239,4729,4737,11879,19167,9295,16927,11098,11096,10667,9061,
		11560,11561,11531,11529,11530,9083,9084,9085,698,10597,10611,18059,800,11437,21728,11409,11410,11461,11502,11482,
		10048,9805,19755,5179,13741,2265,10150,10299,10112,9982,1,17570,5325,5326,5327,9410,19439,19461,19489,18603,19419,
		5146,9449,10105,10108,19094,18530'
	when @SampListName = 'OPSrv' then '17587,17892,17890,17888,17589,17887,17889,17891,11367,18433,18411,18434,18444,18445,18435,
		18446,18447,18436,18449,18448,18437,18438,18413,18432,18430,18439,18440,18441,18442,18450,18451,18452,18453,18443,
		18462,18566,18565,18563,18569,18570,18543,18568,18546,18516,18557,18524,18547,18542,18548,18564,18544,18567,18545,
		21988,22048,22057,22077,22033,22025,21980,19828,5095,834,840,841,154,9835,9836,9837,9838,9839,8617,903,916,170,171,
		172,173,174,175,176,178,179,180,181,9864,978,981,9859,858,4539,4540,10810,19361,11544,4381,19366,19203,21672,22241,
		22243,22242,16928,4339,11097,10656,10612,18783,18784,18785,799,798,11431,11400,11453,11497,11474,10640,10639,10643,
		10644,10642,16782,10641,10134,9806,16881,9807,10135,9810,16880,9809,9811,9808,17526,5176,5177,5178,5172,5181,5180,
		5182,13742,21862,2267,21918,2266,10153,10312,10313,10314,10302,10315,10316,10317,10578,10116,10125,21899,21726,21725,
		18745,18746,18747,17572,17561,17560,17571,5320,5319,17578,17565,17562,17567,5318,17575,17574,17573,17576,5324,5322,
		9384,18760,18761,18762,18763,18764,18765,18766,19438,19443,19446,19475,19485,19496,18772,18773,18774,18775,18776,
		18606,18608,18610,18611,18612,18613,18586,18614,18615,18616,18587,18585,18589,18617,18605,18618,18591,18619,18598,
		18600,18601,18620,5132,5122,5134,5136,5133,5137,5135,5147,5148,5142,5149,5144,5143,5151,5145,5150,9447,9448,9450,
		9451,9452,9453,9454,17606,17607,17608,21860,10097,17621,19086,19100,19087,19088,19119,17624,19098,17622,17623,17626,
		19097,19089,19091,19090,19092,19093,17619,21903,17627,17625,19096,19101,19095,17620,18837,18839,18838,8487,19121,
		18841,18840,18518,18536,18541,18539,18552,18537,18550,18520,18534,18517,18521,18523,18527,18526,18780,18781,18782,
		16788,16789'
	when @SampListName = 'IPMDSrg' then '80,83,160,791,850,892,893,894,895,900,938,939,948,949,963,964,976,1326,1588,
		1596,3091,4727,4733,5110,5203,5205,5210,5301,5305,5312,5316,5335,5343,8336,8339,8342,8484,8486,8603,8604,8605,8606,
		8607,8610,8611,8614,8641,9063,9092,9095,9781,9789,9794,9832,9850,9851,9872,9901,9906,9924,10086,10090,10216,10241,
		10327,10328,10329,10330,10367,10368,10369,10370,10371,10372,10373,10374,10375,10376,10377,10378,10379,10380,10381,
		10382,10383,10384,10385,10386,10387,10388,10389,10390,10391,10392,10393,10394,10395,10396,10397,10398,10399,10400,
		10401,10402,10404,10405,10406,10407,10408,10409,10410,10423,10424,10425,10426,10427,10428,10501,10502,10503,10504,
		10505,10506,10507,10518,10519,10520,10521,10522,10523,10524,10536,10537,10538,10539,10540,10541,10542,10544,10545,
		10546,10547,10548,10549,10550,10556,10566,10567,10568,10569,10570,10571,10594,10603,10626,10658,10659,10660,10800,
		10806,10808,11100,11122,11135,11232,11233,11234,11238,11239,11240,11246,11331,11332,11333,11342,11348,11349,11353,
		11380,11415,11430,11452,11473,11496,11522,11523,11525,11571,11878,13599,13652,13687,13706,13734,13735,15438,15439,
		15487,15488,15489,15490,15492,15495,15496,15547,15551,16687,16689,16690,16691,16706,16784,16795,16874,16875,16887,
		16890,16897,16898,16931,16937,16938,16959,16966,16967,17001,17004,17009,17012,17540,17541,17629,18049,18056,18551,
		18737,18738,18844,18846,18848,18850,18852,19157,19158,19186,19214,19215,19249,19266,19270,19271,19421,19422,19432,
		19464,19469,19482,19530,19531,19579,19581,19583,19585,19590,19592,19598,19599,19603,19604,19610,19611,19688,19689,
		19694,19695,19700,19701,19710,19711,19715,19716,19720,19721,19740,19741,19746,19747,19749,19750,19771,19772,19774,
		19775,19777,19778,19780,19781,19796,19812,19824,19836,19969,20889,20896,20904,21370,21371,21379,21557,21558,21585,
		21589,21593,21599,21603,21606,21610,21614,21618,21621,21624,21628,21675,21691,21825,21889,21892,21893,21894,21895,
		21896,21920,21937,21938,21939,21950,21969,22081,22088,22093,22098,22136,22141,22146,22151,22156,22251,22299,22303,
		22307,22322,22341,22350,22398,22451,22481,22483,22484,22573,22622,22632,22750,22764,22765,22785,22786,22798,22803,
		22808,22814,22820,22826,22832,22838,22844,22997,22998,23002,23049,23050,23051,23060,23066,23079,23086,23123,23131,
		23135,23142,23146,23150,23157,23162,23169,23173,23180,23186,23193,23306,23307,23524,23525,23527,23528,23529,23536,
		23537,24427,24432,24436,24440,24455,24462,24469'
	when @SampListName = 'IPOB' then '22950,23004,4,77,8612,16688,482,744,796,8608,854,891,8615,9908,965,21637,21638,5111,977,
		10403,1589,21559,21560,1597,3092,4728,4734,5116,5185,5296,5300,5304,5315,5336,5342,8335,8635,8721,9064,9094,9096,
		9114,17838,9383,9461,9475,9483,9529,9779,9830,9909,10335,10336,15499,21374,9923,10033,10080,10217,10242,10353,
		10494,10495,10496,10497,10498,10499,10500,10511,10512,10513,10514,10515,10516,10517,10529,10530,10531,10532,10533,
		10534,10535,10555,10560,10561,10562,10563,10564,10565,10596,10609,10661,10662,10663,15440,11091,11123,11241,21562,
		11379,11414,11429,11451,11472,11495,11528,13603,13648,13650,13684,13696,13737,15518,15546,16714,16888,16891,16907,
		16932,16939,16952,16961,16969,16985,17000,17007,17538,17539,17552,17595,18044,18048,18843,18845,18847,18851,18849,
		18739,18771,19160,19185,19216,19248,19272,19420,19431,19479,19529,19565,19586,19593,19600,19605,19612,19623,19625,
		19627,19629,19631,19633,19635,19637,19639,19690,19696,19702,23060,23059,23055,23056,23057,23058,19712,19719,19748,
		19751,19776,19779,19782,19798,19814,19826,19838,20890,20898,21394,21546,21591,21595,21597,21601,21608,21612,21616,
		21626,21630,21827,21922,21945,21946,21947,21971,22083,22090,22095,22100,22138,22143,22148,22153,22158,22285,22316,
		22325,22336,22342,22355,22367,22375,22402,22430,22777,22516,22551,22716,22708,22664,22763,22787,22811,22951,22972,
		22973,22974,23005,23019,23074,23083,23103,23139,23154,23166,23177,23183,23190,23216,23266,23321,23323,23325,23327,
		23329,23331,23333,23335,23337,23339,23341,23343,23345,23347,23349,23351,23353,23355,23357,23359,23361,23363,23365,
		23367,23369,23371,23373,23375,23377,23379,23381,23383,23385,23387,23389,23391,23393,23395,23397,23533,23636,23663,
		23603,23605,23713,23716,23717,23718,23719,23721,23722,23783,23821,24490,24032,24428,24433,24437,24441,24445,24457,
		24464,24471,24497,24586'
	when @SampListName = 'IPOnc' then '19970,168,169,21717,485,489,847,8479,16792,9831,9900,21894,11092,13598,13656,15527,
		15548,16716,16886,16921,16949,16972,16993,17542,18050,19219,19463,19480,21382,21678,21386,21646,21848,22295,
		22352,22392,22376,22397,22431,22751,22476,22517,22530,22561,22615,22635,22738,22999,23069,23214,23264,23550,
		23665,23661,23612,23734,23781,23834'
	when @SampListName = 'IPPeds' then '10774,19806,23022,81,19968,16698,795,852,941,951,10333,10334,15498,21373,966,21639,
		21640,5117,5204,8482,8638,8639,9116,9444,9382,9462,9481,9491,9528,9668,9871,9903,10360,11090,11212,20900,11540,
		13663,13664,13701,13702,13705,13738,15514,15515,15516,16908,16930,16950,16970,16984,17554,18007,18008,18009,
		18052,18425,18513,18497,18729,18730,18741,19159,19229,19233,19234,19230,19231,19252,19253,19254,19255,19256,19466,
		19571,19828,19829,21440,21551,22313,22356,22371,22391,22392,22378,22400,22428,22753,22482,22532,22569,22851,23030,
		23023,23075,23221,23272,23526,23538,23604,24563'
	when @SampListName = 'IPRehab' then '8727,18674,19807,21983,82,697,855,901,5112,5126,5209,22236,9519,9828,10035,
		10177,10351,10352,10358,10359,10365,10366,10372,10373,10379,10380,10386,10387,10393,10394,10400,10401,10409,10410,
		10417,10418,10628,10666,22742,19981,20672,20684,19975,20687,19978,13597,13647,13704,23062,16894,16910,16951,20883,
		18055,18426,18507,19251,19256,19566,19977,19979,19980,19983,20676,20677,20685,20688,20905,20994,22326,22349,22427,
		22477,22533,22623,23102,23220,23271,23820,23823,24499,24587'
	when @SampListName = 'OPLab' then '175,978,16788,2267,5122,5142,5178,17560,17562,17573,9766,10135,9987,10104,
		10120,10155,10304,10462,10634,10643,10673,11407,11434,11456,11476,11500,11656,11675,11688,13610,17888,18446,18539,
		18563,18584,18617,19205,19208,21762,22241,22332,22441,22460,22464,22471,22495,22499,22504,23113,23311,23617,23844,
		24421,25272'
	when @SampListName = 'OPRad' then '8490,181,23028,981,16789,2266,5137,5143,5181,9213,9451,9454,9769,9770,9808,
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

create table #SamplePops (Samplepop_id int, sampleunit_id int)
set @SQL = '
insert into #SamplePops
select samplepop_id, sampleunit_id
from selectedsample ss, samplepop sp
where ss.sampleset_id = sp.sampleset_id
and ss.pop_id = sp.pop_id
and ss.strunitselecttype = ''D''
and ss.sampleunit_id in ('+@SampUnitList+')'
exec(@SQL)

select qr.* into #Results 
from questionform qf, #samplepops sp, questionresult qr
where qf.samplepop_id = sp.samplepop_id
and qf.questionform_id = qr.questionform_id
and qf.datreturned < @EndDate

set @SQL = '
delete r
from #results r left outer join '+@NRCNormTable+' nt on r.qstncore = nt.qstncore and r.intresponseval = nt.intresponseval
where nt.intresponseval is null'
exec(@SQL)

delete r
from #results r, sel_qstns sq
where r.qstncore = sq.qstncore
and bitmeanable = 0
and sq.subtype = 1 
and sq.language = 1

select sampleunit_id, qstncore
into #delete
from #results
group by sampleunit_id, qstncore
having count(*) < 30

delete r
from #results r, #delete d
where r.sampleunit_id = d.sampleunit_id
and r.qstncore = d.qstncore

drop table #Delete

select qstncore
into #todelete
from #results
group by qstncore
having count(distinct sampleunit_id) < 10

delete r
from #results r, #todelete d
where r.qstncore = d.qstncore

drop table #todelete

create table #UnitCores (SampleUnit_id int, QstnCore int, Client_id int)

insert into #UnitCores (sampleunit_id, qstncore)
select distinct SampleUnit_id, QstnCore
from #results

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

delete #results
where qstncore not in (
select qstncore
from #clientcores
group by qstncore
having count(*) > 1
)

create table #rank (Qstncore int, Sampleunit_id int, Mean float, Percentile float)

declare @Qstncore int

declare QstnCursor cursor for select distinct qstncore from #results order by qstncore
open qstncursor
fetch next from qstncursor into @Qstncore

while @@fetch_status = 0
begin
 create table #TempRank (QstnCore int, Sampleunit_id int, Mean float, Rank_id int identity(1,1), Percentile float)
 set nocount on
 insert into #TempRank (QstnCore, Sampleunit_id, Mean)
 select qstncore, sampleunit_id, avg(intresponseval+0.0)
 from #results
 where qstncore = @qstncore
 group by sampleunit_id, qstncore
 order by qstncore, avg(intresponseval+0.0)

 update #TempRank set percentile = Rank_id/(select max(rank_id/100.0) from #TempRank)

 insert into #Rank
 select top 1 QstnCore, Sampleunit_id, Mean, Percentile
 from #TempRank
 where percentile >= 75
 order by percentile

 drop table #TempRank
 fetch next from qstncursor into @Qstncore
 set nocount off
end

close qstncursor
deallocate qstncursor

set @SQL = 'create table '+@TableName+' (QstnCore int, IntResponseVal int, UWNSize int)'
exec(@SQL)

set @SQL = '
insert into '+@TableName+'
select r.qstncore, r.intresponseval, count(*) as UWNSize
from #results r, #Rank rk
where r.qstncore = rk.qstncore
and r.sampleunit_id = rk.sampleunit_id
group by r.qstncore, r.intresponseval
order by r.qstncore, r.intresponseval'
exec(@SQL)

drop table #rank
drop table #results
drop table #samplepops
drop table #clientcores
drop table #unitcores

