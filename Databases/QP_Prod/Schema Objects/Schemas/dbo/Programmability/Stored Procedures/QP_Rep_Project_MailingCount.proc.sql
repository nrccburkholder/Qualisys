--=============================================================


CREATE PROCEDURE QP_Rep_Project_MailingCount    
  
 @StartDate datetime,         -- Start date of dashboard report    
 @EndDate datetime,             -- End date of dashboard report    
 @Weight decimal(4, 2) = 1.65   -- Weighted factor for multi-page projects    
                                -- default weight is 1.65    
AS    

-- =======================================================  
-- Revision:

-- Modified 7/11/2005 - Identified and split out fullfillment methodologies  

-- MWB - 1/15/2009  Added ContractNumber to report for 
-- SalesLogix integration
-- =======================================================  
  

-- Testing Variables  
--  declare  
--   @StartDate datetime,         -- Start date of dashboard report    
--   @EndDate datetime,             -- End date of dashboard report    
--   @Weight decimal(4, 2) --= 1.65   -- Weighted factor for multi-page projects    
--   
--  set @startdate = '6/1/2005'  
--  set @enddate = '6/30/2005'  
--  set @weight = 1.65  
  
-- MAIL Fullfillment  
  
SELECT  t2.MailingStepMethod_nm AS 'Fullfillment Method', t2.Project, t2.ContractNumber, t2.[1 Page], t2.[2 Pages], t2.[Total Outgo], t2.[Total Outgo (Weighted)]   
FROM (  
-- Mail Fullfillment  
  SELECT msm.MailingStepMethod_nm, msm.MailingStepMethod_id,  
     SUBSTRING(ss.strSampleSurvey_nm, 1, 4) AS Project, isNull(sd.Contract, 'Missing') as ContractNumber, 
         SUM(CASE ms.INTPAGES  
              WHEN 1 THEN ms.MAILCOUNT  
              ELSE 0  
              END  
            )   
     AS '1 Page',  
         SUM(CASE ms.INTPAGES  
              WHEN 1 THEN 0  
              ELSE  ms.MAILCOUNT  
              END  
            ) AS '2 Pages',  
         SUM(ms.MAILCOUNT) AS 'Total Outgo',  
         CAST(ROUND(SUM(ms.MAILCOUNT *  
             (  
              CASE ms.INTPAGES  
              WHEN 1 THEN 1  
              ELSE @Weight  
              END  
             )  
            ), 0) AS INT) AS 'Total Outgo (Weighted)'  
  FROM	MAILINGSUMMARY ms,    
		SAMPLESET ss, 
		Survey_def sd,
		MailingStep mst,   
		MailingStepMethod msm  
  WHERE ms.DATMAILED BETWEEN @StartDate    
                     AND @EndDate    
  AND ms.SAMPLESET_ID = ss.SAMPLESET_ID    
  AND ms.MailingStep_id = mst.MailingStep_id  
  AND mst.MailingStepMethod_id = msm.MailingStepMethod_id 
  AND ss.Survey_ID = sd.Survey_ID 
  AND msm.mailingstepmethod_id = 0  
  GROUP BY msm.MailingStepMethod_nm, msm.MailingStepMethod_id, SUBSTRING(ss.strSampleSurvey_nm, 1, 4),sd.Contract    
 UNION ALL  
-- Other Fullfillment (PHONE, Web ...)  
  SELECT msm.MailingStepMethod_nm, msm.MailingStepMethod_id,  
     SUBSTRING(ss.strSampleSurvey_nm, 1, 4) AS Project, isNull(sd.Contract, 'Missing') as ContractNumber,
         SUM(CASE ms.INTPAGES    
              WHEN 1 THEN ms.MAILCOUNT    
              ELSE 0    
              END    
            ) AS '1 Page',    
         SUM(CASE WHEN ms.INTPAGES IN (0,1)  
              THEN 0    
              ELSE  ms.MAILCOUNT    
              END    
            ) AS '2 Pages',    
         SUM(ms.MAILCOUNT) AS 'Total Outgo',    
         CAST(ROUND(SUM(ms.MAILCOUNT *    
             (    
              CASE WHEN ms.INTPAGES  IN (0,1)  
      THEN 1    
              ELSE @Weight    
              END    
             )    
            ), 0) AS INT) AS 'Total Outgo (Weighted)'    
  FROM	MAILINGSUMMARY ms,    
		SAMPLESET ss,  
		Survey_def sd,  
		MailingStep mst,   
		MailingStepMethod msm  
  WHERE ms.DATMAILED BETWEEN @StartDate    
                     AND @EndDate    
  AND ms.SAMPLESET_ID = ss.SAMPLESET_ID    
  AND ss.Survey_ID = sd.Survey_ID 
  AND ms.MailingStep_id = mst.MailingStep_id  
  AND mst.MailingStepMethod_id = msm.MailingStepMethod_id  
  AND msm.mailingstepmethod_id > 0  
  GROUP BY msm.MailingStepMethod_nm, msm.MailingStepMethod_id, SUBSTRING(ss.strSampleSurvey_nm, 1, 4),sd.Contract    
) t2 ORDER BY t2.MailingStepMethod_id, Project


