/***********************************************************************************************************************************
SP Name: sp_Queue_MakeTray
Part of: Queue Manager
Purpose: 
Input:  
 
Output:  
Creation Date: 03/27/2001
Author(s): DG
Revision: First build - 03/27/2001
v1.01 - DG - 10/15/2002
slightly increased counts of some trays so that their leftovers aren't less than 10 peices
v1.02 - DG - 11/4/2002
bumped up @intTrayCapacity by 10% so removing partial bundles will still keep a tray 2/3 full; assigned tray numbers (instead of 
doing it in sp_Queue_BundleFlats; if traying causes any bundles to split up so one of the parts has less than 10 peices, 
re-combine the bundle parts
***********************************************************************************************************************************/
create procedure sp_Queue_MakeTray
 @TrayDefFld char(10), @Zip9char char(1), @Zip5char char(1), @ParentChars varchar(10), @intTrayCapacity int
as
  declare @SQL varchar(1000), @maxTrayCapacity int
  set @maxTrayCapacity = (@intTrayCapacity * 3) / 2
  set @intTrayCapacity = (@intTrayCapacity * 1.1)

  CREATE TABLE #tray_cnts (
    survey_id int,
    paperconfig_id int,
    tray_cd varchar(6),
    cnts int,
    numTrays int default 0,
    Tray_Cap int default 0)

  set @SQL = 
    'insert into #tray_cnts (survey_id,paperconfig_id,tray_cd,cnts)
    select survey_id,paperconfig_id,
    case when zip4_flg=''Y'' then '''+@Zip9Char+''' else '''+@Zip5Char+''' end + ' + @TrayDefFld+ ',
    count(*)
    from #PopBundle pb
    where tray_cd is null and charindex(left(bundle_cd,1),'''+@Zip9Char+@Zip5Char+@ParentChars+''')>0
    group by survey_id,paperconfig_id,
    case when zip4_flg=''Y'' then '''+@Zip9Char+''' else '''+@Zip5Char+''' end + ' + @TrayDefFld+ '
    having count(*) >= ' + convert(varchar,@intTrayCapacity)
  exec (@SQL)

  -- identify the bundles that can be split up into trays without overflow
  update #tray_cnts
   set numTrays=             ceiling(cnts/(@maxTrayCapacity+0.0)),
       Tray_Cap =ceiling(cnts/ceiling(cnts/(@maxTrayCapacity+0.0))+0.0)
  where ceiling(cnts/ceiling(cnts/(@maxTrayCapacity+0.0))+0.0)>=@intTrayCapacity

  create table #traynum (incID int identity(1,1), sentmail_id int, tray_cd varchar(6), tray_cap int, tray_num int)
  set @SQL = 'insert into #traynum (sentmail_id,tray_cd, tray_cap)
    select pb.sentmail_id, tc.tray_cd, tc.tray_cap
    from #PopBundle PB, #Tray_Cnts tc
    where pb.tray_cd is null
      and PB.survey_id=tc.survey_id
      and pb.paperconfig_id=tc.paperconfig_id
      and case when pb.zip4_flg=''Y'' then '''+@Zip9Char+''' else '''+@Zip5Char+''' end + pb.' + @TrayDefFld+ '=tc.tray_cd
      and charindex(left(bundle_cd,1),'''+@Zip9Char+@Zip5Char+@ParentChars+''')>0
      and tc.numTrays>0
    order by tc.tray_cd, pb.bundle_cd'
  exec (@SQL)
  
  update tn 
  set Tray_num = 1+FLOOR((incID-baseID)/Tray_cap)
  from #traynum tn,
   (select Tray_cd,min(incID) as baseID
    from #traynum
    Group by tray_cd) base
  where tn.tray_cd=base.tray_cd

  update pb
  set tray_cd=tn.tray_cd, tray_cap=tn.tray_cap, tray_num=tn.tray_num
  from #PopBundle pb, #traynum tn
  where pb.sentmail_id=tn.sentmail_id

  -- remove those bundles from #tray_cnts
  delete from #Tray_cnts where numTrays>0
  truncate table #trayNum

  -- identify the bundles that will fill up one tray, but have overflow into the next level trays
  update #tray_cnts
   set numTrays=ceiling(cnts/(@maxTrayCapacity+0.0))-1,
       Tray_Cap =@maxTrayCapacity
  where numTrays=0
    and cnts>=@intTrayCapacity

  --get the first @maxTrayCapacity people from these bundles
  create table #IDS (incID int IDENTITY (1, 1) NOT NULL , 
                     survey_id int, 
                     paperconfig_id int, 
                     sentmail_id int, 
                     tray_cd varchar(6),
                     bundle_cd varchar(6), 
                     assignedtray_cd varchar(6),
                     tray_cap int, 
                     tray_num int)

  set @SQL = 
    'insert into #IDS (survey_id, paperconfig_id, sentmail_id, tray_cd, bundle_cd)
      select pb.survey_id, pb.paperconfig_id, pb.sentmail_id, tc.tray_cd, pb.bundle_cd
      from #tray_cnts tc, #PopBundle pb
      where pb.tray_cd is null
        and PB.survey_id=tc.survey_id
        and pb.paperconfig_id=tc.paperconfig_id
        and case when pb.zip4_flg=''Y'' then '''+@zip9char+''' else '''+@zip5char+''' end + pb.' + @TrayDefFld+ '=tc.tray_cd
        and charindex(left(bundle_cd,1),'''+@zip9char+@zip5char+@ParentChars+''')>0
        and numTrays>0
      order by pb.survey_id,pb.paperconfig_id,tc.tray_cd,pb.bundle_cd'
  exec (@SQL)

  -- assign the first @maxTrayCapacity people in each bundle to a tray
  update #ids
    set #ids.assignedtray_cd = sub.tray_cd, #ids.tray_cap=@maxTrayCapacity
  from (-- get the 1st @maxTrayCapacity people in each bundle
                       select sentmail_id, i.tray_cd
                       from #IDS I, (select survey_id, paperconfig_id, tray_cd, min(incID) as baseID 
                                     from #ids group by survey_id, paperconfig_id,tray_cd) base
                       where i.survey_id=base.survey_id
                         and i.paperconfig_id=base.paperconfig_id
                         and i.tray_cd=base.tray_cd
                         and 1+incid-baseid <= @maxTrayCapacity) sub
  where #ids.sentmail_id=sub.sentmail_id

  -- if traying causes any bundles to split up so one of the parts has less than 10 peices, 
  -- re-combine the bundle parts
  update I
  set assignedtray_cd = sub.forcedtray
  from #ids I, (	select assignedtray_cd, bundle_cd, count(*) as cnt, max(tray_cd) as forcedtray
			from #ids
			where assignedtray_cd is null
			group by assignedtray_cd, bundle_cd
			having count(*) < 10 ) sub
  where i.assignedtray_cd is null
  and i.bundle_cd=sub.bundle_cd

  update I
  set assignedtray_cd = NULL, tray_num=null, tray_cap=null
  from #ids I, (	select assignedtray_cd, bundle_cd, count(*) as cnt, max(tray_cd) as forcedtray
			from #ids
			where assignedtray_cd is not null
			group by assignedtray_cd, bundle_cd
			having count(*) < 10 ) sub
  where i.assignedtray_cd is not null
  and i.bundle_cd=sub.bundle_cd

  update I
  set tray_cap=sub.cnt
  from #ids I, (select assignedtray_cd,count(*) as cnt from #ids group by assignedtray_cd) sub
  where i.assignedtray_cd=sub.assignedtray_cd
  and i.assignedtray_cd is not null


  update I set Tray_num = 1+FLOOR((incID-baseID)/Tray_cap)
  from #ids I, (	select assignedTray_cd,min(incID) as baseID
			from #ids
			Group by assignedTray_cd) base
  where i.assignedTray_cd=base.assignedTray_cd

  update PB
  set pb.tray_cd = i.assignedtray_cd, pb.tray_num=i.tray_num, pb.tray_cap=i.tray_cap
  from #PopBundle pb, #ids I
  where pb.sentmail_id=i.sentmail_id

  drop table #IDS
  drop table #Tray_Cnts
  drop table #Traynum


