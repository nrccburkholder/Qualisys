--sp_helptext NQLValidationTest_skd_ch_Pedsv2      
      
CREATE proc NQLValidationTest_skd_ch_Pedsv2              
as                  
set nocount on    
declare @excelfilename varchar(20)  
set @excelfilename = (select RIGHT(excelfilename,18) from NQLValidation_Filename where excelfilename not like '%Anchor%')            
print'======================================================'                
print'The following information is current as of ' + CONVERT(VARCHAR(10), GETDATE(), 101) + ' for ' + @excelfilename  
print'======================================================'                
if exists(select COUNT(distinct LITHO) as TotalCount from nqlvalcheck_SFH_Ch_Pedsv2 nql inner join SENTMAILING sm on nql.LITHO = sm.STRLITHOCODE)                
begin                
select COUNT(distinct LITHO) as TotalCount from nqlvalcheck_SFH_Ch_Pedsv2 nql inner join SENTMAILING sm on nql.LITHO = sm.STRLITHOCODE                 
end                
else print 'No rows available'                
        
print '              
The CSV Lithos which have Maildate as NULL'                
print'======================================================'                
if exists(select LITHO from nqlvalcheck_SFH_Ch_Pedsv2 nql inner join SENTMAILING sm on nql.LITHO = sm.STRLITHOCODE                
where sm.DATMAILED is NULL)                
begin                
print 'All the below Lithos do not have Mail Date set'                
select distinct LITHO,sm.DATMAILED from nqlvalcheck_SFH_Ch_Pedsv2 nql inner join SENTMAILING sm on nql.LITHO = sm.STRLITHOCODE                
where sm.DATMAILED is NULL                
end else                 
print 'All the Lithos have Mail dates set '              
print'======================================================                
'            
print '                    
List of CSV Lithos which have expired                
'                
print'======================================================'                
if exists(select LITHO from nqlvalcheck_SFH_Ch_Pedsv2 nql inner join SENTMAILING sm on nql.LITHO = sm.STRLITHOCODE                
where datExpire <= GETDATE())                 
begin                 
select LITHO, CONVERT(VARCHAR(10), GETDATE(), 101) as [Date of Exp] from nqlvalcheck_SFH_Ch_Pedsv2 nql inner join SENTMAILING sm on nql.LITHO = sm.STRLITHOCODE                
where datExpire <= GETDATE()                
end else                 
Print 'There are no CSV lithos which are expired.'                
print'======================================================'                
        
if exists(                
select distinct LITHO from nqlvalcheck_SFH_Ch_Pedsv2 nql inner join SENTMAILING sm on nql.LITHO = sm.STRLITHOCODE                
inner join QUESTIONFORM qf on sm.SENTMAIL_ID = qf.SENTMAIL_ID                 
inner join QUESTIONRESULT qr on qf.QUESTIONFORM_ID = qr.QUESTIONRESULT_ID                
where nql.LITHO = sm.STRLITHOCODE and sm.SENTMAIL_ID = qf.SENTMAIL_ID and qf.datResultsImported is NULL)                
begin                
print'CSV Lithos which have not been imported yet'                
print'======================================================                
'                
select distinct LITHO, qf.datResultsImported as DateImported from nqlvalcheck_SFH_Ch_Pedsv2 nql inner join SENTMAILING sm on nql.LITHO = sm.STRLITHOCODE                
inner join QUESTIONFORM qf on sm.SENTMAIL_ID = qf.SENTMAIL_ID                 
inner join QUESTIONRESULT qr on qf.QUESTIONFORM_ID = qr.QUESTIONRESULT_ID                
where nql.LITHO = sm.STRLITHOCODE and sm.SENTMAIL_ID = qf.SENTMAIL_ID and qf.datResultsImported is NULL                
end else                
Print 'All of the CSV Lithos have been Imported successfully'                
print'======================================================'           
               
print '                        
List of number of Invalid responses'                
print'======================================================'               
            
--=========PART 1===============            
set nocount on            
begin try drop table #temp_1 end try            
begin catch print '' end catch            
            
