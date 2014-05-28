create procedure APlan_DefHCMG
  @bit98 bit, @bit99 bit, @bit00 bit, @Table_nm varchar(50), @where varchar(1000) = ''
as
declare @SQL varchar(1000)

set @SQL = 'select name from sysobjects where id = object_id(N'''+@table_nm+''') and OBJECTPROPERTY(id, N''IsUserTable'') = 1'
exec (@SQL)
if @@Rowcount>0
  Return

create table #HCMGNorm (HCMGYear int, HCMGQNmbr char(3), hospital_id int, response int, UWNSize int, WNSize float)
select top 10 * from hcmg1998
if @bit98=1
begin
  if @where = ''
    update hcmg1998 set bitAPlanFilter=1
  else 
  begin
    set @SQL = 'update hcmg1998 set bitAPlanFilter= case when '+@where+' then 1 else 0 end'
    exec (@SQL)
  end

  insert into #HCMGNorm select 1998,'31a', isnull(FACINPA,0), isnull(CORDINPA,-9), count(*),sum(weight) from hcmg1998 where bitAPlanFilter=1 and isnull(CORDINPA,FACINPA) is not null group by isnull(CORDINPA,-9),isnull(FACINPA,0)
  insert into #HCMGNorm select 1998,'31b', isnull(FACER,0), isnull(CORDER,-9), count(*),sum(weight) from hcmg1998 where bitAPlanFilter=1 and isnull(CORDER,FACER) is not null group by isnull(CORDER,-9),isnull(FACER,0)
  insert into #HCMGNorm select 1998,'31c', isnull(FACSURG,0), isnull(CORDSURG,-9), count(*),sum(weight) from hcmg1998 where bitAPlanFilter=1 and isnull(CORDSURG,FACSURG) is not null group by isnull(CORDSURG,-9),isnull(FACSURG,0)
  insert into #HCMGNorm select 1998,'31d', isnull(FACXRAY,0), isnull(CORDXRAY,-9), count(*),sum(weight) from hcmg1998 where bitAPlanFilter=1 and isnull(CORDXRAY,FACXRAY) is not null group by isnull(CORDXRAY,-9),isnull(FACXRAY,0)
  insert into #HCMGNorm select 1998,'32a', isnull(FACINPA,0), isnull(PAININPA,-9), count(*),sum(weight) from hcmg1998 where bitAPlanFilter=1 and isnull(PAININPA,FACINPA) is not null group by isnull(PAININPA,-9),isnull(FACINPA,0)
  insert into #HCMGNorm select 1998,'32b', isnull(FACER,0), isnull(PAINER,-9), count(*),sum(weight) from hcmg1998 where bitAPlanFilter=1 and isnull(PAINER,FACER) is not null group by isnull(PAINER,-9),isnull(FACER,0)
  insert into #HCMGNorm select 1998,'32c', isnull(FACSURG,0), isnull(PAINSURG,-9), count(*),sum(weight) from hcmg1998 where bitAPlanFilter=1 and isnull(PAINSURG,FACSURG) is not null group by isnull(PAINSURG,-9),isnull(FACSURG,0)
  insert into #HCMGNorm select 1998,'32d', isnull(FACXRAY,0), isnull(PAINXRAY,-9), count(*),sum(weight) from hcmg1998 where bitAPlanFilter=1 and isnull(PAINXRAY,FACXRAY) is not null group by isnull(PAINXRAY,-9),isnull(FACXRAY,0)
  insert into #HCMGNorm select 1998,'33a', isnull(FACINPA,0), isnull(TESTINPA,-9), count(*),sum(weight) from hcmg1998 where bitAPlanFilter=1 and isnull(TESTINPA,FACINPA) is not null group by isnull(TESTINPA,-9),isnull(FACINPA,0)
  insert into #HCMGNorm select 1998,'33b', isnull(FACER,0), isnull(TESTER,-9), count(*),sum(weight) from hcmg1998 where bitAPlanFilter=1 and isnull(TESTER,FACER) is not null group by isnull(TESTER,-9),isnull(FACER,0)
  insert into #HCMGNorm select 1998,'33c', isnull(FACSURG,0), isnull(TESTSURG,-9), count(*),sum(weight) from hcmg1998 where bitAPlanFilter=1 and isnull(TESTSURG,FACSURG) is not null group by isnull(TESTSURG,-9),isnull(FACSURG,0)
  insert into #HCMGNorm select 1998,'33d', isnull(FACXRAY,0), isnull(TESTXRAY,-9), count(*),sum(weight) from hcmg1998 where bitAPlanFilter=1 and isnull(TESTXRAY,FACXRAY) is not null group by isnull(TESTXRAY,-9),isnull(FACXRAY,0)
end

if @bit99=1
begin
  if @where = ''
    update hcmg1999 set bitAPlanFilter=1
  else 
  begin
    set @SQL = 'update hcmg1999 set bitAPlanFilter= case when '+@where+' then 1 else 0 end'
    exec (@SQL)
  end

  insert into #HCMGNorm select 1999,'33a', isnull(FACINPA,0), isnull(QUALINPA,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(QUALINPA,FACINPA) is not null group by isnull(QUALINPA,-9),isnull(FACINPA,0)
  insert into #HCMGNorm select 1999,'33b', isnull(FACER,0), isnull(QUALER,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(QUALER,FACER) is not null group by isnull(QUALER,-9),isnull(FACER,0)
  insert into #HCMGNorm select 1999,'33c', isnull(FACSURG,0), isnull(QUALSURG,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(QUALSURG,FACSURG) is not null group by isnull(QUALSURG,-9),isnull(FACSURG,0)
  insert into #HCMGNorm select 1999,'33d', isnull(FACXRAY,0), isnull(QUALXRAY,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(QUALXRAY,FACXRAY) is not null group by isnull(QUALXRAY,-9),isnull(FACXRAY,0)
  insert into #HCMGNorm select 1999,'34a', isnull(FACINPA,0), isnull(QLDRINPA,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(QLDRINPA,FACINPA) is not null group by isnull(QLDRINPA,-9),isnull(FACINPA,0)
  insert into #HCMGNorm select 1999,'34b', isnull(FACER,0), isnull(QLDRER,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(QLDRER,FACER) is not null group by isnull(QLDRER,-9),isnull(FACER,0)
  insert into #HCMGNorm select 1999,'34c', isnull(FACSURG,0), isnull(QLDRSURG,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(QLDRSURG,FACSURG) is not null group by isnull(QLDRSURG,-9),isnull(FACSURG,0)
  insert into #HCMGNorm select 1999,'34d', isnull(FACXRAY,0), isnull(QLDRXRAY,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(QLDRXRAY,FACXRAY) is not null group by isnull(QLDRXRAY,-9),isnull(FACXRAY,0)
  insert into #HCMGNorm select 1999,'35a', isnull(FACINPA,0), isnull(QLRNINPA,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(QLRNINPA,FACINPA) is not null group by isnull(QLRNINPA,-9),isnull(FACINPA,0)
  insert into #HCMGNorm select 1999,'35b', isnull(FACER,0), isnull(QLRNER,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(QLRNER,FACER) is not null group by isnull(QLRNER,-9),isnull(FACER,0)
  insert into #HCMGNorm select 1999,'35c', isnull(FACSURG,0), isnull(QLRNSURG,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(QLRNSURG,FACSURG) is not null group by isnull(QLRNSURG,-9),isnull(FACSURG,0)
  insert into #HCMGNorm select 1999,'35d', isnull(FACXRAY,0), isnull(QLRNXRAY,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(QLRNXRAY,FACXRAY) is not null group by isnull(QLRNXRAY,-9),isnull(FACXRAY,0)
  insert into #HCMGNorm select 1999,'36a', isnull(FACINPA,0), isnull(PERINPA,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(PERINPA,FACINPA) is not null group by isnull(PERINPA,-9),isnull(FACINPA,0)
  insert into #HCMGNorm select 1999,'36b', isnull(FACER,0), isnull(PERER,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(PERER,FACER) is not null group by isnull(PERER,-9),isnull(FACER,0)
  insert into #HCMGNorm select 1999,'36c', isnull(FACER,0), isnull(PERSURG,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(PERSURG,FACER) is not null group by isnull(PERSURG,-9),isnull(FACER,0)
  insert into #HCMGNorm select 1999,'36d', isnull(FACER,0), isnull(PERXRAY,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(PERXRAY,FACER) is not null group by isnull(PERXRAY,-9),isnull(FACER,0)
  insert into #HCMGNorm select 1999,'37a', isnull(FACINPA,0), isnull(CAREINPA,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(CAREINPA,FACINPA) is not null group by isnull(CAREINPA,-9),isnull(FACINPA,0)
  insert into #HCMGNorm select 1999,'37b', isnull(FACER,0), isnull(CAREER,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(CAREER,FACER) is not null group by isnull(CAREER,-9),isnull(FACER,0)
  insert into #HCMGNorm select 1999,'37c', isnull(FACSURG,0), isnull(CARESURG,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(CARESURG,FACSURG) is not null group by isnull(CARESURG,-9),isnull(FACSURG,0)
  insert into #HCMGNorm select 1999,'37d', isnull(FACXRAY,0), isnull(CAREXRAY,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(CAREXRAY,FACXRAY) is not null group by isnull(CAREXRAY,-9),isnull(FACXRAY,0)
  insert into #HCMGNorm select 1999,'38a', isnull(FACINPA,0), isnull(TRUINPA,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(TRUINPA,FACINPA) is not null group by isnull(TRUINPA,-9),isnull(FACINPA,0)
  insert into #HCMGNorm select 1999,'38b', isnull(FACER,0), isnull(TRUER,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(TRUER,FACER) is not null group by isnull(TRUER,-9),isnull(FACER,0)
  insert into #HCMGNorm select 1999,'38c', isnull(FACSURG,0), isnull(TRUSURG,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(TRUSURG,FACSURG) is not null group by isnull(TRUSURG,-9),isnull(FACSURG,0)
  insert into #HCMGNorm select 1999,'38d', isnull(FACXRAY,0), isnull(TRUXRAY,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(TRUXRAY,FACXRAY) is not null group by isnull(TRUXRAY,-9),isnull(FACXRAY,0)
  insert into #HCMGNorm select 1999,'39a', isnull(FACINPA,0), isnull(WILINPA,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(WILINPA,FACINPA) is not null group by isnull(WILINPA,-9),isnull(FACINPA,0)
  insert into #HCMGNorm select 1999,'39b', isnull(FACER,0), isnull(WILER,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(WILER,FACER) is not null group by isnull(WILER,-9),isnull(FACER,0)
  insert into #HCMGNorm select 1999,'39c', isnull(FACSURG,0), isnull(WILSURG,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(WILSURG,FACSURG) is not null group by isnull(WILSURG,-9),isnull(FACSURG,0)
  insert into #HCMGNorm select 1999,'39d', isnull(FACXRAY,0), isnull(WILXRAY,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(WILXRAY,FACXRAY) is not null group by isnull(WILXRAY,-9),isnull(FACXRAY,0)
  insert into #HCMGNorm select 1999,'40a', isnull(FACINPA,0), isnull(EXPINPA,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(EXPINPA,FACINPA) is not null group by isnull(EXPINPA,-9),isnull(FACINPA,0)
  insert into #HCMGNorm select 1999,'40b', isnull(FACER,0), isnull(EXPER,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(EXPER,FACER) is not null group by isnull(EXPER,-9),isnull(FACER,0)
  insert into #HCMGNorm select 1999,'40c', isnull(FACSURG,0), isnull(EXPSURG,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(EXPSURG,FACSURG) is not null group by isnull(EXPSURG,-9),isnull(FACSURG,0)
  insert into #HCMGNorm select 1999,'40d', isnull(FACXRAY,0), isnull(EXPXRAY,-9), count(*),sum(weight) from hcmg1999 where bitAPlanFilter=1 and isnull(EXPXRAY,FACXRAY) is not null group by isnull(EXPXRAY,-9),isnull(FACXRAY,0)
end

if @bit00=1
begin
  if @where = ''
    update nrc14.hcmg.dbo.hcmg2000data set bitAPlanFilter=1
  else 
  begin
    set @SQL = 'update nrc14.hcmg.dbo.hcmg2000data set bitAPlanFilter= case when '+@where+' then 1 else 0 end'
    exec (@SQL)
  end

  insert into #HCMGNorm select 2000,'32a', isnull(Q0005449,0), isnull(Q0000336,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0000336,Q0005449) is not null group by isnull(Q0000336,-9),isnull(Q0005449,0)
  insert into #HCMGNorm select 2000,'32b', isnull(Q0005450,0), isnull(Q0000090,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0000090,Q0005450) is not null group by isnull(Q0000090,-9),isnull(Q0005450,0)
  insert into #HCMGNorm select 2000,'32c', isnull(Q0005451,0), isnull(Q0005588,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005588,Q0005451) is not null group by isnull(Q0005588,-9),isnull(Q0005451,0)
  insert into #HCMGNorm select 2000,'32d', isnull(Q0005452,0), isnull(Q0004462,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0004462,Q0005452) is not null group by isnull(Q0004462,-9),isnull(Q0005452,0)
  insert into #HCMGNorm select 2000,'32e', isnull(Q0005453,0), isnull(Q0005589,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005589,Q0005453) is not null group by isnull(Q0005589,-9),isnull(Q0005453,0)
  insert into #HCMGNorm select 2000,'32f', isnull(Q0005454,0), isnull(Q0001616,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0001616,Q0005454) is not null group by isnull(Q0001616,-9),isnull(Q0005454,0)
  insert into #HCMGNorm select 2000,'32g', isnull(Q0005455,0), isnull(Q0005590,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005590,Q0005455) is not null group by isnull(Q0005590,-9),isnull(Q0005455,0)
  insert into #HCMGNorm select 2000,'32h', isnull(Q0005456,0), isnull(Q0005591,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005591,Q0005456) is not null group by isnull(Q0005591,-9),isnull(Q0005456,0)
  insert into #HCMGNorm select 2000,'32i', isnull(Q0005457,0), isnull(Q0005592,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005592,Q0005457) is not null group by isnull(Q0005592,-9),isnull(Q0005457,0)
  insert into #HCMGNorm select 2000,'32j', isnull(Q0005458,0), isnull(Q0005593,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005593,Q0005458) is not null group by isnull(Q0005593,-9),isnull(Q0005458,0)
  insert into #HCMGNorm select 2000,'33a', isnull(Q0005449,0), isnull(Q0000903,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0000903,Q0005449) is not null group by isnull(Q0000903,-9),isnull(Q0005449,0)
  insert into #HCMGNorm select 2000,'33b', isnull(Q0005450,0), isnull(Q0000099,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0000099,Q0005450) is not null group by isnull(Q0000099,-9),isnull(Q0005450,0)
  insert into #HCMGNorm select 2000,'33c', isnull(Q0005451,0), isnull(Q0003608,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0003608,Q0005451) is not null group by isnull(Q0003608,-9),isnull(Q0005451,0)
  insert into #HCMGNorm select 2000,'33d', isnull(Q0005452,0), isnull(Q0003924,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0003924,Q0005452) is not null group by isnull(Q0003924,-9),isnull(Q0005452,0)
  insert into #HCMGNorm select 2000,'33e', isnull(Q0005453,0), isnull(Q0005596,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005596,Q0005453) is not null group by isnull(Q0005596,-9),isnull(Q0005453,0)
  insert into #HCMGNorm select 2000,'33f', isnull(Q0005454,0), isnull(Q0005597,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005597,Q0005454) is not null group by isnull(Q0005597,-9),isnull(Q0005454,0)
  insert into #HCMGNorm select 2000,'33g', isnull(Q0005455,0), isnull(Q0005598,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005598,Q0005455) is not null group by isnull(Q0005598,-9),isnull(Q0005455,0)
  insert into #HCMGNorm select 2000,'33h', isnull(Q0005456,0), isnull(Q0005599,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005599,Q0005456) is not null group by isnull(Q0005599,-9),isnull(Q0005456,0)
  insert into #HCMGNorm select 2000,'33i', isnull(Q0005457,0), isnull(Q0005600,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005600,Q0005457) is not null group by isnull(Q0005600,-9),isnull(Q0005457,0)
  insert into #HCMGNorm select 2000,'33j', isnull(Q0005458,0), isnull(Q0005601,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005601,Q0005458) is not null group by isnull(Q0005601,-9),isnull(Q0005458,0)
  insert into #HCMGNorm select 2000,'34a', isnull(Q0005449,0), isnull(Q0000439,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0000439,Q0005449) is not null group by isnull(Q0000439,-9),isnull(Q0005449,0)
  insert into #HCMGNorm select 2000,'34b', isnull(Q0005450,0), isnull(Q0000105,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0000105,Q0005450) is not null group by isnull(Q0000105,-9),isnull(Q0005450,0)
  insert into #HCMGNorm select 2000,'34c', isnull(Q0005451,0), isnull(Q0001482,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0001482,Q0005451) is not null group by isnull(Q0001482,-9),isnull(Q0005451,0)
  insert into #HCMGNorm select 2000,'34d', isnull(Q0005452,0), isnull(Q0003933,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0003933,Q0005452) is not null group by isnull(Q0003933,-9),isnull(Q0005452,0)
  insert into #HCMGNorm select 2000,'34e', isnull(Q0005453,0), isnull(Q0005603,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005603,Q0005453) is not null group by isnull(Q0005603,-9),isnull(Q0005453,0)
  insert into #HCMGNorm select 2000,'34f', isnull(Q0005454,0), isnull(Q0005604,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005604,Q0005454) is not null group by isnull(Q0005604,-9),isnull(Q0005454,0)
  insert into #HCMGNorm select 2000,'34g', isnull(Q0005455,0), isnull(Q0005605,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005605,Q0005455) is not null group by isnull(Q0005605,-9),isnull(Q0005455,0)
  insert into #HCMGNorm select 2000,'34h', isnull(Q0005456,0), isnull(Q0005606,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005606,Q0005456) is not null group by isnull(Q0005606,-9),isnull(Q0005456,0)
  insert into #HCMGNorm select 2000,'34i', isnull(Q0005457,0), isnull(Q0004115,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0004115,Q0005457) is not null group by isnull(Q0004115,-9),isnull(Q0005457,0)
  insert into #HCMGNorm select 2000,'34j', isnull(Q0005458,0), isnull(Q0005607,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005607,Q0005458) is not null group by isnull(Q0005607,-9),isnull(Q0005458,0)
  insert into #HCMGNorm select 2000,'35a', isnull(Q0005449,0), isnull(Q0000310,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0000310,Q0005449) is not null group by isnull(Q0000310,-9),isnull(Q0005449,0)
  insert into #HCMGNorm select 2000,'35b', isnull(Q0005450,0), isnull(Q0000086,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0000086,Q0005450) is not null group by isnull(Q0000086,-9),isnull(Q0005450,0)
  insert into #HCMGNorm select 2000,'35c', isnull(Q0005451,0), isnull(Q0005608,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005608,Q0005451) is not null group by isnull(Q0005608,-9),isnull(Q0005451,0)
  insert into #HCMGNorm select 2000,'35d', isnull(Q0005452,0), isnull(Q0005609,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005609,Q0005452) is not null group by isnull(Q0005609,-9),isnull(Q0005452,0)
  insert into #HCMGNorm select 2000,'35e', isnull(Q0005453,0), isnull(Q0005610,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005610,Q0005453) is not null group by isnull(Q0005610,-9),isnull(Q0005453,0)
  insert into #HCMGNorm select 2000,'35f', isnull(Q0005454,0), isnull(Q0005611,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005611,Q0005454) is not null group by isnull(Q0005611,-9),isnull(Q0005454,0)
  insert into #HCMGNorm select 2000,'35g', isnull(Q0005455,0), isnull(Q0005612,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005612,Q0005455) is not null group by isnull(Q0005612,-9),isnull(Q0005455,0)
  insert into #HCMGNorm select 2000,'35h', isnull(Q0005456,0), isnull(Q0005613,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005613,Q0005456) is not null group by isnull(Q0005613,-9),isnull(Q0005456,0)
  insert into #HCMGNorm select 2000,'35i', isnull(Q0005457,0), isnull(Q0003845,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0003845,Q0005457) is not null group by isnull(Q0003845,-9),isnull(Q0005457,0)
  insert into #HCMGNorm select 2000,'35j', isnull(Q0005458,0), isnull(Q0005615,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005615,Q0005458) is not null group by isnull(Q0005615,-9),isnull(Q0005458,0)
  insert into #HCMGNorm select 2000,'36a', isnull(Q0005449,0), isnull(Q0002194,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0002194,Q0005449) is not null group by isnull(Q0002194,-9),isnull(Q0005449,0)
  insert into #HCMGNorm select 2000,'36b', isnull(Q0005450,0), isnull(Q0005616,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005616,Q0005450) is not null group by isnull(Q0005616,-9),isnull(Q0005450,0)
  insert into #HCMGNorm select 2000,'36c', isnull(Q0005451,0), isnull(Q0005617,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005617,Q0005451) is not null group by isnull(Q0005617,-9),isnull(Q0005451,0)
  insert into #HCMGNorm select 2000,'36d', isnull(Q0005452,0), isnull(Q0005618,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005618,Q0005452) is not null group by isnull(Q0005618,-9),isnull(Q0005452,0)
  insert into #HCMGNorm select 2000,'36e', isnull(Q0005453,0), isnull(Q0005619,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005619,Q0005453) is not null group by isnull(Q0005619,-9),isnull(Q0005453,0)
  insert into #HCMGNorm select 2000,'36f', isnull(Q0005454,0), isnull(Q0005620,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005620,Q0005454) is not null group by isnull(Q0005620,-9),isnull(Q0005454,0)
  insert into #HCMGNorm select 2000,'36g', isnull(Q0005455,0), isnull(Q0005621,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005621,Q0005455) is not null group by isnull(Q0005621,-9),isnull(Q0005455,0)
  insert into #HCMGNorm select 2000,'36h', isnull(Q0005456,0), isnull(Q0005622,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005622,Q0005456) is not null group by isnull(Q0005622,-9),isnull(Q0005456,0)
  insert into #HCMGNorm select 2000,'36i', isnull(Q0005457,0), isnull(Q0005623,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005623,Q0005457) is not null group by isnull(Q0005623,-9),isnull(Q0005457,0)
  insert into #HCMGNorm select 2000,'36j', isnull(Q0005458,0), isnull(Q0005624,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005624,Q0005458) is not null group by isnull(Q0005624,-9),isnull(Q0005458,0)
  insert into #HCMGNorm select 2000,'37a', isnull(Q0005449,0), isnull(Q0000299,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0000299,Q0005449) is not null group by isnull(Q0000299,-9),isnull(Q0005449,0)
  insert into #HCMGNorm select 2000,'37b', isnull(Q0005450,0), isnull(Q0000076,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0000076,Q0005450) is not null group by isnull(Q0000076,-9),isnull(Q0005450,0)
  insert into #HCMGNorm select 2000,'37c', isnull(Q0005451,0), isnull(Q0005625,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005625,Q0005451) is not null group by isnull(Q0005625,-9),isnull(Q0005451,0)
  insert into #HCMGNorm select 2000,'37d', isnull(Q0005452,0), isnull(Q0005626,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005626,Q0005452) is not null group by isnull(Q0005626,-9),isnull(Q0005452,0)
  insert into #HCMGNorm select 2000,'37e', isnull(Q0005453,0), isnull(Q0005627,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005627,Q0005453) is not null group by isnull(Q0005627,-9),isnull(Q0005453,0)
  insert into #HCMGNorm select 2000,'37f', isnull(Q0005454,0), isnull(Q0005628,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005628,Q0005454) is not null group by isnull(Q0005628,-9),isnull(Q0005454,0)
  insert into #HCMGNorm select 2000,'37g', isnull(Q0005455,0), isnull(Q0005629,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005629,Q0005455) is not null group by isnull(Q0005629,-9),isnull(Q0005455,0)
  insert into #HCMGNorm select 2000,'37h', isnull(Q0005456,0), isnull(Q0005630,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005630,Q0005456) is not null group by isnull(Q0005630,-9),isnull(Q0005456,0)
  insert into #HCMGNorm select 2000,'37i', isnull(Q0005457,0), isnull(Q0004110,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0004110,Q0005457) is not null group by isnull(Q0004110,-9),isnull(Q0005457,0)
  insert into #HCMGNorm select 2000,'37j', isnull(Q0005458,0), isnull(Q0004477,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0004477,Q0005458) is not null group by isnull(Q0004477,-9),isnull(Q0005458,0)
  insert into #HCMGNorm select 2000,'38a', isnull(Q0005449,0), isnull(Q0000248,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0000248,Q0005449) is not null group by isnull(Q0000248,-9),isnull(Q0005449,0)
  insert into #HCMGNorm select 2000,'38b', isnull(Q0005450,0), isnull(Q0000047,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0000047,Q0005450) is not null group by isnull(Q0000047,-9),isnull(Q0005450,0)
  insert into #HCMGNorm select 2000,'38c', isnull(Q0005451,0), isnull(Q0005631,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005631,Q0005451) is not null group by isnull(Q0005631,-9),isnull(Q0005451,0)
  insert into #HCMGNorm select 2000,'38d', isnull(Q0005452,0), isnull(Q0005632,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005632,Q0005452) is not null group by isnull(Q0005632,-9),isnull(Q0005452,0)
  insert into #HCMGNorm select 2000,'38e', isnull(Q0005453,0), isnull(Q0005633,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005633,Q0005453) is not null group by isnull(Q0005633,-9),isnull(Q0005453,0)
  insert into #HCMGNorm select 2000,'38f', isnull(Q0005454,0), isnull(Q0005634,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005634,Q0005454) is not null group by isnull(Q0005634,-9),isnull(Q0005454,0)
  insert into #HCMGNorm select 2000,'38g', isnull(Q0005455,0), isnull(Q0005635,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005635,Q0005455) is not null group by isnull(Q0005635,-9),isnull(Q0005455,0)
  insert into #HCMGNorm select 2000,'38h', isnull(Q0005456,0), isnull(Q0005636,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005636,Q0005456) is not null group by isnull(Q0005636,-9),isnull(Q0005456,0)
  insert into #HCMGNorm select 2000,'38i', isnull(Q0005457,0), isnull(Q0005637,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005637,Q0005457) is not null group by isnull(Q0005637,-9),isnull(Q0005457,0)
  insert into #HCMGNorm select 2000,'38j', isnull(Q0005458,0), isnull(Q0005638,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005638,Q0005458) is not null group by isnull(Q0005638,-9),isnull(Q0005458,0)
  insert into #HCMGNorm select 2000,'39a', isnull(Q0005449,0), isnull(Q0000227,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0000227,Q0005449) is not null group by isnull(Q0000227,-9),isnull(Q0005449,0)
  insert into #HCMGNorm select 2000,'39b', isnull(Q0005450,0), isnull(Q0000043,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0000043,Q0005450) is not null group by isnull(Q0000043,-9),isnull(Q0005450,0)
  insert into #HCMGNorm select 2000,'39c', isnull(Q0005451,0), isnull(Q0005639,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005639,Q0005451) is not null group by isnull(Q0005639,-9),isnull(Q0005451,0)
  insert into #HCMGNorm select 2000,'39d', isnull(Q0005452,0), isnull(Q0005640,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005640,Q0005452) is not null group by isnull(Q0005640,-9),isnull(Q0005452,0)
  insert into #HCMGNorm select 2000,'39e', isnull(Q0005453,0), isnull(Q0005641,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005641,Q0005453) is not null group by isnull(Q0005641,-9),isnull(Q0005453,0)
  insert into #HCMGNorm select 2000,'39f', isnull(Q0005454,0), isnull(Q0005642,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005642,Q0005454) is not null group by isnull(Q0005642,-9),isnull(Q0005454,0)
  insert into #HCMGNorm select 2000,'39g', isnull(Q0005455,0), isnull(Q0005643,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005643,Q0005455) is not null group by isnull(Q0005643,-9),isnull(Q0005455,0)
  insert into #HCMGNorm select 2000,'39h', isnull(Q0005456,0), isnull(Q0005644,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005644,Q0005456) is not null group by isnull(Q0005644,-9),isnull(Q0005456,0)
  insert into #HCMGNorm select 2000,'39i', isnull(Q0005457,0), isnull(Q0005645,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005645,Q0005457) is not null group by isnull(Q0005645,-9),isnull(Q0005457,0)
  insert into #HCMGNorm select 2000,'39j', isnull(Q0005458,0), isnull(Q0005646,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005646,Q0005458) is not null group by isnull(Q0005646,-9),isnull(Q0005458,0)
  insert into #HCMGNorm select 2000,'40a', isnull(Q0005449,0), isnull(Q0000237,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0000237,Q0005449) is not null group by isnull(Q0000237,-9),isnull(Q0005449,0)
  insert into #HCMGNorm select 2000,'40b', isnull(Q0005450,0), isnull(Q0000059,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0000059,Q0005450) is not null group by isnull(Q0000059,-9),isnull(Q0005450,0)
  insert into #HCMGNorm select 2000,'40c', isnull(Q0005451,0), isnull(Q0005647,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005647,Q0005451) is not null group by isnull(Q0005647,-9),isnull(Q0005451,0)
  insert into #HCMGNorm select 2000,'40d', isnull(Q0005452,0), isnull(Q0005648,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005648,Q0005452) is not null group by isnull(Q0005648,-9),isnull(Q0005452,0)
  insert into #HCMGNorm select 2000,'40e', isnull(Q0005453,0), isnull(Q0005649,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005649,Q0005453) is not null group by isnull(Q0005649,-9),isnull(Q0005453,0)
  insert into #HCMGNorm select 2000,'40f', isnull(Q0005454,0), isnull(Q0005650,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005650,Q0005454) is not null group by isnull(Q0005650,-9),isnull(Q0005454,0)
  insert into #HCMGNorm select 2000,'40g', isnull(Q0005455,0), isnull(Q0005651,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005651,Q0005455) is not null group by isnull(Q0005651,-9),isnull(Q0005455,0)
  insert into #HCMGNorm select 2000,'40h', isnull(Q0005456,0), isnull(Q0005652,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005652,Q0005456) is not null group by isnull(Q0005652,-9),isnull(Q0005456,0)
  insert into #HCMGNorm select 2000,'40i', isnull(Q0005457,0), isnull(Q0005653,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005653,Q0005457) is not null group by isnull(Q0005653,-9),isnull(Q0005457,0)
  insert into #HCMGNorm select 2000,'40j', isnull(Q0005458,0), isnull(Q0005654,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005654,Q0005458) is not null group by isnull(Q0005654,-9),isnull(Q0005458,0)
  insert into #HCMGNorm select 2000,'41a', isnull(Q0005449,0), isnull(Q0000228,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0000228,Q0005449) is not null group by isnull(Q0000228,-9),isnull(Q0005449,0)
  insert into #HCMGNorm select 2000,'41b', isnull(Q0005450,0), isnull(Q0000051,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0000051,Q0005450) is not null group by isnull(Q0000051,-9),isnull(Q0005450,0)
  insert into #HCMGNorm select 2000,'41c', isnull(Q0005451,0), isnull(Q0005655,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005655,Q0005451) is not null group by isnull(Q0005655,-9),isnull(Q0005451,0)
  insert into #HCMGNorm select 2000,'41d', isnull(Q0005452,0), isnull(Q0005656,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005656,Q0005452) is not null group by isnull(Q0005656,-9),isnull(Q0005452,0)
  insert into #HCMGNorm select 2000,'41e', isnull(Q0005453,0), isnull(Q0005657,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005657,Q0005453) is not null group by isnull(Q0005657,-9),isnull(Q0005453,0)
  insert into #HCMGNorm select 2000,'41f', isnull(Q0005454,0), isnull(Q0005658,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005658,Q0005454) is not null group by isnull(Q0005658,-9),isnull(Q0005454,0)
  insert into #HCMGNorm select 2000,'41g', isnull(Q0005455,0), isnull(Q0005659,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005659,Q0005455) is not null group by isnull(Q0005659,-9),isnull(Q0005455,0)
  insert into #HCMGNorm select 2000,'41h', isnull(Q0005456,0), isnull(Q0005660,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005660,Q0005456) is not null group by isnull(Q0005660,-9),isnull(Q0005456,0)
  insert into #HCMGNorm select 2000,'41i', isnull(Q0005457,0), isnull(Q0005661,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005661,Q0005457) is not null group by isnull(Q0005661,-9),isnull(Q0005457,0)
  insert into #HCMGNorm select 2000,'41j', isnull(Q0005458,0), isnull(Q0005662,-9), count(*),sum(weight) from nrc14.hcmg.dbo.hcmg2000data where bitAPlanFilter=1 and isnull(Q0005662,Q0005458) is not null group by isnull(Q0005662,-9),isnull(Q0005458,0)
end

if @bit98=1 or @bit99=1 
begin
  update #HCMGNorm set response=-9 where response=0 and hcmgyear in (1998,1999)
  update #HCMGNorm set response=0 where response=1 and hcmgyear in (1998,1999)
  update #HCMGNorm set response=35 where response=2 and hcmgyear in (1998,1999)
  update #HCMGNorm set response=60 where response=3 and hcmgyear in (1998,1999)
  update #HCMGNorm set response=85 where response=4 and hcmgyear in (1998,1999)
  update #HCMGNorm set response=100 where response=5 and hcmgyear in (1998,1999)
end

set @sql = 'create table '+@table_nm+' (HCMGYear int, HCMGQNmbr char(3), hospital_id int, response int, UWNSize int, WNSize float)'
exec (@SQL)

set @SQL = 'insert into '+@table_nm+' select * from #HCMGNorm'
exec (@SQL)

drop table #HCMGNorm


