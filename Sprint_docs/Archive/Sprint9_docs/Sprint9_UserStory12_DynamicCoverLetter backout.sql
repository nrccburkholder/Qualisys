Use [QP_Prod]
go
Begin Tran
go
update TABLEDEF set TEXTBOX = '' 
--select * from TABLEDEF
where STRFULL = 'Label' and TEXTBOX = 'Label'

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'SEL_TEXTBOX' AND COLUMN_NAME = 'LABEL')
ALTER TABLE SEL_TEXTBOX 
DROP COLUMN LABEL 

update QualPro_Params set strparam_value = '3.0' where STRPARAM_NM = 'FormLayoutVersion'
					 and strparam_value <> '3.0'
--update QualPro_Params set strparam_value = '3.0' 
--select * from Qualpro_params where STRPARAM_NM = 'FormLayoutVersion'

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[sp_FL_SaveSurvey]    Script Date: 11/11/2014 2:42:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.sp_FL_SaveSurvey    Script Date: 6/9/99 4:36:35 PM ******/
/******  Modified 6/16/3 BD  Added a procedure to populate strFullQuestion in Sel_Qstns       ******/
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
      (QPC_ID,Survey_id,Language,CoverID,X,Y,Width,Height,RichText,Border,Shading,bitLangReview)
  SELECT 
      QPC_ID,Survey_id,Language,CoverID,X,Y,Width,Height,RichText,Border,Shading,bitLangReview 
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



Commit Tran