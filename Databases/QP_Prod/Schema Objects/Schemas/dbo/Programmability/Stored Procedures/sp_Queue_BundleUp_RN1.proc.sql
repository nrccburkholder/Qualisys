/* v2.0.1 - Dave Gilsdorf - 2/4/2000  
   Each sheet in a mailing was contributing to bundle counts.  Should be each mailing piece.   
   Added DISTINCTs to INSERT INTO #TempWorkTable commands  
   v2.0.2 - Dave Gilsdorf - 2/9/2000  
   added ' and SP.Survey_id=<@survey_id> to the UPDATE command being built during the cursor loop  
   v2.0.3 - Felix Gomez 3/14/2002  
   added @strPclOutput  
   v2.0.4 - Dave Gilsdorf  
   modified to handle separate bunding of different mailing steps for double-stuffs  
   v2.0.5 - Ron Niewohner  
   Major rewrite to account procedual changes with PSI and Post Office.  
   Also, improved preformance.  
   v2.0.5a - Brian Dohmen
   The check for double stuff generation had a "=" changed to "<>".  So I changed it back so 
   double stuff jobs will bundle into two distinct bundles.
   v2.0.5b - Ron Niewohner 11/29/2004
   Added a check on datBundled if null rebundle it. For some reason everything but the date was getting populated. 
*/  
  
CREATE Procedure sp_Queue_BundleUp_RN1
as  
/** Creating the temp tables used in procedure **/  
CREATE TABLE #popbundle_cnts (  
  survey_id int,  
  paperconfig_id int,  
  zip4_flg tinyint,  
  bundle_cd varchar(6),  
  cnts int,  
  zip5 char(5), zip4 char(4), zip3 char(3),  
  groups char(9),  
  scheme char(3),  
  AADC char(3),  
  datBundled datetime  
 )  
 CREATE TABLE #popbundle (  
  survey_id int,  
  paperconfig_id int,  
  samplepop_id int,  
  sentmail_id int,  
  zip5 char(5), zip4 char(4), zip3 char(3),  
  PostalCode varchar(42),   
  bundle_cd varchar(6),  
  groups char(9),  
  scheme char(3),  
  AADC char(3),  
  datBundled datetime  
 )  
CREATE TABLE #TempWorkTable(  
  Survey_id int,  
  PaperConfig_id int,  
  SentMail_id int,  
  SamplePop_id int,  
  MailingStep_id int,  
  MMMailingStep_id int,  
  intSequence int,  
  datBundled datetime  
)  
CREATE TABLE #TempSurveyTable(  
  Survey_id int  
)  
CREATE TABLE #DoubleStuffs(  
  SamplePop_id int,  
  MMMailingStep_id int  
)  
CREATE TABLE #PSIBundle(  
  SentMail_id int,  
  bundle_cd  varchar(6),  
  groups char(9),  
  PostalCode varchar(42),  
  Zip5 char(5),  
  Zip4 char(4),  
  datBundled datetime  
)    
CREATE TABLE #GoingPostal(  
  Survey_id int,  
  PaperConfig_id int,  
  Cnt int)  
/** Creating the indexes on the temp tables **/  
CREATE INDEX IDX_Dedup ON #popbundle_cnts (survey_id, paperconfig_id, zip4_flg)   
CREATE INDEX IDX_TempSamplePop ON #TempWorkTable(SamplePop_id)  
CREATE INDEX IDX_TempSurvey_id ON #TempWorkTable(Survey_id)  
/*Declaring variable to be used as datBundled*/  
Declare @date datetime 
Select @date = getdate()  

  
/* Build this TempWorkTable before we build popbundle */  
INSERT INTO #TempWorkTable (Survey_id, PaperConfig_id, SentMail_id, SamplePop_id, MailingStep_id, MMMailingStep_id, intSequence, datBundled)  
SELECT DISTINCT MS.Survey_id, SM.PaperConfig_id, SM.SentMail_id, SC.SamplePop_id, MS.MailingStep_id, MS.MMMailingStep_id, MS.intSequence, @date  
FROM  QP_Queue.dbo.PCLOutput PO, dbo.SentMailing SM, dbo.ScheduledMailing SC, dbo.MailingStep MS  
WHERE PO.SentMail_id = SM.SentMail_id  
AND   SM.SentMail_id = SC.SentMail_id  
AND   SC.MailingStep_id = MS.MailingStep_id  
AND   (SM.strPostalBundle is NULL  
OR     SM.DatBundled is null) --Added for some datBundled were not getting set 

