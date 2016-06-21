/*
Sprint8_UserStory5_Task1_InsertBlankHcahpsSurveys

5.1	Update CAHPS_Disposition table

Chris Burkholder

insert into SurveyTypeDispositions 

--------------------------
select * from Disposition

select * from SurveyTypeDispositions
where surveytype_id in (2,10)
order by surveytype_id, Hierarchy
--------------------------
*/

if not exists(select 1 from SurveyTypeDispositions where Disposition_ID = 25 and SurveyType_id = 2)
insert into SurveyTypeDispositions (Disposition_ID,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
values (25,'08',11,'Maximum Attempts on Phone or Mail',0,NULL,2)

if not exists(select 1 from SurveyTypeDispositions where Disposition_ID = 26 and SurveyType_id = 2)
insert into SurveyTypeDispositions (Disposition_ID,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
values (26,'07',10,'Patient Refused',0,NULL,2)
