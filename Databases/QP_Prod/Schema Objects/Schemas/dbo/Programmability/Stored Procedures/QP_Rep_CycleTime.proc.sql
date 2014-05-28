/*******************************************************************************
 *
 * Procedure Name:
 *           QP_Rep_CycleTime
 *
 * Description:
 *           Query data for cycle time report.
 *           This SP is used for both dashboard report and daily data loading for
 *           NRC dashboard(web)
 *
 * Parameters:
 *           N/A
 *
 * Return:
 *           0:      succeed
 *           others: failed
 *
 * History:
 *           1.0  01/08/2003 by Brian Mao
 *
 ******************************************************************************/
CREATE PROCEDURE QP_Rep_CycleTime
AS
  SELECT i.AD AS AcctDirector,
         i.ProjectNum,
         i.Survey_ID,
         i.FirstApply AS FirstApplyDate,
         i.SampleDate AS SampleCreateDate,
         i.TotalRolledback AS SampleRollbackTime,
         i.MailFrequency,
         i.SamplesInPeriod AS ProgrammedSamplesInPeriod,
         i.SamplesPulled AS SamplesInPTD,
         w.Dummy_Step AS MailingStep,
         w.MailingStep AS MailingStep_Nm,
         w.Scheduled AS DateScheduled,
         w.Sampled AS QtyScheduled,
         w.GenDate,
         w.Generated AS GenQty,
         ISNULL(r.GenRollBack, 0) AS GenRollBackTime,
         w.MailDate AS DateMailed,
         w.Mailed AS QtyMailed
    FROM dbo.TeamStatus_SampleInfo i
         JOIN dbo.TeamStatus_WorkCompleted w
           ON (i.Survey_ID = w.SurveyID
               AND CONVERT(varchar, i.SampleDate, 100) = w.SampleDate
              )
         LEFT OUTER JOIN (
               SELECT rol.Survey_ID,
                      rol.datSampleCreate_dt,
                      COUNT(*) GenRollBack
                 FROM dbo.TeamStatus_SampleInfo inf,
                      dbo.Rollbacks rol
                WHERE inf.Survey_ID = rol.Survey_ID
                  AND inf.SampleDate = rol.datSampleCreate_dt
                  AND rol.RollbackType = 'Generation'
                GROUP BY
                      rol.Survey_ID,
                      rol.datSampleCreate_dt
           ) r
           ON (i.Survey_ID = r.Survey_ID
               AND i.SampleDate = r.datSampleCreate_dt
              )
   WHERE i.RolledBack = 0
   ORDER BY
         i.AD,
         i.ProjectNum,
         i.Survey_ID,
         i.SampleDate,
         w.Dummy_Step

 IF @@ERROR <> 0
     RETURN 1
 ELSE
     RETURN 0


