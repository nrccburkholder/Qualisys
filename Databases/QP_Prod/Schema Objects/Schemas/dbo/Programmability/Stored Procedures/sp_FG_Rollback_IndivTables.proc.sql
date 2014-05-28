/****** Object:  Stored Procedure dbo.sp_FG_Rollback_IndivTables    Script Date: 7/12/99 10:57:14 AM ******/
/****** Object:  Stored Procedure dbo.sp_FG_Rollback_IndivTables    Script Date: 5/7/99 11:56:10 AM ******/
/****************************************************************************************
 *           * 
 * Business Purpose: The Part of the Form Gen Rollback Process that removes   *
 *       Questions, Scales, and Textboxes that are used on the surveys  *
 *       being rolled back.       *
 *           *
 * Created By: Dan Archuleta        *
 *            *
 * Date Created: 5/7/99         *
 *           *  
 * Modified by: Daniel Vansteenburg 7/30/1999 - Removed the INDEX= hint.  Found that the*
 *                   hint was not performing up to speed with the tables.  Also removed *
 *                   the BEGIN and END statements, not needed.  Converted @FrmGenDate to*
 *                   a datetime variable to allow the index to be used properly. *
 ****************************************************************************************/
CREATE PROCEDURE sp_FG_Rollback_IndivTables  
 @FrmGenDate varchar(22)
AS 
 declare @FrmGenDtm datetime
 select @FrmGenDtm = @FrmGenDate
 /*Remove the Questions From Questions_Individual Table*/
 DELETE dbo.Qstns_Individual
    FROM dbo.Qstns_Individual QI, dbo.SentMailing SM, dbo.ScheduledMailing SchM
        WHERE SM.SentMail_id = SchM.SentMail_id
     AND SchM.SamplePop_id = QI.SamplePop_id     
     AND SM.datGenerated = @FrmGenDtm 
 /*Remove the Text Boxes From TextBox_Individual Table*/
 DELETE dbo.TextBox_Individual
    FROM dbo.TextBox_Individual TI, dbo.SentMailing SM, dbo.ScheduledMailing SchM
        WHERE SM.SentMail_id = SchM.SentMail_id
     AND SchM.SamplePop_id = TI.SamplePop_id
     AND SM.datGenerated = @FrmGenDtm 
 
 /*Remove the Scales From Scls_Individual Table*/
 DELETE dbo.Scls_Individual
    FROM dbo.Scls_Individual SI, dbo.SentMailing SM, dbo.QuestionForm QF
        WHERE SM.SentMail_id = QF.SentMail_id
     AND QF.QuestionForm_id = SI.QuestionForm_id
     AND SM.datGenerated = @FrmGenDtm


