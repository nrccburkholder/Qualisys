/*******************************************************************************
 *
 * Procedure Name:
 *           GHS_ReportSubJob
 *
 * Description:
 *           Retrieve job's sub job info
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
CREATE PROCEDURE dbo.GHS_ReportSubJob (
        @Job_ID       int
       )
AS
  SELECT sj.SubJob_ID,
         sj.StartSeqNum,
         sj.EndSeqNum,
         sj.RecNum,
         st.SubTotal
    FROM GHS_MailMergeSubJobLog sj,
         (
          SELECT sj2.SubJob_ID,
                 SUM(sj1.RecNum) AS SubTotal
            FROM GHS_MailMergeSubJobLog sj1,
                 GHS_MailMergeSubJobLog sj2
           WHERE sj1.Job_ID = @Job_ID
             AND sj2.Job_ID = @Job_ID
             AND sj1.SubJob_ID <= sj2.SubJob_ID
           GROUP BY sj2.SubJob_ID
         ) st
   WHERE sj.Job_ID = @Job_ID
     AND sj.SubJob_ID = st.SubJob_ID
   ORDER BY sj.SubJob_ID
         
  RETURN -1


