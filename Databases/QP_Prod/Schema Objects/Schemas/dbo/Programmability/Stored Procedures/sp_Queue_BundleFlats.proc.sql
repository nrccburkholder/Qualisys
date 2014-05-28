/***********************************************************************************************************************************
SP Name: sp_Queue_BundleFlats
Part of: Queue Manager
Purpose: 
Input:  
 
Output:  
Creation Date: 03/27/2001
Author(s): DG
Revision: First build - 03/27/2001
v1.01 - BD - 04/13/2001
changed strPostalBundle delimiter from ':' to '-' since the field is used as part of the print file filenames
v1.02 - DG - 10/24/2001
bundles need to keep their original category, not take the category above the tray they end up in
v1.03 - Felix Gomez - 3/14/2002
Added @strPclOutput
v1.04 - Brian Dohmen - 9/17/2002
update NPSentMailing at the end (used to speed up Queue Manager)
v1.05 - Dave Gilsdorf - 10/1/2002
removed code that grabs any unprinted items and includes them in the current bundling (caused problems when generating 
double-stuffs in one night)
v1.06 - Dave Gilsdorf - 10/1/2002
move any bundle portion with less than 10 peices into the bundle's larger portion in the next (or previous) tray
v1.07 - Dave Gilsdorf - 10/15/2002
fixed a bug from v1.06 that occurs when both portions have less than 10 peices
v1.08 - Dave Gilsdorf - 11/2/2002
for some reason, the code from v1.04 is not here.  I put it back in.
v1.09 - Dave Gilsdorf - 11/3/2002
use a variable so both sentmailing's and npsentmailing's datbundled is the same
v1.10 - Dave Gilsdorf - 11/4/2002
Tray_num assignment done in sp_Queue_MakeTray (except for MADC trays); fixed join bugs in #FixSmallPortions
v1.11 - DG - 11/6/2002
The calculation should be using 75% full trays to be considered "Full" to properly calculate a full tray.
v1.12 - DG - 6/30/2005
updated to use BundlingCodes, instead of going to each study's population table
***********************************************************************************************************************************/
CREATE PROCEDURE dbo.sp_Queue_BundleFlats
  @Survey_id int, 
  @PaperConfig_id int, 
  @datBundled datetime, 
  @intTrayCapacity int,
  @intBundleStatus int OUTPUT,
  @strPclOutput varchar(30) = 'dbo.pcloutput'
AS

 declare @r int
 exec @r=sp_Queue_CheckPCLOutputLocation 'sp_Queue_BundleFlats', @strPCLOutput
 if @r=-1 return

 SET @intBundleStatus = 0
 DECLARE @Study_id int
 DECLARE @strSQL varchar(2000)
 CREATE TABLE #PopBundle_Cnts (
  Survey_id int,
  PaperConfig_id int,
  Zip4_flg char(1),
  Bundle_cd varchar(6),
  Cnts int,
  Zip5 char(5), Zip3 char(3),
  ADC char(5)
 )
 CREATE INDEX idx_dedup ON #PopBundle_Cnts (Survey_id, PaperConfig_id, Zip4_flg) 
 CREATE TABLE #PopBundle (
  Survey_id int,
  PaperConfig_id int,
  SentMail_id int,
  Zip5 char(5), Zip4_flg char(1), Zip3 char(3),
  Bundle_cd varchar(6),
  Tray_cd varchar(6),
  Tray_num int, 
  Tray_Cap int,
  ADC char(5)
 )
 CREATE TABLE #TempWorkTable
  (Survey_id int,
  PaperConfig_id int,
  SentMail_id int)
 CREATE INDEX IDX_TempSurvey_id ON #TempWorkTable(Survey_id)
-- Build this TempWorkTable before we build PopBundle 
 INSERT INTO #TempWorkTable  
  SELECT DISTINCT MM.Survey_id, SM.PaperConfig_id, SM.SentMail_id
  FROM qp_queue..pcloutput PO, dbo.SentMailing SM, dbo.MailingMethodology MM
  WHERE PO.SentMail_id = SM.SentMail_id  
   AND SM.Methodology_id = MM.Methodology_id  
   and MM.Survey_id=@Survey_id
   and SM.PaperConfig_id=@PaperConfig_id
   and abs(datediff(second,sm.datBundled,@datBundled))<=1 
   AND SM.strPostalBundle is NOT NULL
-- Populate PopBundle with the data for each Study's Population that is in #TempWorkTable... 
 insert into #PopBundle (Survey_id, PaperConfig_id, SentMail_id, Zip5, Zip4_flg, Zip3) 
 select Survey_id, PaperConfig_id, twt.SentMail_id, Zip5, 
	case when bc.Zip4 is null then 'N' else 'Y' end as Zip4_flg, SUBSTRING(bc.Zip5,1,3) as Zip3
 from #TempWorkTable twt, bundlingcodes bc
 where twt.sentmail_id=bc.sentmail_id

 drop table #TempWorkTable 

