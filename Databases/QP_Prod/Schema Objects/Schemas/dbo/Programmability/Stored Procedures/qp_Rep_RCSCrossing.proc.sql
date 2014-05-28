create procedure qp_Rep_RCSCrossing
@CrossingID int,
@MarketID int
as
/*
declare @CrossingID int, @MarketID int
set @CrossingID=500
set @MarketID=20
*/

declare @strSQL varchar(8000), @Table_nm varchar(50), @Format_nm varchar(20)
declare @TotalN float

create table #named (intStubAnswer int, strStub varchar(60), intBannerAnswer int, strBanner varchar(60), numFreq float, StubOrder1 float, StubOrder2 float, StubOrder3 float, BannerOrder int)

select @Table_nm=strTable_nm, @Format_nm=strFormatMethod_nm from nrc14.hcmg_dev.dbo.crossing where crossing_id=@CrossingID

if @Format_nm='Hospitals'
  set @strSQL= 'insert into #Named
	select s.intStubAnswer, sr.strResponse, s.intBannerAnswer, br.strResponse, s.numFreq, 0,0,0, br.intOrder'
else if @Format_nm='HealthPlans'
  set @strSQL='insert into #Named
	select s.intStubAnswer, sr.strResponse, s.intBannerAnswer, br.strResponse, s.numFreq, 
	-case s.intStubAnswer%10 when 1 then 2 when 2 then 4 when 3 then 3 when 4 then 1 else s.intStubAnswer%10 end, 0.0, 0.0, br.intOrder'
else
  set @strSQL = 
	'insert into #named
	select s.intStubAnswer, sr.strResponse, s.intBannerAnswer, br.strResponse, s.numFreq, -sr.intOrder,0,0, br.intOrder'

set @strSQL = @strSQL + 
	' from nrc14.hcmg_dev.dbo.'+@table_nm+' s, nrc14.hcmg_dev.dbo.crossing c, nrc14.hcmg_dev.dbo.app_question sq, nrc14.hcmg_dev.dbo.app_question bq, nrc14.hcmg_dev.dbo.app_response sr, nrc14.hcmg_dev.dbo.app_response br
	where s.crossing_id='+convert(varchar, @CrossingID)+'
	  and s.market_id='+convert(varchar,@MarketID)+'
	  and s.crossing_id=c.crossing_id
	  and c.stubappquestion_id = sq.appquestion_id
	  and c.bannerappquestion_id = bq.appquestion_id
	  and sq.intScale = sr.intScale
	  and s.intStubAnswer = sr.intResponseValue
	  and bq.intScale = br.intScale
	  and s.intBannerAnswer = br.intResponseValue
	order by sr.intOrder, br.intOrder'

exec (@strSQL)

if @Format_nm='Hospitals'
begin
	update N
	set StubOrder3 = n2.numFreq
	from #Named N, #Named N2
	where n.intStubAnswer = n2.intStubAnswer
	and n2.intBannerAnswer=-10

	create table #HospSys (intStubAnswer int, strStub varchar(76), intBannerAnswer int, strBanner varchar(70), numFreq float, StubOrder2 float, BannerOrder int)

	insert into #HospSys
	select h.HospitalSystem_id as intStubAnswer,  'Total ' + h.strHospitalSystem_nm as strStub, intBannerAnswer, strBanner, sum(numFreq) as numFreq,  0.0 as StubOrder2, BannerOrder
	from #Named n, nrc14.hcmg_dev.dbo.Hospitals_view h
	where n.intStubAnswer = h.intHospital_cd
	  and h.HospitalSystem_id > 0
	group by h.HospitalSystem_id, h.strHospitalSystem_nm, intBannerAnswer, strBanner, BannerOrder


	update S
	set StubOrder2 = S2.numFreq
	from #HospSys S, #HospSys S2
	where s.intStubAnswer = s2.intStubAnswer
	and s2.intBannerAnswer=-10

	select @TotalN=numFreq
	from #named
	where intStubAnswer=-10 and intBannerAnswer = -10

	delete from #Named where ((StubOrder3 < 3.0) or (StubOrder3/@TotalN) < 0.01) and intStubAnswer >0  
	delete from #HospSys where (StubOrder2 < 3.0) or (StubOrder2/@TotalN) < 0.01

	update N
	set N.StubOrder2 = s.StubOrder2, n.strStub = '   ' + rtrim(n.strStub)
	from #Named N, nrc14.hcmg_dev.dbo.hospitals_view h, #hospsys s
	where n.intStubAnswer = h.intHospital_cd
	  and h.HospitalSystem_id=s.intStubAnswer
	  and n.intBannerAnswer=s.intBannerAnswer

	update #named set StubOrder2 = StubOrder3 where StubOrder2 = 0.0

	insert into #Named 
	  select intStubAnswer, strStub, intBannerAnswer, strBanner, numFreq, 0, StubOrder2, @TotalN, BannerOrder from #hospsys
	drop table #hospsys