/* Get a list of all survey's that will be bundled */  
INSERT INTO #TempSurveyTable  
SELECT DISTINCT Survey_id  
FROM #TempWorkTable 
  
/* Rebundle all Surveys that were previously bundled, but not printed */  
/* AND, they have new surveys to bundle */  
INSERT INTO #TempWorkTable(Survey_id, PaperConfig_id, SentMail_id, SamplePop_id, MailingStep_id, MMMailingStep_id, intSequence, datBundled)  
SELECT DISTINCT MS.Survey_id, SM.PaperConfig_id, SM.SentMail_id, SC.SamplePop_id, MS.MailingStep_id, MS.MMMailingStep_id, MS.intSequence, @date  
FROM  QP_Queue.dbo.PCLoutPut PO, dbo.SentMailing SM, dbo.ScheduledMailing SC, #TempSurveyTable TsT, dbo.MailingStep MS   
WHERE PO.SentMail_id = SM.SentMail_id  
AND   SC.SentMail_id = SM.SentMail_id   
AND   SC.MailingStep_id = MS.MailingStep_id  
AND   SM.strPostalBundle IS NOT NULL  
AND   SM.datPrinted IS NULL   
AND   MS.Survey_id = TsT.Survey_id  

/* Getting the counts for the surveys and by paperconfig_id to be used to bundle to PVEND*/  
INSERT INTO #GoingPostal(Survey_id, PaperConfig_id, cnt)  
SELECT Survey_id, PaperConfig_id, count(*)  
FROM #TempWorkTable  
GROUP BY Survey_id, PaperConfig_id  
HAVING COUNT(*) < 500  
ORDER BY 3 DESC  
  
/* modify datBundled for anyone who has both double-stuff steps generated */  
INSERT INTO #DoubleStuffs (SamplePop_id, MMMailingStep_id)  
SELECT SamplePop_id, MMMailingStep_id  
FROM #tempworktable twt  
WHERE twt.mailingstep_id = mmmailingstep_id  
  
if @@rowcount>0  
begin  
  -- remove anyone from #DoubleStuffs if they only have one of the double-stuff steps for some reason.  
  delete ds  
  from #DoubleStuffs ds, (select twt.samplepop_id,ds.MMMailingStep_id, Count(*)cnt  
     from #tempworktable twt, #DoubleStuffs ds  
     where twt.samplepop_id=ds.samplepop_id  
     and twt.MMMailingStep_id=ds.MMMailingStep_id  
     group by twt.samplepop_id,ds.MMMailingStep_id  
     having count(*)=1) sub  
  where ds.samplepop_id=sub.samplepop_id  
  and ds.MMMailingStep_id=sub.MMMailingStep_id  
  
  update twt  
  set datbundled = dateadd(minute,intSequence,datbundled)  
  from #tempworktable twt, #DoubleStuffs ds  
  where twt.samplepop_id=ds.samplepop_id  
  and twt.MMMailingStep_id=ds.MMMailingStep_id  
end  
  
/* Populate #PopBundlePSI with the data, for each Study's Population that is in #TempWorkTable that will be going to PSI   
   This will also set the bundle codes for 'CAN', 'FOR' and 'EMAAD'*/   
INSERT INTO #PSIBundle(sentmail_id, bundle_cd, groups, PostalCode, Zip5, Zip4, datBundled)  
SELECT twt.SentMail_id,   
 CASE WHEN PostalCode is not null THEN 'CAN'  
      WHEN Zip5 = '99999' THEN 'FOR'  
      ELSE 'PVEND'  
 END,  
 SUBSTRING(bc.Zip5,1,3),  
 PostalCode, Zip5, Zip4, twt.datBundled  
FROM #TempWorkTable twt, BundlingCodes bc  
WHERE twt.SentMail_id = bc.SentMail_id  
AND  (bc.PostalCode is not null  
or    bc.Zip5 = '99999'   
or    bc.Zip4 is null)  
  
