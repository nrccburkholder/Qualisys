/*
S9.US12	As a Client Services team member I want to be able to label text boxes in formlayout so that I can map text boxes to sample units. 

12.1	Add a name field to the textbox edit window. 
12.2	Save label to Qualisys in TextBox table and load label from Qualisys
12.3	Save label to Template/load from template
12.4	Cover letter labeled as "Not a Cover Letter" save to and pull from qualisys and Delphi file template
12.5	Cover letter remove header etc. so it's obvious it's an artifact and not a real cover letter. 
12.6	A dropdown selector at the top in the tool bar
12.7	Remove artifact coverletters from PrintMockup


Chris Burkholder

update table [dbo].[TABLEDEF]
ALTER TABLE [dbo].[SEL_TEXTBOX]
ALTER PROCEDURE [dbo].[sp_FL_SaveSurvey]
*/

Use [QP_Prod]
go
Begin Tran
go
update TABLEDEF set TEXTBOX = 'Label' 
--select * from TABLEDEF
where STRFULL = 'Label' and TEXTBOX <> 'Label'

--select top 10 * from SEL_TEXTBOX

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'SEL_TEXTBOX' AND COLUMN_NAME = 'LABEL')
ALTER TABLE SEL_TEXTBOX 
ADD LABEL char(60) NULL 
DEFAULT ''

GO

update QualPro_Params set strparam_value = '3.15' where STRPARAM_NM = 'FormLayoutVersion'
					 and strparam_value <> '3.15'
--update QualPro_Params set strparam_value = '3.0' 
--select * from Qualpro_params where STRPARAM_NM = 'FormLayoutVersion'

GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  Stored Procedure dbo.sp_FL_SaveSurvey    Script Date: 6/9/99 4:36:35 PM ******/
/******  Modified 6/16/3 BD  Added a procedure to populate strFullQuestion in Sel_Qstns       ******/
/******  Modified 9/24/2014 CJB Added Label to MySel_TextBox insert to Sel_TextBox ***/
/******  Modified 10/2/2014 CJB Made a replacement on the Label for MySel_TextBox in order not to lose the rows ***/
ALTER PROCEDURE [dbo].[sp_FL_SaveSurvey]
 @survey_id int
as
  declare @rc int, @strsurvey varchar(18)
  if not exists (select survey_id
 from dbo.Survey_def
 where survey_id = @survey_id)
  begin
 select @strsurvey=convert(varchar(18),@survey_id)
 raiserror ('Survey Id %s is not valid', 16, -1, @strsurvey)
 return
  end
  BEGIN TRANSACTION
  EXEC sp_FL_ClearSurvey @survey_id
  if @@error <> 0
  begin
      ROLLBACK TRANSACTION
      RETURN
  END
  INSERT INTO Sel_Qstns (SelQstns_id, Survey_id, Language, ScaleID, 
  Section_id, Label, PlusMinus, Subsection, Item, Subtype, 
  Width, Height, RichText, ScalePos, ScaleFlipped, NumMarkCount, 
  bitMeanable, numBubbleCount, QstnCore, bitLangReview)
   SELECT  SelQstns_id,Survey_id,Language,ScaleID,
  Section_id,Label,PlusMinus,Subsection,Item,Subtype,
  Width,Height,RichText,ScalePos,ScaleFlipped,numMarkCount,
  bitMeanable,numBubbleCount,QstnCore,bitLangReview 
      FROM #MySel_Qstns
  if @@error <> 0
  begin
    ROLLBACK TRANSACTION
    RETURN
  end
  INSERT INTO Sel_Scls (Survey_id,QPC_ID, Item, Language, Val, Label, RichText, 
   Missing, Charset, ScaleOrder, intRespType)
   SELECT Survey_id,QPC_ID,Item,Language,Val,Label,RichText,
  Missing,Charset,ScaleOrder,intRespType 
      FROM #MySel_Scls
  if @@error <> 0
  begin
    ROLLBACK TRANSACTION
    RETURN
  end
  INSERT INTO Sel_Skip
      (Survey_id,SelQstns_id,SelScls_id,ScaleItem,numSkip,numSkipType)
  SELECT 
       Survey_id,SelQstns_id,SelScls_id,ScaleItem,numSkip,numSkipType 
      FROM #MySel_Skip
  if @@error <> 0
  begin
    ROLLBACK TRANSACTION
    RETURN
  end
  INSERT INTO Sel_Logo
 (QPC_ID,CoverID,Survey_id,Description,X,Y,Width,Height,Scaling,Bitmap,Visible)
   SELECT 
      QPC_ID,CoverID,Survey_id,Description,X,Y,Width,Height,Scaling,Bitmap,Visible 
      FROM #MySel_Logo
  if @@error <> 0
  begin
    ROLLBACK TRANSACTION
    RETURN
  end
  INSERT INTO Sel_TextBox
      (QPC_ID,Survey_id,Language,CoverID,X,Y,Width,Height,RichText,Border,Shading,bitLangReview,Label)
  SELECT 
      QPC_ID,Survey_id,Language,CoverID,X,Y,Width,Height,RichText,Border,Shading,bitLangReview,Replace(Label, '## NO LABEL ##', '') 
      FROM #MySel_TextBox
  if @@error <> 0
  begin
    ROLLBACK TRANSACTION
    RETURN
  end
  INSERT INTO Sel_PCL
 (QPC_ID,Survey_id,Language,CoverID,Description,X,Y,Width,Height,PCLStream,KnownDimensions)
   SELECT 
      QPC_ID,Survey_id,Language,CoverID,Description,X,Y,Width,Height,PCLStream,KnownDimensions 
      FROM #MySel_PCL
  if @@error <> 0
  begin
    ROLLBACK TRANSACTION
    RETURN
  end
  INSERT INTO Sel_Cover
   (SelCover_id,Survey_id,PageType,Description,Integrated,bitLetterHead)
   SELECT 
     SelCover_id,Survey_id,PageType,Description,Integrated,bitLetterHead 
      FROM #MySel_Cover
  if @@error <> 0
  begin
    ROLLBACK TRANSACTION
    RETURN
  END
