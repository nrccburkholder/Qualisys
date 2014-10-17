/*
Sprint8_UserStory5_Task1_InsertBlankHcahpsSurveys - backout

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

delete from SurveyTypeDispositions where Disposition_ID = 25 and SurveyType_id = 2

delete from SurveyTypeDispositions where Disposition_ID = 26 and SurveyType_id = 2
