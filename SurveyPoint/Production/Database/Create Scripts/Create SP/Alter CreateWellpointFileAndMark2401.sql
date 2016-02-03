/*
11/10/2007 MWB v1.0 Origional
Purpose:
The purpose of this SP is to return a listing all respondents that have matching codes (sent in as a Parmeter) and then mark those 
records with a 2401 code - which means they have been exported to the client.
Codes to look for and exlcude can be sent in as optional parameters.
*/
alter procedure CreateWellPointFileAndMark2401  
(  
@ClientIDs varchar(300), @IncludedCodes varchar(1000) = '3012, 3022, 3032, 3035, 3038' ,   
@ExcludedCodes varchar(100) = '2401', @UserID int = 1  
)  
as  
  
begin  
  
declare @SQL varchar(8000)  
declare @SQLInsertTmpTable varchar(8000)  
declare @SQLUpdate varchar(8000)  
declare @FailedFunction varchar(250)  
  
declare @SelCnt int  
declare @InsCnt int  
declare @error int  
  
set NoCount on  
  
set @SQL = 'Select BATCHID,RESPONDENTID,CLIENTRESPONDENTID,CLIENTNAME,SURVEYINSTANCEID,LASTNAME,FIRSTNAME,MIDDLEINITIAL,TELEPHONEDAY,GENDER,CONVERT(VARCHAR(10), DOB, 101) AS DOB,SSN,  
isnull(Q1_1_DESC, '''') as Q1_1_DESC,isnull(Q138_1_DESC, '''') as Q138_1_DESC,isnull(Q2_0, '''') as Q2_0,isnull(Q2_0_DESC, '''') as Q2_0_DESC,isnull(Q3_0, '''') as Q3_0,  
isnull(Q3_0_DESC, '''') as Q3_0_DESC,isnull(Q5_0, '''') as Q5_0,isnull(Q6_0, '''') as Q6_0,isnull(Q7_1_DESC, '''') as Q7_1_DESC,isnull(Q8_0, '''') as Q8_0,isnull(Q9_0, '''') as Q9_0,  
isnull(Q11_0, '''') as Q11_0,isnull(Q12_0, '''') as Q12_0,isnull(Q13_0, '''') as Q13_0,isnull(Q14_0, '''') as Q14_0,isnull(Q15_0, '''') as Q15_0,isnull(Q16_0, '''') as Q16_0,  
isnull(Q17_0, '''') as Q17_0,isnull(Q18_0, '''') as Q18_0,isnull(Q19_0, '''') as Q19_0,isnull(Q20_0, '''') as Q20_0,isnull(Q21_0, '''') as Q21_0,isnull(Q22_0, '''') as Q22_0,  
isnull(Q23_0, '''') as Q23_0,isnull(Q24_0, '''') as Q24_0,isnull(Q25_0, '''') as Q25_0,isnull(Q26_0, '''') as Q26_0,isnull(Q27_1_DESC, '''') as Q27_1_DESC,  
isnull(Q27_2_DESC, '''') as Q27_2_DESC,isnull(Q27_3_DESC, '''') as Q27_3_DESC,isnull(Q30_0, '''') as Q30_0,isnull(Q31_0, '''') as Q31_0,isnull(Q32_0, '''') as Q32_0,  
isnull(Q33_0, '''') as Q33_0,isnull(Q34_0, '''') as Q34_0,isnull(Q35_0, '''') as Q35_0,isnull(Q36_0, '''') as Q36_0,isnull(Q37_0, '''') as Q37_0,isnull(Q38_0, '''') as Q38_0,  
isnull(Q39_0, '''') as Q39_0,isnull(Q40_0, '''') as Q40_0,isnull(Q41_0, '''') as Q41_0,isnull(Q42_0, '''') as Q42_0,isnull(Q43_0, '''') as Q43_0,isnull(Q44_0, '''') as Q44_0,  
isnull(Q45_0, '''') as Q45_0,isnull(Q46_0, '''') as Q46_0,isnull(Q48_0, '''') as Q48_0,isnull(Q49_0, '''') as Q49_0,isnull(Q50_0, '''') as Q50_0,isnull(Q51_0, '''') as Q51_0,  
isnull(Q52_0, '''') as Q52_0,isnull(Q53_0, '''') as Q53_0,isnull(Q54_0, '''') as Q54_0,isnull(Q55_0, '''') as Q55_0,isnull(Q56_0, '''') as Q56_0,isnull(Q57_0, '''') as Q57_0,  
isnull(Q58_0, '''') as Q58_0,isnull(Q59_0, '''') as Q59_0,isnull(Q60_0, '''') as Q60_0,isnull(Q61_0, '''') as Q61_0,isnull(Q62_0, '''') as Q62_0,isnull(Q63_0, '''') as Q63_0,  
isnull(Q64_0, '''') as Q64_0,isnull(Q65_0, '''') as Q65_0,isnull(Q66_0, '''') as Q66_0,isnull(Q67_0, '''') as Q67_0,isnull(Q68_0, '''') as Q68_0,isnull(Q69_0, '''') as Q69_0,  
isnull(Q70_0, '''') as Q70_0,isnull(Q71_0, '''') as Q71_0,isnull(Q72_0, '''') as Q72_0,isnull(Q73_0, '''') as Q73_0,isnull(Q73_0_DESC, '''') as Q73_0_DESC,isnull(Q74_0, '''') as Q74_0,  
isnull(Q75_0, '''') as Q75_0,isnull(Q75_0_DESC, '''') as Q75_0_DESC,isnull(Q76_0, '''') as Q76_0,isnull(Q77_0, '''') as Q77_0,isnull(Q78_0, '''') as Q78_0,isnull(Q79_0, '''') as Q79_0,  
isnull(Q80_0, '''') as Q80_0,isnull(Q81_0, '''') as Q81_0,isnull(Q82_0, '''') as Q82_0,isnull(Q83_0, '''') as Q83_0,isnull(Q84_0, '''') as Q84_0,isnull(Q85_0, '''') as Q85_0,  
isnull(Q86_0, '''') as Q86_0,isnull(Q87_0, '''') as Q87_0,isnull(Q88_0, '''') as Q88_0,isnull(Q89_0, '''') as Q89_0,isnull(Q90_0, '''') as Q90_0,isnull(Q91_0, '''') as Q91_0,  
isnull(Q92_0, '''') as Q92_0,isnull(Q93_1, '''') as Q93_1,isnull(Q93_2, '''') as Q93_2,isnull(Q93_3, '''') as Q93_3,isnull(Q93_4, '''') as Q93_4,isnull(Q93_5, '''') as Q93_5,  
isnull(Q93_6, '''') as Q93_6,isnull(Q94_0, '''') as Q94_0,isnull(Q95_0, '''') as Q95_0,isnull(Q96_0, '''') as Q96_0,isnull(Q97_0, '''') as Q97_0,isnull(Q98_1, '''') as Q98_1,  
isnull(Q98_2, '''') as Q98_2,isnull(Q98_3, '''') as Q98_3,isnull(Q99_0, '''') as Q99_0,  
isnull(Q100_0, '''') as Q100_0, isnull(substring(q102_1_Desc, 250,1), '''') as Q102_1_DESC,   
isnull(substring(q102_1_Desc, 250,251), '''') as Q102_2_DESC, isnull(substring(q102_1_Desc, 250,501), '''') as Q102_3_DESC,   
isnull(substring(q102_1_Desc, 250,750), '''') as Q102_4_DESC, isnull(Q103_0, '''') as Q103_0,isnull(Q104_1_DESC, '''') as Q104_1_DESC,isnull(Q104_2_DESC, '''') as Q104_2_DESC,  
isnull(Q104_3_DESC, '''') as Q104_3_DESC,isnull(Q104_3, '''') as Q104_3,isnull(Property_PRA_SCORE, '''') as Property_PRA_SCORE,isnull(Property_PRA_PERCENTILE, '''') as Property_PRA_PERCENTILE,  
isnull(Property_DEPRESSION_SCORE, '''') as Property_DEPRESSION_SCORE,isnull(Property_FRAILTY_SCORE, '''') as Property_FRAILTY_SCORE,isnull(Property_SENIOR_HEALTH_REPORT, '''') as Property_SENIOR_HEALTH_REPORT 
FROM qmswebuser.xv_SurveyID_24 r   
WHERE SurveyID = 24   
 AND ClientID IN (' + @ClientIDs + ')   
 AND EXISTS (SELECT ''x'' FROM EventLog WHERE EventLog.EventID IN (' + @IncludedCodes + ') and EventLog.RespondentID = r.RespondentID)  
 AND NOT EXISTS (SELECT ''x'' FROM EventLog WHERE EventLog.EventID in(' + @ExcludedCodes + ') and EventLog.RespondentID = r.RespondentID)   
 AND SurveyInstanceID IN (SELECT SurveyInstanceID FROM SurveyInstances WHERE Active =1 AND SurveyID = 24 AND ClientID in (' + @ClientIDs + '))   
 AND MailingSeedFlag = 0   
ORDER BY CLIENTNAME, SURVEYINSTANCEID, RESPONDENTID'  
  
/*  
set @SQLUpdate = 'Insert into Eventlog (EventDate, EventID, UserID, RespondentID, SurveyInstanceID, SurveyID, ClientID, EventTypeID)    
Select getDate() as EventDate, 2401 as EventID, ' + cast(@UserID as varchar) + ' as UserID, RespondentID, SurveyInstanceID, SurveyID, (Select top 1 ClientID from Clients where clientName = r.ClientName) as ClientID, 4 as EventTypeID  
FROM qmswebuser.xv_SurveyID_24 r   
WHERE SurveyID = 24   
 AND ClientID IN (' + @ClientIDs + ')   
 AND EXISTS (SELECT ''x'' FROM EventLog WHERE EventLog.EventID IN (' + @IncludedCodes + ') and EventLog.RespondentID = r.RespondentID)  
 AND NOT EXISTS (SELECT ''x'' FROM EventLog WHERE EventLog.EventID in(' + @ExcludedCodes + ') and EventLog.RespondentID = r.RespondentID)   
 AND SurveyInstanceID IN (SELECT SurveyInstanceID FROM SurveyInstances WHERE Active =1 AND SurveyID = 24 AND ClientID in (' + @ClientIDs + '))   
 AND MailingSeedFlag = 0   
ORDER BY CLIENTNAME, SURVEYINSTANCEID, RESPONDENTID'  
*/  
  
set @SQLInsertTmpTable = 'Select getDate() as EventDate, 2401 as EventID, ' + cast(@UserID as varchar) + ' as UserID, RespondentID, SurveyInstanceID, SurveyID, (Select top 1 ClientID from Clients where clientName = r.ClientName) as ClientID, 4 as EventTypeID  
into ##tblRespInsert  
FROM qmswebuser.xv_SurveyID_24 r   
WHERE SurveyID = 24   
 AND ClientID IN (' + @ClientIDs + ')   
 AND EXISTS (SELECT ''x'' FROM EventLog WHERE EventLog.EventID IN (' + @IncludedCodes + ') and EventLog.RespondentID = r.RespondentID)  
 AND NOT EXISTS (SELECT ''x'' FROM EventLog WHERE EventLog.EventID in(' + @ExcludedCodes + ') and EventLog.RespondentID = r.RespondentID)   
 AND SurveyInstanceID IN (SELECT SurveyInstanceID FROM SurveyInstances WHERE Active =1 AND SurveyID = 24 AND ClientID in (' + @ClientIDs + '))   
 AND MailingSeedFlag = 0   
ORDER BY CLIENTNAME, SURVEYINSTANCEID, RESPONDENTID'  
  
set @SQLUpdate = 'Insert into Eventlog (EventDate, EventID, UserID, RespondentID, SurveyInstanceID, SurveyID, ClientID, EventTypeID) select * from ##tblRespInsert'  
  
/*
print @SQL  
print @SQLInsertTmpTable  
print @SQLUpdate  
*/  
  
begin tran  
  
exec (@SQL)  
select @error=@@error, @SelCnt=@@rowcount  
  
if @error > 0   
 begin  
  set @FailedFunction = 'create the report'  
  rollback tran  
  goto failexit  
 end  
  
exec (@SQLInsertTmpTable)  
  
  
if @error > 0   
 begin  
  set @FailedFunction = 'insert all respondents into table to update with a 2401 code'   
  rollback tran  
  goto failexit  
 end  
  
exec (@SQLUpdate)  
select @error=@@error, @InsCnt=@@rowcount  
  
if @error > 0   
 begin  
  set @FailedFunction = 'update all respondents with a 2401 code'   
  rollback tran  
  goto failexit  
 end  
  
Commit tran  
  
  
if @selCnt = 0 and @insCnt = 0   
 Begin  
  Print 'No respondents found to update in the given client list (' + @ClientIDs + ').  No records have been updated'  
 end   
  
if @SelCnt <> @InsCnt  
 Begin  
  Print 'Number of records in Report does not equal number of records inserted.  Please contact System Administrator'  
 end  
  
  
drop table ##tblRespInsert  
  
goto EndofSP  
  
failexit:  
Print 'An unexpected error occured while trying to ' + @FailedFunction + ' please contact the system administrator'  
drop table ##tblRespInsert  
EndofSP:  
  
end  


