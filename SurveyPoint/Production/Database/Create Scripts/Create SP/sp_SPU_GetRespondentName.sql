
/*  
MWB 1/10/08  
Procedure returns the first and last name for a given respondent based on the respondentID passed in.  
*/  
create procedure sp_SPU_GetRespondentName(@RespondentID int)  
as  
begin  
 select RespondentID, FirstName, LastName from respondents where RespondentID = @RespondentID  
end