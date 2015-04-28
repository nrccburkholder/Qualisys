use QP_PROD

DECLARE @Surveytype_id int

SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'CGCAHPS'

select *
from SurveyTypeDefaultCriteria
where surveytype_id = @Surveytype_id

select *
from DefaultCriteriaStmt
where DefaultCriteriaStmt_id in (
	select DefaultCriteriaStmt_id
from SurveyTypeDefaultCriteria
where surveytype_id = @Surveytype_id

)


select *
from DefaultCriteriaClause
where DefaultCriteriaStmt_id in (
	select DefaultCriteriaStmt_id
from SurveyTypeDefaultCriteria
where surveytype_id = @Surveytype_id

)


begin tran

INSERT INTO [dbo].[SurveyTypeDefaultCriteria]([SurveyType_id],[Country_id],[DefaultCriteriaStmt_id])--,[Subtype_id])
     VALUES
           (@Surveytype_id
           ,1
           ,1)
           --,9)


INSERT INTO [dbo].[SurveyTypeDefaultCriteria]([SurveyType_id],[Country_id],[DefaultCriteriaStmt_id])--,[Subtype_id])
     VALUES
           (@Surveytype_id
           ,1
           ,2)
           --,9)

INSERT INTO [dbo].[SurveyTypeDefaultCriteria]([SurveyType_id],[Country_id],[DefaultCriteriaStmt_id])--,[Subtype_id])
     VALUES
           (@Surveytype_id
           ,1
           ,9)
           --,9)



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

INSERT INTO [dbo].[SurveyTypeDefaultCriteria]([SurveyType_id],[Country_id],[DefaultCriteriaStmt_id])--,[Subtype_id])
     VALUES
           (4
           ,1
           ,@DefaultCriteriaStmt_ID)
           --,9)


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

INSERT INTO [dbo].[SurveyTypeDefaultCriteria]([SurveyType_id],[Country_id],[DefaultCriteriaStmt_id])--,[Subtype_id])
     VALUES
           (@Surveytype_id
           ,1
           ,@DefaultCriteriaStmt_ID)
           --,9)


/*

commit tran		

rollback tran

*/


select *
from SurveyTypeDefaultCriteria
where surveytype_id = @Surveytype_id

select *
from DefaultCriteriaStmt
where DefaultCriteriaStmt_id in (
	select DefaultCriteriaStmt_id
from SurveyTypeDefaultCriteria
where surveytype_id = @Surveytype_id

)


select *
from DefaultCriteriaClause
where DefaultCriteriaStmt_id in (
	select DefaultCriteriaStmt_id
from SurveyTypeDefaultCriteria
where surveytype_id = @Surveytype_id

)