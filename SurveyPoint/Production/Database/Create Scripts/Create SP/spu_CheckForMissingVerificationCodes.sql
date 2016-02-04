  
CREATE Procedure SPU_CheckforMissingVerificationCodes    
(    
 @RespondentIDs varchar(7700),     
 @DateImported datetime    
)    
AS    
BEGIN    
  
/*  
12/2/07 MWB  
Purpose: This function takes in a list of respondents and returns the respondents who   
1.) do not have a 2006 code in the eventlog  
2.) do not have a 2020 code in the eventlog  
3.) are not in the SPU_CheckforMissingVerificationCodes - this means they have already been updated previously.  
To re-update this record you will need to delete there entry from this table.  
  
*/  
declare @SQL varchar(8000)     
    
create table #RespondentsWithCode2006 (RespondentID varchar(10))        
create table #RespondentsWithCode2020 (RespondentID varchar(10))    
    
create table #HasBoth (RespondentID varchar(10))    
    
    
set @SQL = 'insert into #RespondentsWithCode2006    
select RespondentID    
from Eventlog    
where EventID = 2006 and convert(varchar,eventDate,101) = '''     
+ cast(convert(varchar,@DateImported,101) as varchar(30)) +    
''' and RespondentID in (' + @RespondentIDs + ')'    
    
print @SQL    
Exec (@SQL)    
    
    
set @SQL = 'insert into #RespondentsWithCode2020    
select RespondentID    
from Eventlog    
where EventID = 2020 and convert(varchar,eventDate,101) = '''     
+ cast(convert(varchar,@DateImported,101) as varchar(30)) +    
''' and RespondentID in (' + @RespondentIDs + ')'    
    
print @SQL    
Exec (@SQL)    
    
Insert into #HasBoth    
Select C1.RespondentID    
from #RespondentsWithCode2006 C1, #RespondentsWithCode2020 C2    
where C1.RespondentID = C2.RespondentID    
    
    
set @SQL = 'select R.RespondentID, R.FirstName, R.LastName    
from Respondents R    
where RespondentID in (' + @RespondentIDs + ') and RespondentID not in (Select RespondentID from #HasBoth)'    
    
--print @SQL    
Exec (@SQL)    
    
    
    
Drop Table #RespondentsWithCode2006    
Drop Table #RespondentsWithCode2020    
Drop Table #HasBoth    
    
END 