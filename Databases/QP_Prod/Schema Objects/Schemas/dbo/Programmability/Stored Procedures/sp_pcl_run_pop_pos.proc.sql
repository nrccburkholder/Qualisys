/* This stored procedure is the triggered procedure that PCLGen will run in order to
** get the sp_pcl_population_pos_tables to run in background.  This procedure will
** create jobs that will be run by SQL Executive and will automatically delete themselves
** once the job has completed successfully.  Errors will be sent to the default
** operator, Donald Stavneak (in QualPro params it is DBA).
** Created: Daniel Vansteenburg, Cap Gemini America, LLC
** Date:  5/20/1999
** Notes: 
** Modifications:
** 7/23/99 Daniel Vansteenburg, CGA - Added code to allow this to be used for rescheduling also.
** 7/26/99 Daniel Vansteenburg, CGA - Added code to use the WaitSecs parameter to set the retry
**                                    delay value (@retrydelay).
** 8/02/99 Daniel Vansteenburg, CGA - Removed all code, we won't need this anymore in the future.
*/
create procedure sp_pcl_run_pop_pos
 @batch_id int
as
 RETURN


