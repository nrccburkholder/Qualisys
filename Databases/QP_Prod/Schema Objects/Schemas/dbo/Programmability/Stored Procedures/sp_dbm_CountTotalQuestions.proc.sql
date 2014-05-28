CREATE Proc sp_dbm_CountTotalQuestions (@Study_ID int)  
as  
begin  
  
--Test code  
--sp_dbm_CountTotalQuestions 2237  
  
declare @qstncoreCnt int, @Q_qstncoreCnt int, @DM_qstncoreCnt int, @survey_ID int    
  
    
select @study_Id = study_id from SURVEY_DEF where SURVEY_ID =@Survey_id    

Create table #tot_Qstncores (qstncore int, Type Varchar(1))  
  
insert into #tot_Qstncores    
select distinct sq.qstncore, 'Q'  
from sel_qstns sq  
where sq.SURVEY_ID in (SELECT SURVEY_ID from SURVEY_DEF where STUDY_ID = @study_Id)    
  
insert into #tot_Qstncores    
select distinct q.qstncore, 'D'  
from datamart.qp_comments.dbo.questions q    
where q.SURVEY_ID in (SELECT SURVEY_ID from datamart.qp_comments.dbo.clientstudysurvey where STUDY_ID = @study_Id)    
  
Select count(distinct qstncore)  
from #tot_Qstncores  
  
drop table #tot_Qstncores  
     
end


