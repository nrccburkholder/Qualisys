/****** Object:  Stored Procedure dbo.sp_PCL_DeleteFromIndiv ******/
/***********************************************************************************************
 *
 * Business Purpose: This procedure removes records from Qstns_Individual, Scls_Individual
 *    and TextBox_Individual for a successful batch of surveys 
 *
 * Date Created:  2/17/2000
 *
 * Created by:  Dave Gilsdorf
 *
 * v2.0.1 - 2/17/2000 - DG - initial version
 * v2.0.2 - 2/17/2000 - DG - changed the deletes to updates - a separate stored procedure will
 *   delete any records in which Language=-1
 *
 ************************************************************************************************/
CREATE PROCEDURE sp_PCL_DeleteFromIndiv
AS
/*  delete TextBox_Individual 
  from TextBox_Individual TBI, #MyPCLNeeded MPN 
  with (NOLOCK)
  where MPN.SentMail_id=TBI.SentMail_id

  delete Scls_Individual 
  from Scls_Individual SI, #MyPCLNeeded MPN 
  with (NOLOCK)
  where MPN.QuestionForm_id=SI.QuestionForm_id

  delete Qstns_Individual 
  from Qstns_Individual QI, #MyPCLNeeded MPN 
  with (NOLOCK)
  where MPN.SentMail_id=QI.SentMail_id
*/

/*  Try updating to speed up process
  update TextBox_Individual 
  set Language = -1 
  from TextBox_Individual TBI, #MyPCLNeeded MPN 
  where MPN.SentMail_id=TBI.SentMail_id

  update Scls_Individual 
  set Language = -1 
  from Scls_Individual SI, #MyPCLNeeded MPN 
  where MPN.QuestionForm_id=SI.QuestionForm_id

  update Qstns_Individual 
  set Language = -1 
  from Qstns_Individual QI, #MyPCLNeeded MPN 
  where MPN.SentMail_id=QI.SentMail_id
*/