/* Now for the ones that are too small (<= 500) per survey_id and paperconfig_id. These are removed now so they do not slow down the Postal Bundling below*/   
INSERT INTO #PSIBundle(sentmail_id, bundle_cd, groups, PostalCode, Zip5, Zip4, datBundled)  
SELECT twt.SentMail_id, 'PVEND', SUBSTRING(bc.Zip5,1,3), PostalCode, Zip5, Zip4, datBundled  
FROM #TempWorkTable twt, BundlingCodes bc, #GoingPostal gp  
WHERE twt.SentMail_id = bc.SentMail_id  
and   twt.Survey_id = gp.Survey_id  
and   twt.PaperConfig_id = gp.PaperConfig_id  
and   not exists (Select * from #PSIBundle pb where pb.SentMail_id = twt.SentMail_id)  
  
/* Now we are dealing with the rest...*/  
/* Inserting the rest into #popBundle*/   
--Truncate table #PopBundle  
INSERT INTO #PopBundle(survey_id,paperconfig_id,samplepop_id,sentmail_id,zip5,zip4,zip3,PostalCode, datBundled)  
SELECT survey_id, paperconfig_id, samplepop_id, twt.sentmail_id, zip5, zip4, SUBSTRING(zip5,1,3), PostalCode, datBundled  
FROM #TempWorkTable twt, BundlingCodes bc   
WHERE not Exists (SELECT * FROM #PSIBundle pb WHERE pb.SentMail_id = twt.SentMail_id and pb.datBundled = twt.datBundled)  
and twt.SentMail_id = bc.SentMail_id  
  
/* Update #popbundle's scheme and aadc value from USPS */  
UPDATE p  
SET    scheme = u.scheme,  
       aadc = u.aadc  
FROM #popbundle p, dbo.usps u  
WHERE p.zip3 = u.zip3_cd  
  
/*A's */  
INSERT INTO #popbundle_cnts (Survey_id, PaperConfig_id, Zip4_flg, Bundle_cd, zip5, cnts,datBundled)  
  SELECT survey_id, paperconfig_id,   
   CASE WHEN zip4 IS NOT NULL THEN 1 ELSE NULL END,   
   CASE WHEN zip4 IS NOT NULL THEN 'A'+ zip5 ELSE NULL END ,   
   Zip5, count(*),datBundled FROM #popbundle p  
  WHERE p.Bundle_cd IS NULL  
  GROUP BY survey_id, paperconfig_id,   
   CASE WHEN zip4 IS NOT NULL THEN 1 ELSE NULL END,   
   CASE WHEN zip4 IS NOT NULL THEN 'A'+ zip5 ELSE NULL END, Zip5, datBundled  
  HAVING COUNT(*) >= 150  
  
 UPDATE #PopBundle  
  SET #PopBundle.Bundle_cd = pbc.Bundle_cd  
  FROM #PopBundle_cnts pbc  
  WHERE #PopBundle.survey_id = pbc.survey_id  
   AND #PopBundle.paperconfig_id = pbc.paperconfig_id  
   AND #PopBundle.Zip5 = pbc.Zip5   
   AND #PopBundle.datBundled = pbc.datBundled  
   AND ( (#PopBundle.Zip4 IS NULL AND pbc.Zip4_flg IS NULL) OR  
    (#PopBundle.Zip4 IS NOT NULL AND pbc.Zip4_flg IS NOT NULL))  
   AND #PopBundle.Bundle_cd IS NULL  
  
 TRUNCATE TABLE #PopBundle_cnts  
  
/* B's */  
 INSERT INTO #popbundle_cnts (Survey_id, PaperConfig_id, Zip4_flg, Bundle_cd, Scheme, cnts, datBundled)  
  SELECT survey_id, paperconfig_id,   
   CASE WHEN zip4 IS NOT NULL THEN 1 ELSE NULL END,   
   CASE WHEN zip4 IS NOT NULL THEN 'B'+ scheme ELSE NULL END,   
   Scheme, COUNT(*), datBundled  
  FROM #popbundle p  
  WHERE scheme is not null  
   AND p.Bundle_cd IS NULL  
  GROUP BY survey_id, paperconfig_id,   
   CASE WHEN zip4 IS NOT NULL THEN 1 ELSE NULL END,   
   CASE WHEN zip4 IS NOT NULL THEN 'B'+ scheme ELSE NULL END,  
   Scheme, datBundled  
  HAVING COUNT(*) >= 150  
  
 UPDATE #PopBundle  
  SET #PopBundle.Bundle_cd = pbc.Bundle_cd  
  FROM #PopBundle_cnts pbc  
  WHERE #PopBundle.survey_id = pbc.survey_id  
   AND #PopBundle.paperconfig_id = pbc.paperconfig_id  
   AND #PopBundle.datBundled = pbc.datBundled  
   AND ( (#PopBundle.Zip4 IS NULL AND pbc.Zip4_flg IS NULL) OR  
    (#PopBundle.Zip4 IS NOT NULL AND pbc.Zip4_flg IS NOT NULL))  
   AND #PopBundle.Scheme = pbc.Scheme  
   AND #PopBundle.Bundle_cd IS NULL  
  
 TRUNCATE TABLE #PopBundle_cnts  
  
/* C's */  
 INSERT INTO #popbundle_cnts (Survey_id, PaperConfig_id, Zip4_flg, Bundle_cd, zip3, cnts, datBundled)  
  SELECT survey_id, paperconfig_id,   
   CASE WHEN zip4 IS NOT NULL THEN 1 ELSE NULL END,   
   CASE WHEN zip4 IS NOT NULL THEN 'C'+ zip3 ELSE NULL END,   
   zip3, count(*), datBundled  
  FROM #popbundle p  
  WHERE p.Bundle_cd IS NULL  
  GROUP BY survey_id, paperconfig_id,   
   CASE WHEN zip4 IS NOT NULL THEN 1 ELSE NULL END,   
   CASE WHEN zip4 IS NOT NULL THEN 'C'+ zip3 ELSE NULL END,  
   zip3, datBundled  
  HAVING COUNT(*) >= 150  
  
 UPDATE #PopBundle  
  SET #PopBundle.Bundle_cd = pbc.Bundle_cd  
  FROM #PopBundle_cnts pbc  
  WHERE #PopBundle.survey_id = pbc.survey_id  
   AND #PopBundle.paperconfig_id = pbc.paperconfig_id  
   AND ( (#PopBundle.Zip4 IS NULL AND pbc.Zip4_flg IS NULL) OR  
    (#PopBundle.Zip4 IS NOT NULL AND pbc.Zip4_flg IS NOT NULL))  
   AND #PopBundle.Zip3 = pbc.Zip3  
   AND #PopBundle.datBundled = pbc.datBundled  
   AND #PopBundle.Bundle_cd IS NULL  
  
 TRUNCATE TABLE #PopBundle_cnts  
  
/* D's */  
 INSERT INTO #popbundle_cnts (Survey_id, PaperConfig_id, Zip4_flg, Bundle_cd, aadc, cnts, datBundled)  
  SELECT survey_id, paperconfig_id,   
   CASE WHEN zip4 IS NOT NULL THEN 1 ELSE NULL END,   
   CASE WHEN zip4 IS NOT NULL THEN 'D'+ aadc ELSE NULL END,   
   aadc, count(*), datBundled  
  FROM #popbundle p  
  WHERE p.AADC IS NOT NULL  
   AND p.Bundle_cd IS NULL  
  GROUP BY survey_id, paperconfig_id,   
   CASE WHEN zip4 IS NOT NULL THEN 1 ELSE NULL END,   
   CASE WHEN zip4 IS NOT NULL THEN 'D'+ aadc ELSE NULL END,   
   aadc, datBundled  
  HAVING COUNT(*) >= 150  
  
 UPDATE #PopBundle  
  SET #PopBundle.Bundle_cd = pbc.Bundle_cd  
  FROM #PopBundle_cnts pbc  
  WHERE #PopBundle.survey_id = pbc.survey_id  
   AND #PopBundle.paperconfig_id = pbc.paperconfig_id  
   AND ( (#PopBundle.Zip4 IS NULL AND pbc.Zip4_flg IS NULL) OR  
    (#PopBundle.Zip4 IS NOT NULL AND pbc.Zip4_flg IS NOT NULL))  
   AND #PopBundle.AADC = pbc.AADC  
   AND #PopBundle.datBundled = pbc.datBundled  
   AND #PopBundle.Bundle_cd IS NULL  
  
 TRUNCATE TABLE #PopBundle_cnts  
 
/*Updating the bundle code to EMAAD on what is left in the #PopBundle table
  This should be every one that did not qualify for any of the A, B, C, or D classifications */
UPDATE #PopBundle
   SET Bundle_cd = 'EMAAD'
 WHERE Bundle_cd is null 

/* Clearing the #Going Postal table for round 2 */  
TRUNCATE TABLE #GoingPostal  
/*Getting Survey_id and Paperconfig that qualify for the postal discount*/  
INSERT INTO #GoingPostal(Survey_id, PaperConfig_id, Cnt)  
Select Survey_id, PaperConfig_id, count(*)   
from #PopBundle  
group by Survey_id, PaperConfig_id  
Having Count(*) >= 500  
Order by 1,2  
  
/*Inserting the last of the non-qualifing records into the #PSIBundle as 'PVEND'(< 500 items per Survey_id and Paperconfig_id combo)*/  
INSERT INTO #PSIBundle(sentmail_id, bundle_cd, groups, PostalCode, Zip5, Zip4)  
SELECT SentMail_id, 'PVEND', groups, PostalCode, Zip5, Zip4  
FROM #PopBundle pb  
WHERE NOT EXISTS(SELECT * FROM #GoingPostal gp WHERE gp.Survey_id = pb.Survey_id and gp.PaperConfig_id = pb.PaperConfig_id)  
  
/* Removing the last of the non-qualifing recors all that remains should be good for the postal discount */  
DELETE #PopBundle  
WHERE NOT EXISTS(SELECT * FROM #GoingPostal gp WHERE gp.Survey_id = #PopBundle.Survey_id and gp.PaperConfig_id = #PopBundle.PaperConfig_id)  
  
/* Now assign the correct Groups to each popbundle record */  
UPDATE #popbundle  
 SET GROUPS = CASE SUBSTRING(bundle_cd,1,1)  
   WHEN 'B' THEN p.Zip3  
   WHEN 'D' THEN p.Zip3
   WHEN 'E' THEN 'A'+p.AADC
   WHEN 'P' THEN 'M'+p.AADC
   ELSE NULL END  
  FROM #popbundle p  
  
UPDATE #PSIbundle  
 SET GROUPS = CASE SUBSTRING(bundle_cd,1,1)  
   WHEN 'E' THEN 'A'+Substring(Zip5, 1, 3)
   WHEN 'P' THEN 'M'+Substring(Zip5, 1, 3)
   ELSE NULL END  
  FROM #PSIbundle   p  

/*Now we update SentMailing */  
 UPDATE sm  
  SET strPostalBundle = p.Bundle_cd,  
       strGroupDest = p.Groups,  
       datBundled= p.DatBundled  
  FROM dbo.sentmailing sm, #PSIbundle p  
  WHERE sm.sentmail_id = p.sentmail_id  
  
 UPDATE sm  
  SET strPostalBundle = p.Bundle_cd,  
       strGroupDest = p.Groups,  
       datBundled= p.DatBundled  
  FROM dbo.sentmailing sm, #popbundle p  
  WHERE sm.sentmail_id = p.sentmail_id  
  
/*Lastly we update NPSentMailing */  
 UPDATE sm  
  SET strPostalBundle = p.Bundle_cd,  
       strGroupDest = p.Groups,  
       datBundled= p.DatBundled  
  FROM dbo.NPsentmailing sm, #PSIbundle p  
  WHERE sm.sentmail_id = p.sentmail_id  
  
 UPDATE sm  
  SET strPostalBundle = p.Bundle_cd,  
       strGroupDest = p.Groups,  
       datBundled= p.DatBundled  
  FROM dbo.NPsentmailing sm, #popbundle p  
  WHERE sm.sentmail_id = p.sentmail_id  
/* Cleaning up temp tables*/  
DROP TABLE #popbundle_cnts  
DROP TABLE #popbundle  
DROP TABLE #TempWorkTable  
DROP TABLE #TempSurveyTable  
DROP TABLE #DoubleStuffs  
DROP TABLE #PSIBundle  
DROP TABLE #GoingPostal


