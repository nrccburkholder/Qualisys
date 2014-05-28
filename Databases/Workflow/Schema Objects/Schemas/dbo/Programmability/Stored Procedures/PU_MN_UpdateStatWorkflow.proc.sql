/*******************************************************************************
 *
 * Procedure Name:
 *           PU_MN_UpdateStatWorkflow
 *
 * Description:
 *           Extract teams and their client list
 *
 * Parameters:
 *           N/A
 *
 * Return:
 *           -1:    Success
 *           Other: Fail
 *
 * History:
 *           1.0  11/28/2003 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.PU_MN_UpdateStatWorkflow
AS
  SET NOCOUNT ON

  DBCC DBREINDEX('SampleSetDate')
  UPDATE STATISTICS SampleSetDate WITH FULLSCAN

  DBCC DBREINDEX('PU_DefaultMail')
  UPDATE STATISTICS PU_DefaultMail WITH FULLSCAN

  DBCC DBREINDEX('PU_Mail')
  UPDATE STATISTICS PU_Mail WITH FULLSCAN

  DBCC DBREINDEX('PU_Plan')
  UPDATE STATISTICS PU_Plan WITH FULLSCAN

  DBCC DBREINDEX('PU_StandardSection')
  UPDATE STATISTICS PU_StandardSection WITH FULLSCAN

  DBCC DBREINDEX('PU_StandardComment')
  UPDATE STATISTICS PU_StandardComment WITH FULLSCAN

  DBCC DBREINDEX('PUR_Addressee')
  UPDATE STATISTICS PUR_Addressee WITH FULLSCAN

  DBCC DBREINDEX('PUR_Attachment')
  UPDATE STATISTICS PUR_Attachment WITH FULLSCAN

  DBCC DBREINDEX('PUR_Period')
  UPDATE STATISTICS PUR_Period WITH FULLSCAN

  DBCC DBREINDEX('PUR_PeriodCustom')
  UPDATE STATISTICS PUR_PeriodCustom WITH FULLSCAN

  DBCC DBREINDEX('PUR_Report')
  UPDATE STATISTICS PUR_Report WITH FULLSCAN

  DBCC DBREINDEX('PUR_ResultHeadInfo')
  UPDATE STATISTICS PUR_ResultHeadInfo WITH FULLSCAN

  DBCC DBREINDEX('PUR_ResultHeadInfoAddressee')
  UPDATE STATISTICS PUR_ResultHeadInfoAddressee WITH FULLSCAN

  DBCC DBREINDEX('PUR_ResultLoading')
  UPDATE STATISTICS PUR_ResultLoading WITH FULLSCAN

  DBCC DBREINDEX('PUR_ResultResponseRate')
  UPDATE STATISTICS PUR_ResultResponseRate WITH FULLSCAN

  DBCC DBREINDEX('PUR_ResultResponseRateCutOffField')
  UPDATE STATISTICS PUR_ResultResponseRateCutOffField WITH FULLSCAN

  DBCC DBREINDEX('PUR_ResultSampling')
  UPDATE STATISTICS PUR_ResultSampling WITH FULLSCAN

  DBCC DBREINDEX('PUR_Section')
  UPDATE STATISTICS PUR_Section WITH FULLSCAN

  DBCC DBREINDEX('PUR_Survey')
  UPDATE STATISTICS PUR_Survey WITH FULLSCAN

  DBCC DBREINDEX('PUR_ViewHistory')
  UPDATE STATISTICS PUR_ViewHistory WITH FULLSCAN

  DBCC DBREINDEX('Role')
  UPDATE STATISTICS Role WITH FULLSCAN

  DBCC DBREINDEX('Team')
  UPDATE STATISTICS Team WITH FULLSCAN

  DBCC DBREINDEX('TeamMember')
  UPDATE STATISTICS TeamMember WITH FULLSCAN

  DBCC DBREINDEX('NewsBrief')
  UPDATE STATISTICS NewsBrief WITH FULLSCAN

  RETURN -1