-- Update #PopBundle's adc value from USPS 
 UPDATE #PopBundle
  SET adc = u.adc
  FROM #PopBundle p, dbo.usps u
  WHERE p.Zip3 = u.Zip3_cd

-- Determine which Bundle a Survey, PaperConfig will belong to 
 
-- K's and O's 
 INSERT INTO #PopBundle_Cnts (Survey_id, PaperConfig_id, Zip4_flg, Bundle_cd, Zip5, Cnts)
  SELECT Survey_id, PaperConfig_id, Zip4_flg,
   CASE WHEN Zip4_flg='Y' THEN 'K' ELSE 'O' END + Zip5, 
   Zip5, count(*)  FROM #PopBundle p
  WHERE p.Bundle_cd IS NULL
  Group BY Survey_id, PaperConfig_id, Zip4_flg,
   CASE WHEN Zip4_flg='Y' THEN 'K' ELSE 'O' END + Zip5, Zip5
  HAVING COUNT(*) >= 10
 UPDATE #PopBundle
  SET #PopBundle.Bundle_cd = pbc.Bundle_cd
  FROM #PopBundle_Cnts pbc
  WHERE #PopBundle.Survey_id = pbc.Survey_id
   AND #PopBundle.PaperConfig_id = pbc.PaperConfig_id
   AND #PopBundle.Zip5 = pbc.Zip5 
   AND ( (#PopBundle.Zip4_flg='N' AND pbc.Zip4_flg = 'N') OR
    (#PopBundle.Zip4_flg='Y' AND pbc.Zip4_flg = 'Y'))
   AND #PopBundle.Bundle_cd IS NULL
 DELETE FROM #PopBundle_Cnts
-- L's and P's 
 INSERT INTO #PopBundle_Cnts (Survey_id, PaperConfig_id, Zip4_flg, Bundle_cd, Zip3, Cnts)
  SELECT Survey_id, PaperConfig_id, Zip4_flg,
   CASE WHEN Zip4_flg='Y' THEN 'L' ELSE 'P' END + Zip3, 
   Zip3, count(*)
  FROM #PopBundle p
  WHERE p.Bundle_cd IS NULL
  Group BY Survey_id, PaperConfig_id, Zip4_flg,
   CASE WHEN Zip4_flg='Y' THEN 'L' ELSE 'P' END + Zip3, 
   Zip3
  HAVING COUNT(*) >= 10
 UPDATE #PopBundle
  SET #PopBundle.Bundle_cd = pbc.Bundle_cd
  FROM #PopBundle_Cnts pbc
  WHERE #PopBundle.Survey_id = pbc.Survey_id
   AND #PopBundle.PaperConfig_id = pbc.PaperConfig_id
   AND ( (#PopBundle.Zip4_flg='N' AND pbc.Zip4_flg='N') OR
    (#PopBundle.Zip4_flg='Y' AND pbc.Zip4_flg='Y'))
   AND #PopBundle.Zip3 = pbc.Zip3
   AND #PopBundle.Bundle_cd IS NULL
 DELETE FROM #PopBundle_Cnts
-- M's and Q's 
 INSERT INTO #PopBundle_Cnts (Survey_id, PaperConfig_id, Zip4_flg, Bundle_cd, adc, Cnts)
  SELECT Survey_id, PaperConfig_id, Zip4_flg,
   CASE WHEN Zip4_flg='Y' THEN 'M' ELSE 'Q' END + adc, 
   adc, count(*)
  FROM #PopBundle p
  WHERE p.ADC IS NOT NULL
   AND p.Bundle_cd IS NULL
  Group BY Survey_id, PaperConfig_id, Zip4_flg, 
   CASE WHEN Zip4_flg='Y' THEN 'M' ELSE 'Q' END + adc, 
   adc
  HAVING COUNT(*) >= 10
 UPDATE #PopBundle
  SET #PopBundle.Bundle_cd = pbc.Bundle_cd
  FROM #PopBundle_Cnts pbc
  WHERE #PopBundle.Survey_id = pbc.Survey_id
   AND #PopBundle.PaperConfig_id = pbc.PaperConfig_id
   AND ( (#PopBundle.Zip4_flg='N' AND pbc.Zip4_flg='N') OR
    (#PopBundle.Zip4_flg='Y' AND pbc.Zip4_flg='Y'))
   AND #PopBundle.ADC = pbc.ADC
   AND #PopBundle.Bundle_cd IS NULL
  drop table #PopBundle_Cnts
-- N's and R's 
 UPDATE #PopBundle
  SET Bundle_cd = CASE WHEN Zip4_flg='Y' THEN 'N' ELSE 'R' END + 'MADC'
  WHERE #PopBundle.Bundle_cd IS NULL

exec sp_Queue_MakeTray 'Zip5', 'K', 'O', '', @intTrayCapacity
exec sp_Queue_MakeTray 'Zip3', 'L', 'P', 'KO', @intTrayCapacity
exec sp_Queue_MakeTray 'ADC',  'M', 'Q', 'KOLP', @intTrayCapacity

update #PopBundle 
 set Tray_cd = case when Zip4_flg='Y' then 'N' else 'R' end + 'MADC',
--     v1.02 - bundles need to keep their original category, not take the category above the tray they end up in
--     Bundle_cd = case when Zip4_flg='Y' then 'M' else 'Q' end + ADC,
     Tray_cap = (@intTrayCapacity * 4) / 3
where Tray_cd is null

create table #PopBundleID (incID int IDENTITY (1, 1) NOT NULL , 
                           Survey_id int, 
                           PaperConfig_id int, 
                           SentMail_id int, 
                           tray_num int,
                           tray_cap int,
                           Tray_cd varchar(6))
insert into #PopBundleID (Survey_id,PaperConfig_id,SentMail_id,Tray_cd,tray_cap)
  select Survey_id,PaperConfig_id,SentMail_id,Tray_cd,tray_cap
  from #PopBundle
  where tray_num is null
  order by Survey_id,PaperConfig_id,Tray_cd,Bundle_cd

update pb set Tray_num = 1+FLOOR((incID-baseID)/Tray_cap)
from #PopBundleID pb, (	select Survey_id,PaperConfig_id,Tray_cd,min(incID) as baseID
			from #PopBundleid
			Group by Survey_id,PaperConfig_id,Tray_cd) base
where pb.Survey_id=base.Survey_id
  and pb.PaperConfig_id=base.PaperConfig_id
  and pb.Tray_cd=base.Tray_cd

update pb set tray_cap=i.tray_cap, Tray_num = i.tray_num
from #PopBundle pb, #PopBundleid i
where pb.SentMail_id=i.SentMail_id

drop table #PopBundleID

-- produce a list of all bundle portions that have less than 10 peices 
-- (a bundle portion is a bundle that was split up into two trays)
select tray_cd, tray_num, bundle_cd, count(*) as cnt
into #fixsmallportions
from #popbundle
where bundle_cd not like '_MADC'
group by tray_cd, tray_num, bundle_cd
having count(*)<10

-- if both portions have <10 peices, use the larger one
delete fsp
from #fixsmallportions fsp, (	select tray_cd,bundle_cd,min(cnt) as mincnt
				from #fixsmallportions
				group by tray_cd,bundle_cd
				having count(*)>1 
				and min(cnt) <> max(cnt)) sub
where fsp.tray_cd=sub.tray_cd
and fsp.bundle_cd=sub.bundle_cd
and fsp.cnt=sub.mincnt

-- if both portions have <10 peices and they're both the same size, use the first tray
delete fsp
from #fixsmallportions fsp, (	select tray_cd,bundle_cd,min(tray_num) as mintray_num
				from #fixsmallportions
				group by tray_cd,bundle_cd
				having count(*)>1 and min(cnt) = max(cnt)) sub
where fsp.tray_cd=sub.tray_cd
and fsp.bundle_cd=sub.bundle_cd
and fsp.tray_num=sub.mintray_num

-- update the tray_num in #fixsmallportions with the tray_num of each bundle's 
-- larger portion (from the next -- or previous -- tray)
update fsp
set fsp.tray_num=pb.tray_num
from #popbundle pb, #fixsmallportions fsp
where pb.bundle_cd=fsp.bundle_cd
and pb.tray_cd=fsp.tray_cd
and abs(pb.tray_num - fsp.tray_num) = 1

-- update the tray_num for the small portions in #popbundle with the re-assigned
-- tray_num from #fixsmallportions 
update pb
set pb.tray_num=fsp.tray_num
from #popbundle pb, #fixsmallportions fsp
where pb.bundle_cd=fsp.bundle_cd
and pb.tray_cd=fsp.tray_cd
and abs(pb.tray_num - fsp.tray_num) = 1

drop table #fixsmallportions

declare @newdatbundled datetime
set @newdatbundled=getdate()

update SentMailing
set strPostalBundle=rtrim(Tray_cd)+'-'+right(convert(varchar,100+Tray_num),2),
    strGroupDest=Bundle_cd,
    datBundled=@newdatbundled
from #PopBundle 
where SentMailing.SentMail_id=#PopBundle.SentMail_id

update NPSentMailing
set strPostalBundle=rtrim(Tray_cd)+'-'+right(convert(varchar,100+Tray_num),2),
    strGroupDest=Bundle_cd,
    datBundled=@newdatbundled
from #PopBundle 
where NPSentMailing.SentMail_id=#PopBundle.SentMail_id

drop table #PopBundle


