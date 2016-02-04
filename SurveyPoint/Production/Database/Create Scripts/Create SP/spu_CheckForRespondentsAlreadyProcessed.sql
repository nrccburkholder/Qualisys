    
CREATE procedure SPU_CheckForRespondentsAlreadyProcessed  
(      
 @RespondentIDs varchar(7700),       
 @DateImported datetime = null     
)      
AS      
BEGIN      
  
declare @SQL varchar(8000)       
  
set @SQL = 'Select R.RespondentID, R.FirstName, R.LastName from Respondents R, SPU_RespondentsUpdated RU  
   where R.RespondentID = RU.RespondentID and R.RespondentID in (' + @RespondentIDs + ')'  
  
if @DateImported is not null  
 set @SQL = @SQL + ' and convert(varchar,RU.UpdatedDate,101) = convert(varchar,''' + convert(varchar,@DateImported,101) + ''',101)'  
  
print @SQL  
exec (@SQL)  
  
END  
  