CREATE VIEW PU_DueDate_View AS
SELECT rp.PU_ID,
       rp.DueDate
  FROM PUR_Report rp,
       PU_Plan pl
 WHERE rp.Status <> 201
   AND pl.PU_ID = rp.PU_ID
   AND pl.Status = 0
UNION
SELECT PU_ID,
       NextDueDate AS DueDate
  FROM PU_Plan
 WHERE Status = 0


