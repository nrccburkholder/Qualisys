/*******************************************************************************
 *
 * Procedure Name:
 *           GHS_InsertSubJobLog
 *
 * Description:
 *           Save mail merge sub job info to log table
 *
 * Parameters:
 *           {parameter}  {data type}
 *              {brief parameter description}
 *           ...
 *
 * Return:
 *           -1:     Succeed
 *           Others: Failed
 *
 * History:
 *           1.0  10/31/2005 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.GHS_InsertSubJobLog (
        @Job_ID              int,
        @SubJob_ID           smallint,
        @RecNum               int,
        @StartRespondent_ID  int,
        @EndRespondent_ID    int,
        @StartSeqNum         int,
        @EndSeqNum           int
       )
AS
  INSERT INTO GHS_MailMergeSubJobLog (
          Job_ID,
          SubJob_ID,
          RecNum,
          StartRespondent_ID,
          EndRespondent_ID,
          StartSeqNum,
          EndSeqNum
         )
  VALUES (
          @Job_ID,
          @SubJob_ID,
          @RecNum,
          @StartRespondent_ID,
          @EndRespondent_ID,
          @StartSeqNum,
          @EndSeqNum
         )
         
  RETURN -1


