create procedure sp_Norms_AllNorms_SPSS 
@NRCNormTable varchar(40), 
@SPSSTable varchar(40)
as

declare @SQL varchar(2000)

set @SQL = 'create table ' + @SPSSTable +char(10)+
'(qstncore int, NU int, NW float, SM float, SS float, Missing float, NotApplic float,' +char(10)+
'v000 float, v001 float, v002 float, v003 float, v004 float, v005 float, v006 float, v007 float,' +char(10)+
'v008 float, v009 float, v010 float, v011 float, v012 float, v017 float, v020 float, v025 float,' +char(10)+
'v030 float, v033 float, v034 float, v035 float, v040 float, v050 float, v060 float, v067 float,' +char(10)+
'v070 float, v075 float, v080 float, v083 float, v085 float, v086 float, v090 float, v099 float,' +char(10)+
'v100 float)'
exec(@SQL)

set @SQL = 'insert into ' + @SPSSTable + ' (qstncore, nu, nw, sm)' +char(10)+
'select qstncore,sum(UWNSize),sum(UWNSize),sum(UWNsize*intResponseVal)'+char(10)+
'from ' + @NRCNormTable +char(10)+
'where qstncore <> 7666' +char(10)+
'group by qstncore'
exec(@SQL)

create table #user (qstncore int, intresponseval int, ns int)

set @SQL = 'insert into #user (qstncore, intresponseval, ns)' +char(10)+
'select qstncore, intresponseval, sum(UWNSize)' +char(10)+
'from ' + @NRCNormTable +char(10)+
'group by qstncore, intresponseval'
exec(@SQL)

set @SQL = 'update N set Missing=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=-9'
exec(@SQL)
set @SQL = 'update N set NotApplic=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=-1'
exec(@SQL)
set @SQL = 'update N set v000=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=0'
exec(@SQL)
set @SQL = 'update N set v001=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=1'
exec(@SQL)
set @SQL = 'update N set v002=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=2'
exec(@SQL)
set @SQL = 'update N set v003=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=3'
exec(@SQL)
set @SQL = 'update N set v004=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=4'
exec(@SQL)
set @SQL = 'update N set v005=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=5'
exec(@SQL)
set @SQL = 'update N set v006=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=6'
exec(@SQL)
set @SQL = 'update N set v007=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=7'
exec(@SQL)
set @SQL = 'update N set v008=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=8'
exec(@SQL)
set @SQL = 'update N set v009=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=9'
exec(@SQL)
set @SQL = 'update N set v010=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=10'
exec(@SQL)
set @SQL = 'update N set v011=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=11'
exec(@SQL)
set @SQL = 'update N set v012=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=12'
exec(@SQL)
set @SQL = 'update N set v017=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=17'
exec(@SQL)
set @SQL = 'update N set v020=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=20'
exec(@SQL)
set @SQL = 'update N set v025=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=25'
exec(@SQL)
set @SQL = 'update N set v030=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=30'
exec(@SQL)
set @SQL = 'update N set v033=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=33'
exec(@SQL)
set @SQL = 'update N set v034=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=34'
exec(@SQL)
set @SQL = 'update N set v035=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=35'
exec(@SQL)
set @SQL = 'update N set v040=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=40'
exec(@SQL)
set @SQL = 'update N set v050=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=50'
exec(@SQL)
set @SQL = 'update N set v060=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=60'
exec(@SQL)
set @SQL = 'update N set v067=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=67'
exec(@SQL)
set @SQL = 'update N set v070=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=70'
exec(@SQL)
set @SQL = 'update N set v075=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=75'
exec(@SQL)
set @SQL = 'update N set v080=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=80'
exec(@SQL)
set @SQL = 'update N set v083=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=83'
exec(@SQL)
set @SQL = 'update N set v085=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=85'
exec(@SQL)
set @SQL = 'update N set v086=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=86'
exec(@SQL)
set @SQL = 'update N set v090=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=90'
exec(@SQL)
set @SQL = 'update N set v099=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=99'
exec(@SQL)
set @SQL = 'update N set v100=ns from ' + @SPSSTable + ' n, #User T where N.qstncore=t.qstncore and t.intresponseval=100'
exec(@SQL)

drop table #user