end
else if @Format_nm='HealthPlans'
begin
	create table #PlanSys (intStubAnswer int, strStub varchar(76), intBannerAnswer int, strBanner varchar(70), numFreq float, StubOrder3 float, bannerorder int)

	update N
	set StubOrder2 = n2.numFreq
	from #Named N, #Named N2
	where n.intStubAnswer = n2.intStubAnswer
	and n2.intBannerAnswer=-10

	insert into #PlanSys
	select (h.HealthPlanSystem_id*10)+n.intStubAnswer%10, 
		case n.intStubAnswer%10 when 1 then 'HMO' when 2 then 'PPO' when 3 then 'POS' when 4 then 'FFS' else 'OTH' end + ' : TOTAL ' + h.strHlthPlnSys_nm, 
		intBannerAnswer, strBanner, sum(numFreq) as numFreq,  count(*), n.bannerorder
	from #Named n, nrc14.hcmg_dev.dbo.HealthPlans_view h
	where floor(n.intStubAnswer/10) = h.intHealthPlan_cd
	  and h.HealthPlanSystem_id > 0
	group by (h.HealthPlanSystem_id*10)+n.intStubAnswer%10, case n.intStubAnswer%10 when 1 then 'HMO' when 2 then 'PPO' when 3 then 'POS' when 4 then 'FFS' else 'OTH' end + ' : TOTAL ' + h.strHlthPlnSys_nm, intBannerAnswer, strBanner, n.bannerorder

	delete s /* Deletes any "system" that really only has one plan in it */
	from #PlanSys S, #PlanSys S2
	where s.intStubAnswer = s2.intStubAnswer
	and s2.intBannerAnswer=-10
	and s2.StubOrder3=1

	update S
	set StubOrder3 = S2.numFreq
	from #PlanSys S, #PlanSys S2
	where s.intStubAnswer = s2.intStubAnswer
	and s2.intBannerAnswer=-10

	select @TotalN=numFreq
	from #named
	where intStubAnswer=-10 and intBannerAnswer = -10

	delete from #Named where ((StubOrder2 < 3.0) or (StubOrder2/@TotalN) < 0.01) and intStubAnswer >0 and StubOrder2<25.0
	delete from #PlanSys where ((StubOrder3 < 3.0) or (StubOrder3/@TotalN) < 0.01) and StubOrder3<25.0

	update N
	set N.StubOrder3 = s.StubOrder3, n.strStub = '   ' + rtrim(n.strStub)
	from #Named N, nrc14.hcmg_dev.dbo.HealthPlans_view h, #PlanSys s
	where floor(n.intStubAnswer/10) = h.intHealthPlan_cd
	  and h.HealthPlanSystem_id=floor(s.intStubAnswer/10)
	  and n.intStubAnswer%10 = s.intStubAnswer%10
	  and n.intBannerAnswer=s.intBannerAnswer

	update #named set StubOrder3 = StubOrder2 where StubOrder3 = 0.0

	insert into #Named 
	  select intStubAnswer, strStub, intBannerAnswer, strBanner, numFreq, 
	    -case intStubAnswer%10 when 1 then 2 when 2 then 4 when 3 then 3 when 4 then 1 else 0 end,
	    @TotalN, StubOrder3,bannerorder from #PlanSys
	drop table #PlanSys
end


select distinct intStubAnswer, strStub, StubOrder1, StubOrder2, StubOrder3
into #crossing
from #named 
order by StubOrder2 desc, StubOrder3 desc, StubOrder1 desc

declare @intAnswer int, @strBanner varchar(70),  @banorder int
declare curBanner cursor for
  select distinct intBannerAnswer,strBanner,Bannerorder from #named order by Bannerorder

open curBanner
fetch next from curBanner into @intAnswer, @strBanner, @banorder
while @@fetch_status=0
begin
   set @strSQL = 'alter table #crossing add ['+@strBanner+'] float'
   exec (@strSQL)
   set @strSQL =  'update c set ['+@strBanner+'] = numFreq from #crossing c, #named n where c.intStubAnswer = n.intStubAnswer and n.intBannerAnswer = ' + convert(varchar,@intAnswer)
   exec (@strSQL)
   fetch next from curBanner into @intAnswer, @strBanner, @banorder
end
close curBanner
deallocate curBanner

alter table #crossing drop column intStubAnswer, StubOrder1, StubOrder2, StubOrder3
select * from #crossing


