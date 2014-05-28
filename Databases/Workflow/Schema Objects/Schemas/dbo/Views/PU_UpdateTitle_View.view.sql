CREATE VIEW PU_UpdateTitle_View AS
SELECT DISTINCT
       rp.PUReport_ID,
       ISNULL(rh.Title,
              CASE pl.TitleType
                WHEN 1 THEN cl.strClient_NM
                ELSE pl.PuName
                END
             ) AS Title
  FROM PUR_Report rp
       JOIN PU_Plan pl
         ON pl.PU_ID = rp.PU_ID
       JOIN Client_View cl
         ON cl.Client_ID = pl.Client_ID
       LEFT JOIN PUR_ResultHeadInfo rh
         ON rh.PUReport_ID = rp.PUReport_ID


