use QP_PROD

select *
from SurveyTypeDefaultCriteria
where surveytype_id = 4

select *
from DefaultCriteriaStmt
where DefaultCriteriaStmt_id in (
	select DefaultCriteriaStmt_id
from SurveyTypeDefaultCriteria
where surveytype_id = 4

)


select *
from DefaultCriteriaClause
where DefaultCriteriaStmt_id in (
	select DefaultCriteriaStmt_id
from SurveyTypeDefaultCriteria
where surveytype_id = 4

)


begin tran

INSERT INTO [dbo].[SurveyTypeDefaultCriteria]([SurveyType_id],[Country_id],[DefaultCriteriaStmt_id],[Subtype_id])
     VALUES
           (4
           ,1
           ,1
           ,9)


INSERT INTO [dbo].[SurveyTypeDefaultCriteria]([SurveyType_id],[Country_id],[DefaultCriteriaStmt_id],[Subtype_id])
     VALUES
           (4
           ,1
           ,2
           ,9)

INSERT INTO [dbo].[SurveyTypeDefaultCriteria]([SurveyType_id],[Country_id],[DefaultCriteriaStmt_id],[Subtype_id])
     VALUES
           (4
           ,1
           ,9
           ,9)



DECLARE @DefaultCriteriaStmt_ID int

INSERT INTO [dbo].[DefaultCriteriaStmt] ([strCriteriaStmt_nm],[strCriteriaString],[BusRule_cd])VALUES('DQ_DrFNm','(ENCOUNTERDrFirstName is NULL)','Q')
set @DefaultCriteriaStmt_ID=scope_identity()	


INSERT INTO [dbo].[DefaultCriteriaClause]([DefaultCriteriaStmt_id],[CriteriaPhrase_id],[strTable_nm],[Field_id],[intOperator],[strLowValue],[strHighValue])VALUES
           (@DefaultCriteriaStmt_ID
           ,1
           ,'ENCOUNTER'
           ,119
           ,9
           ,NULL
           ,'')

INSERT INTO [dbo].[SurveyTypeDefaultCriteria]([SurveyType_id],[Country_id],[DefaultCriteriaStmt_id],[Subtype_id])
     VALUES
           (4
           ,1
           ,@DefaultCriteriaStmt_ID
           ,9)


INSERT INTO [dbo].[DefaultCriteriaStmt] ([strCriteriaStmt_nm],[strCriteriaString],[BusRule_cd])VALUES('DQ_DrLNm','(ENCOUNTERDrLastName is NULL)','Q')
set @DefaultCriteriaStmt_ID=scope_identity()

INSERT INTO [dbo].[DefaultCriteriaClause]([DefaultCriteriaStmt_id],[CriteriaPhrase_id],[strTable_nm],[Field_id],[intOperator],[strLowValue],[strHighValue])VALUES
           (@DefaultCriteriaStmt_ID
           ,1
           ,'ENCOUNTER'
           ,118
           ,9
           ,NULL
           ,'')

INSERT INTO [dbo].[SurveyTypeDefaultCriteria]([SurveyType_id],[Country_id],[DefaultCriteriaStmt_id],[Subtype_id])
     VALUES
           (4
           ,1
           ,@DefaultCriteriaStmt_ID
           ,9)


/*

commit tran		

rollback tran

*/


select *
from SurveyTypeDefaultCriteria
where surveytype_id = 4

select *
from DefaultCriteriaStmt
where DefaultCriteriaStmt_id in (
	select DefaultCriteriaStmt_id
from SurveyTypeDefaultCriteria
where surveytype_id = 4

)


select *
from DefaultCriteriaClause
where DefaultCriteriaStmt_id in (
	select DefaultCriteriaStmt_id
from SurveyTypeDefaultCriteria
where surveytype_id = 4

)