COMMIT TRANSACTION

-- Added 6/16/3 BD
-- Populates strFullQuestion in Sel_Qstns for a given survey_id
EXEC SP_DBM_StripRTF @survey_id

-- Added 11/3/3 BD
-- Removes orphaned questions
EXEC SP_SYS_RemoveOrphanQuestions @Survey_id

GO

/*
--select top 1 survey_id from survey_def where surveytype_id = 10 order by survey_id desc --15784

select substring('NY',status/1024&1+1,1) from master..sysdatabases where name=DB_NAME()

select USER_NAME() select usertype,type,name from systypes where usertype>=257

exec sp_datatype_info 12
exec sp_datatype_info 1
exec sp_datatype_info 3
exec sp_datatype_info 2
exec sp_datatype_info 5
exec sp_datatype_info 4
exec sp_datatype_info 7
exec sp_datatype_info 6
exec sp_datatype_info 8
exec sp_datatype_info -1
exec sp_datatype_info -7
exec sp_datatype_info -6
exec sp_datatype_info -5
exec sp_datatype_info -2
exec sp_datatype_info -3
exec sp_datatype_info -4
exec sp_datatype_info 9
exec sp_datatype_info 10
exec sp_datatype_info 11


select strParam_value from QualPro_params where strParam_nm='EnvName' and strParam_grp='Environment'

select STRPARAM_VALUE from QualPro_Params where STRPARAM_NM = 'FormLayoutVersion'

select client_id from clientstudysurvey_view where survey_id=15784

select tag.tag, tf.strReplaceLiteral
from tag, tagfield tf, survey_def sd
where tf.study_id=sd.study_id and
  sd.survey_id=15784 and
  ((tf.strReplaceLiteral<>'') or (tf.strReplaceLiteral<>null)) and
  tag.tag_id=tf.tag_id

--TableDef.db
Select QPC_ID, strFull, FieldType, FieldLen, FieldRequired, Question, Scale, Logo, TextBox, PCL, Cover, QPC_Skip from TableDef

select study.study_id, ('Study:'+study.strStudy_nm)+' Survey:'+survey_def.strSurvey_nm as title, survey_def.bitLayoutValid
from study, survey_def
where survey_def.survey_id=15784 and survey_def.study_id=study.study_id

--SEL_Cover.DB
Select
Survey_ID, SelCover_ID, PageType, 'Cover' as Type, Description, Integrated, bitLetterHead
from Sel_Cover
where Survey_ID=15784

--SEL_LOGO
SELECT "QPC_ID" ,"COVERID" ,"SURVEY_ID" ,"DESCRIPTION" ,"X" ,"Y" ,"WIDTH" ,"HEIGHT" ,"SCALING" ,"BITMAP" ,"VISIBLE"  FROM "dbo"."SEL_LOGO" ORDER BY  "QPC_ID" ASC , "COVERID" ASC , "SURVEY_ID" ASC 

--SEL_TextBox
Select
Survey_ID, QPC_ID, Language, CoverID, 'TextBox' as Type, Label, X, Y, Width, Height, RichText, Border, Shading, bitLangReview, Label
from Sel_TextBox
where QPC_ID = 3
and Survey_ID=15784

--update sel_textbox set X=531, Y=48, Width = 156, Height = 88, Shading = 14671839 where survey_id = 15784

--SEL_PCL.DB
Select
Survey_ID, QPC_ID, Language, CoverID, 'PCL' as Type, Description, X, Y, Width, Height, PCLStream, KnownDimensions
from Sel_PCL
where Survey_ID=15784

--SEL_SCLS.DB
Select
Survey_ID, QPC_ID, Item, Language, 'Scale' as Type, Label, CharSet, Val, RichText, ScaleOrder, intRespType, Missing
from Sel_Scls
where Survey_ID=15784

--SEL_SKIP.DB
Select
Survey_ID, SelQstns_ID, SelScls_ID, ScaleItem, 'Skip' as Type, numSkip, numSkipType
from Sel_Skip
where Survey_ID=15784

--SEL_QSTNS
Select
Survey_ID, SelQstns_ID, Language, Section_ID, 'Question' as Type, Label, PlusMinus, Subsection, Item, Subtype, ScaleID, Width, Height, RichText, QstnCore, ScalePos, bitLangReview, bitMeanable, numMarkCount, numBubbleCount, ScaleFlipped
from Sel_Qstns
where Survey_ID=15784

--SEL_Language.DB
Select LangID,Language,Dictionary,'False' as UseLang from Languages

--SAMPLEUNITSECTION
select SELQSTNSSECTION, SAMPLEUNITSECTION_ID from SAMPLEUNITSECTION where SELQSTNSSURVEY_ID =15784 order by SELQSTNSSECTION, SAMPLEUNITSECTION_ID

Select strParam_nm, numParam_Value from QualPro_Params where strParam_grp='AddressPos' order by strParam_nm
Select strParam_nm, numParam_Value from QualPro_Params where strParam_grp='PostcardAddressPos' order by strParam_nm
Select strParam_nm, numParam_Value from QualPro_Params where strParam_grp='LgPostcardAddressPos' order by strParam_nm

EXEC sp_helptext 'dbo.SP_FG_FormGen_Sub'
EXEC sp_helptext 'dbo.SP_FG_NonMailGen'
EXEC sp_helptext 'dbo.sp_FL_SaveSurvey'

*/

Commit Tran