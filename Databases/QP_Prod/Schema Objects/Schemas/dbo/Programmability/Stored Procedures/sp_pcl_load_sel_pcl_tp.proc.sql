/* -------------------------------------------------------------- */
/* LOAD SEL_PCL                                                   */
/* This procedure returns the SEL_PCL data needed for the batch   */
/* Last Modified by:  Daniel Vansteenburg - 5/5/1999              */
/* DG 1/22/2004 - changed from dbo.Sel_PCL to dbo.PCL_PCL         */
CREATE PROCEDURE sp_pcl_load_sel_pcl_tp
 @batch_id int
AS
 SELECT p.survey_id, p.selcover_id
 INTO #pclloadselpcl
 FROM dbo.PCLNeeded_tp p
 where p.batch_id = @batch_id
 GROUP BY p.survey_id, p.selcover_id
 SELECT
   sp.Survey_ID, sp.QPC_ID, sp.Language, sp.CoverID, 'PCL' as Type, sp.Description, sp.X,
   sp.Y, sp. Width, sp.Height, sp.PCLStream, sp.KnownDimensions
 FROM
   dbo.PCL_PCL_tp sp, #pclloadselpcl tp
 WHERE sp.survey_id = tp.survey_id
 AND sp.coverid = tp.selcover_id

 DROP TABLE #pclloadselpcl


