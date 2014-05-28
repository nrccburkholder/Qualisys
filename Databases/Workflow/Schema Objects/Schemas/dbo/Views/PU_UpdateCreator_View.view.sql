CREATE VIEW PU_UpdateCreator_View AS
SELECT DISTINCT
       pl.PU_ID,
       pl.Team_ID,
       em.Employee_ID,
       em.strEmployee_First_NM,
       em.strEmployee_Last_NM
  FROM PU_Plan pl,
       PUR_Report rp,
       Employee em
 WHERE pl.Status = 0
   AND rp.PUReport_ID = ISNULL(pl.NextPUReport_ID, pl.LastPUReport_ID)
   AND em.Employee_ID = ISNULL(rp.ModifiedBy, rp.CreatedBy)