begin try drop table #temp_2 end try            
begin catch print '' end catch            
            
select distinct sm.STRLITHOCODE, qr.QSTNCORE,qr.INTRESPONSEVAL into #temp_1 from nqlvalcheck_SFH_Ch_Pedsv2 nql inner join SENTMAILING sm on nql.LITHO = sm.STRLITHOCODE            
inner join QUESTIONFORM qf on sm.SENTMAIL_ID = qf.SENTMAIL_ID             
inner join QUESTIONRESULT qr on qf.QUESTIONFORM_ID = qr.QUESTIONFORM_ID             
--select * from #temp_1            
            
select right(LTRIM(rtrim(column_name)),LEN(COLUMN_NAME)-1) as QstnCore into #temp_2 from INFORMATION_SCHEMA.COLUMNS            
where TABLE_NAME = 'nqlvalcheck_SFH_Ch_Pedsv2' and COLUMN_NAME like 'Q%'             
            
truncate table tmp_skd_loop_qstncore            
            
--created table called "tmp_skd_loop_qstncore"            
--select * from tmp_skd_loop_qstncore            
declare @qc varchar(6)            
declare @counter int            
set @counter = (select COUNT(*) from #temp_2)            
truncate table tmp_skd_loop_qstncore            
while(@counter>0)            
begin            
set @qc = (select top 1 qstncore from #temp_2 order by qstncore)            
exec('insert into tmp_skd_loop_qstncore select Litho, Q' + @qc + ','+''''+@qc+''''+' as Question from nqlvalcheck_SFH_Ch_Pedsv2')            
            
--print('select Litho, Q' + @qc + ','+''''+@qc+''''+' as Question from nqlvalcheck_SFH_Ch_Pedsv2')            
delete from #temp_2 where qstncore = (select top 1 qstncore from #temp_2 order by qstncore)            
--print @counter; print @qc            
set @counter = @counter - 1            
end            
--===================END OF PART 1 ==============================            
--===========================PART 2==============================            
set nocount on            
declare @litho_m varchar(10)            
declare @qstncore_m int            
declare @counter_m int            
            
begin try drop table #temp_m end try            
begin catch print '' end catch            
            
truncate table tmp_skd_loop_qstncore_m            
select strlithocode,qstncore into #temp_m from #temp_1 group by strlithocode,qstncore having COUNT(qstncore) > 1 order by strlithocode,qstncore            
            
set @counter_m = (select COUNT(*) from #temp_m)            
while (@counter_m > 0)            
begin             
            
set @litho_m = (select top 1 strlithocode from #temp_m)            
set @qstncore_m = (select top 1 qstncore from #temp_m)            
exec( 'insert into tmp_skd_loop_qstncore_m select distinct sm.STRLITHOCODE, qr.QSTNCORE, qr.INTRESPONSEVAL, ' +             
' case when INTRESPONSEVAL = 1 then cast(qr.QSTNCORE as varchar)+'+''''+'A'+'''' +             
  ' when INTRESPONSEVAL = 2 then cast(qr.QSTNCORE as varchar)+'+''''+'B'+'''' +             
  ' when INTRESPONSEVAL = 3 then cast(qr.QSTNCORE as varchar)+'+''''+'C'+'''' +             
  ' when INTRESPONSEVAL = 4 then cast(qr.QSTNCORE as varchar)+'+''''+'D'+'''' +             
  ' when INTRESPONSEVAL = 5 then cast(qr.QSTNCORE as varchar)+'+''''+'E'+'''' +             
  ' when INTRESPONSEVAL = 6 then cast(qr.QSTNCORE as varchar)+'+''''+'F'+'''' +             
  ' when INTRESPONSEVAL = 7 then cast(qr.QSTNCORE as varchar)+'+''''+'G'+'''' +             
  ' when INTRESPONSEVAL = 8 then cast(qr.QSTNCORE as varchar)+'+''''+'H'+'''' +             
  ' when INTRESPONSEVAL = 9 then cast(qr.QSTNCORE as varchar)+'+''''+'I'+'''' +             
  ' when INTRESPONSEVAL = 10 then cast(qr.QSTNCORE as varchar)+'+''''+'J'+'''' +             
  ' when INTRESPONSEVAL = 11 then cast(qr.QSTNCORE as varchar)+'+''''+'K'+'''' +             
  ' when INTRESPONSEVAL = 12 then cast(qr.QSTNCORE as varchar)+'+''''+'L'+'''' +             
  ' end as Question from nqlvalcheck_SFH_Ch_Pedsv2 nql inner join SENTMAILING sm on nql.LITHO = sm.STRLITHOCODE            
inner join QUESTIONFORM qf on sm.SENTMAIL_ID = qf.SENTMAIL_ID             
inner join QUESTIONRESULT qr on qf.QUESTIONFORM_ID = qr.QUESTIONFORM_ID             
where STRLITHOCODE = ' + @litho_m + 'and QSTNCORE = ' + @qstncore_m)            
            
--PRINT @litho_m             
--PRINT @qstncore_m            
delete from #temp_m where strlithocode = @litho_m and qstncore = @qstncore_m             
set @counter_m = @counter_m - 1            
--print @counter_m            
end            
--====================END OF PART 2 =============================            
            
            
--===========================PART 3==============================            
set nocount on            
declare @litho_1 varchar(10)            
declare @qstncore_1 int            
declare @counter_1 int            
truncate table tmp_skd_loop_qstncore_s            
begin try drop table #temp_s end try            
begin catch print '' end catch            
            
select strlithocode,qstncore into #temp_s from #temp_1 group by strlithocode,qstncore having COUNT(qstncore) = 1 order by strlithocode,qstncore            
            
set @counter_1 = (select COUNT(*) from #temp_s)            
while (@counter_1 > 0)            
begin             
            
set @litho_1 = (select top 1 strlithocode from #temp_s)            
set @qstncore_1 = (select top 1 qstncore from #temp_s)            
exec( 'insert into tmp_skd_loop_qstncore_s select distinct sm.STRLITHOCODE, qr.QSTNCORE, qr.INTRESPONSEVAL from nqlvalcheck_SFH_Ch_Pedsv2 nql inner join SENTMAILING sm on nql.LITHO = sm.STRLITHOCODE            
inner join QUESTIONFORM qf on sm.SENTMAIL_ID = qf.SENTMAIL_ID             
inner join QUESTIONRESULT qr on qf.QUESTIONFORM_ID = qr.QUESTIONFORM_ID             
where STRLITHOCODE = ' + @litho_1 + 'and QSTNCORE = ' + @qstncore_1)            
            
--PRINT @litho_1             
--PRINT @qstncore_1            
delete from #temp_s where strlithocode = @litho_1 and qstncore = @qstncore_1             
set @counter_1 = @counter_1 - 1            
--print @counter_1            
end            
--====================END OF PART 3 =============================            
--====================STEP 4=====================================        
begin try drop table #Multiple end try            
begin catch print '' end catch           
select Litho,Question,        
case when  qstncore = 1 and right(ltrim(rtrim(question)),1) = 'A' then 1         
  when  qstncore = 1 and right(ltrim(rtrim(question)),1) = 'B' then 2         
  when  qstncore = 1 and right(ltrim(rtrim(question)),1) = 'C' then 3         
  when  qstncore = 1 and right(ltrim(rtrim(question)),1) = 'D' then 4         
  when  qstncore = 1 and right(ltrim(rtrim(question)),1) = 'E' then 5         
  when  qstncore = 1 and right(ltrim(rtrim(question)),1) = 'F' then 6         
  when  qstncore = 1 and right(ltrim(rtrim(question)),1) = 'G' then 7         
  when  qstncore = 1 and right(ltrim(rtrim(question)),1) = 'H' then 8         
  when  qstncore = 1 and right(ltrim(rtrim(question)),1) = 'I' then 9         
  when  qstncore = 1 and right(ltrim(rtrim(question)),1) = 'J' then 10 else 99 end as intresponseval into #Multiple        
from tmp_skd_loop_qstncore where question like '%[a-z]%'         
        
--select * from #Multiple        
--====================END OF PART 4 =============================        
            
set nocount on            
begin try drop table #finalresponse end try            
begin catch print '' end catch            
            
begin try drop table #Compare_Responses end try            
begin catch print '' end catch            
            
            
select t.Litho as [lithosfromtemp],            
t.qstncore as [CSVResponse],            
--t.Question as [QuestionsfromTemp],            
--m.strlithocode as [LithosfromSingleresponse],            
m.intresponseval as [QualisysResponse],            
m.question as [ActualQuestions] into #Compare_Responses             
from tmp_skd_loop_qstncore t inner join tmp_skd_loop_qstncore_s m on t.Litho = m.strlithocode and t.Question = m.question            
union all            
select t.Litho as [lithosfromtemp],            
t.qstncore as [CSVResponse],            
--t.Question as [QuestionsfromTemp],            
--m.strlithocode as [LithosfromMultirespQ],            
--m.qstncore as [QuestionfromMultiRespTable],            
m.intresponseval as [QualisysResponse],            
m.question as [ActualQuestions]            
from tmp_skd_loop_qstncore t inner join tmp_skd_loop_qstncore_m m on t.Litho = m.strlithocode and t.Question = m.question            
union all         
select distinct m.Litho as [lithosfromtemp],m.intresponseval as [CSVResponse],qr.intresponseval as [QualisysResponse],m.Question as [ActualQuestions]      
from #Multiple m inner join sentmailing sm on m.Litho = sm.strlithocode      
inner join questionform qf on sm.sentmail_id = qf.sentmail_id       
left join questionresult qr on qf.questionform_id = qr.questionform_id and       
m.question = case when cast(qr.intresponseval as varchar) =  1  then cast(QstnCore as varchar)+ 'A'      
    when cast(qr.intresponseval as varchar) =2 then cast(QstnCore as varchar)+ 'B'      
 when cast(qr.intresponseval as varchar) ='3' then cast(QstnCore as varchar)+ 'C'      
 when cast(qr.intresponseval as varchar) ='4' then cast(QstnCore as varchar)+ 'D'      
 when cast(qr.intresponseval as varchar) ='5' then cast(QstnCore as varchar)+ 'E'      
 when cast(qr.intresponseval as varchar) ='6' then cast(QstnCore as varchar)+ 'F'      
 when cast(qr.intresponseval as varchar) ='7' then cast(QstnCore as varchar)+ 'G'      
 when cast(qr.intresponseval as varchar) ='8' then cast(QstnCore as varchar)+ 'H'      
 when cast(qr.intresponseval as varchar) ='9' then cast(QstnCore as varchar)+ 'I'      
 when cast(qr.intresponseval as varchar) ='10' then cast(QstnCore as varchar)+ 'J'      
 when cast(qr.intresponseval as varchar) =  '11' then cast(QstnCore as varchar)+ 'K'  end      
            
--select * from #Compare_Responses            
            
select lithosfromtemp as [CSVLithos],CSVResponse,QualisysResponse,ActualQuestions,           
case when csvresponse = '99'  then 'OK'      
  when csvresponse = QualisysResponse then 'OK'           
  when csvresponse is NULL and QualisysResponse = '-9' then 'OK'         
  when csvresponse = 0 and QualisysResponse = '-9' then 'OK'         
  --when ActualQuestions like '%[a-z]%' and csvresponse = 1 and  QualisysResponse is not null then 'OK'          
  else 'Error' end as 'State'  into #finalresponse        
from #Compare_Responses  where csvresponse not in ('99','1')      
order by 1,4        
              
if exists(select * from #finalresponse where [state] = 'Error')                
begin                 
select * from #finalresponse where [state] = 'Error' order by [CSVLithos],ActualQuestions        
end else print 'There are no Invalid responses for the listed Lithos'                
print'======================================================'                                              
Print '******End of Message*******'


